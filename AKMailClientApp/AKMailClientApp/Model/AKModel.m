//
//  AKModel.m
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AKModel.h"
#import  "MailCore/MailCore.h"
#import  "AKMailManager.h"
#import "AKCoreDataProvider.h"

static NSString* const kAKException = @"You Can't create instance for singleton";
static NSString* const kAKExceptionReason = @"You Trying to call new for singleton";

@implementation AKModel

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

-(void)syncInboxComplete:(void(^)(BOOL isNewMailRcived))complete fail:(void(^)(NSError *fail))fail {
    
    int countOfMailInDB = [_dataSource countOfMailsInCoreData];
    
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
    
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


@end
