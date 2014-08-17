//
//  AKMailManager.h
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import  "MailCore/MailCore.h"

@interface AKMailManager : NSObject

@property(nonatomic,copy) NSString * folder;
@property(nonatomic,assign) MCOIMAPMessagesRequestKind requestKind;
@property (nonatomic,assign) NSInteger totalNumberOfInboxMessages;

-(void)getMailHTMLBodyForMessageUID:(int)uid complete:(void (^)(NSString* msgHTMLBody))completionBlock fail:(void (^)(NSError* error))failBlock;

-(void)getIMAPMailHeadersWithCountForLoadedMail:(NSInteger)сountCoreDataMail complete:(void (^)( NSArray * fetchedMessages, MCOIndexSet * vanishedMessages,BOOL newMailRecived))completionBlock fail:(void (^)(NSError* error))failBlock;

-(void)setIMAPUserAccountSettingsHostName:(NSString*)hostname port:(int)port username:(NSString*)username password:(NSString*)password;

@end
