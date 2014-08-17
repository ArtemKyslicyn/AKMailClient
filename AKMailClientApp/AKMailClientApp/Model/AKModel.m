//
//  AKModel.m
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AKModel.h"
#import "MailCore/MailCore.h"
#import "AKMailManager.h"
#import "AKCoreDataProvider.h"
#import "AKSettingsViewController.h"
#import  "AKMailMessage.h"
#import "FXKeychain.h"
static NSString* const kAKException = @"You Can't create instance for singleton";
static NSString* const kAKExceptionReason = @"You Trying to call new for singleton";

@implementation AKModel{
    BOOL _isFetchFullMessage;
}

static id _sharedInstance;

+ (id)sharedManager {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _dataSource  = [AKCoreDataProvider new];
        _mailManager = [AKMailManager new];
        //[self syncInbox];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = nil;
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id)new
{
    NSException *exception = [[NSException alloc] initWithName:kAKException
                                                        reason:kAKExceptionReason
                                                      userInfo:nil];
    [exception raise];
    
    return nil;
}

-(void)syncInboxComplete:(void(^)(BOOL isNewMailRecived))complete fail:(void(^)(NSError *fail))fail {
    
    int countOfMailInDB = [_dataSource countOfMailsInCoreData];
    if ([self loadSettings]) {
        //GET mail headers
        [_mailManager getIMAPMailHeadersWithCountForLoadedMail:countOfMailInDB
        complete:^( NSArray * fetchedMessages, MCOIndexSet * vanishedMessages, BOOL newMailRecived){
                                                          
                if (newMailRecived) {
                    [_dataSource  saveNewMailArrayToDB:fetchedMessages];
                            complete(YES);
                                                            
                        }else{
                            complete(NO);
                        }
                                                          
                   }
                 fail:^(NSError* error){
                       fail(error);
                 }];
    }else{
        fail(nil);
    }
    
    
}

-(void)loadBodyForMailsComplete:(void(^)())complete fail:(void(^)(NSError *fail))fail {
    if (_isFetchFullMessage) {
        
        [self getMailBodyForAllHeaderComplete:^{
            complete();
        } fail:^(NSError *error) {
            fail(error);
        }];
        
        
    }else{
        complete();
    }
}

-(void)getMailBodyForAllHeaderComplete:(void(^)())complete fail:(void(^)(NSError *fail))fail{
    
    NSArray * mailHeadersArray = [_dataSource arrayOfMailsInCoreData];
    __block int countHeaders = [mailHeadersArray count];
    for (__block AKMailMessage* message in mailHeadersArray) {
        [_mailManager getMailHTMLBodyForMessageUID:[message.uid unsignedIntValue] complete:^(NSString *msgHTMLBody) {
            
            AKMailMessage * mailMessage = [self.dataSource getMessageForManagedID:message.objectID]; //We get current context mananged object
            
            NSLog(@"HTML %@",msgHTMLBody);
            mailMessage.htmlBody = msgHTMLBody;
            [_dataSource saveContext];
            countHeaders--;
            if (countHeaders<1) {
                complete();
            }
        }fail:^(NSError *error) {
             countHeaders--;
            if (countHeaders<1) {
                 fail(error);
            }
        }];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (countHeaders>0) {
             NSLog(@"Time OUT ");
            fail([NSError init]);
        }
       
    });
  
    
}

-(BOOL)loadSettings{
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:UsernameKey];
	NSString *password = [[FXKeychain defaultKeychain] objectForKey:PasswordKey];
	NSString *hostname = [[NSUserDefaults standardUserDefaults] objectForKey:HostnameKey];
    _isFetchFullMessage =[[NSUserDefaults standardUserDefaults] boolForKey:FetchFullMessageKey];
    if (username.length>0 && password.length>0) {
    
        [_mailManager setIMAPUserAccountSettingsHostName:hostname port:993 username:username password:password];
        return YES;
   
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning",@"") message:NSLocalizedString(@"You have not saved mail Account",@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    
    
}



- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


@end
