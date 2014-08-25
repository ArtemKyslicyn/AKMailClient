//
//  AKMailManager.m
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AKMailManager.h"
#import "AKModel.h"

static  NSString * const kDefaultMailBoxFolder = @"INBOX";
static  NSString * const kMailCountKey         = @"kMailCountKey";


@interface AKMailManager ()

@property (nonatomic,retain) MCOIMAPSession * imapSession;

@end


@implementation AKMailManager;

-(id)init{
    self =[super init];
    
    if(self){
        self.imapSession = [[MCOIMAPSession alloc] init];
      
        self.requestKind = (MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure |
                            MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject |
                            MCOIMAPMessagesRequestKindFlags);
        self.folder = kDefaultMailBoxFolder;
              
    }
    
    return self;
}

-(void)setIMAPUserAccountSettingsHostName:(NSString*)hostname port:(int)port username:(NSString*)username password:(NSString*)password
{
    [self.imapSession setHostname:hostname];
    [self.imapSession setPort:port];
    [self.imapSession setUsername:username];
    [self.imapSession setPassword:password];
    [self.imapSession setConnectionType:MCOConnectionTypeTLS];

}

-(void)getIMAPMailHeadersWithCountForLoadedMail:(int)сountCoreDataMail complete:(void (^)( NSArray * fetchedMessages, MCOIndexSet * vanishedMessages, BOOL newMailRecived))completionBlock fail:(void (^)(NSError* error))failBlock{
    
 
    MCOIMAPFolderInfoOperation *inboxFolderInfo = [self.imapSession folderInfoOperation:self.folder];


    [inboxFolderInfo start:^(NSError *error, MCOIMAPFolderInfo *info)
     {
         if(!error){
         self.totalNumberOfInboxMessages = [info messageCount];
         
          MCORange range;
          NSInteger countOfNewMessages =  self.totalNumberOfInboxMessages - сountCoreDataMail;
          
         
         
         if(countOfNewMessages > 0){
             if(сountCoreDataMail == 0){
                 range =MCORangeMake(0, 1);
             }else{
                 
                 range = MCORangeMake(0, UINT64_MAX - countOfNewMessages);
             }
             
             
             MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:range];
             
             MCOIMAPFetchMessagesOperation *fetchOperation = [self.imapSession fetchMessagesByUIDOperationWithFolder:self.folder requestKind:self.requestKind uids:uids];
             
             [fetchOperation setProgress:^(unsigned int progress) {
                 NSLog(@"Progress: %u of %u", progress, countOfNewMessages);
             }];
             
             [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
                 //We've finished downloading the messages!
                 //Let's check if there was an error:
                 
                 if(error) {
                     NSLog(@"Error downloading message headers:%@", error);
                     failBlock(error);
                 }else{
                     completionBlock(fetchedMessages,vanishedMessages,YES);
                     NSLog(@"The post man delivereth:%@", fetchedMessages);
                 }
                 
             }];
         }else{
             //if we haven't new mail we send nil 
             completionBlock(nil,nil,NO);
         }
         }else{
             failBlock(error);
         }
     }];

}

-(void)getMailHTMLBodyForMessageUID:(NSUInteger)uid complete:(void (^)(NSString* msgHTMLBody))completionBlock fail:(void (^)(NSError* error))failBlock{
    
    MCOIMAPFetchContentOperation *operation = [self.imapSession fetchMessageByUIDOperationWithFolder:self.folder uid:uid];
    
    [operation start:^(NSError *error, NSData *data) {
        
        if (error||!data) {
            failBlock(error);
        }else{
            MCOMessageParser *messageParser = [[MCOMessageParser alloc] initWithData:data];
            NSString *msgHTMLBody = [messageParser htmlBodyRendering];
            completionBlock(msgHTMLBody);
        }
        
    }];
}

@end
