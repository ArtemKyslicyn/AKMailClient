//
//  AKModel.h
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import  <Foundation/Foundation.h>
#import  "AKCoreDataProvider.h"
#import  "AKMailManager.h"
@interface AKModel : NSObject

@property (nonatomic,retain) AKCoreDataProvider * dataSource;
@property (nonatomic,retain) AKMailManager * mailManager;



+ (AKModel*)sharedManager;

-(void)syncInboxComplete:(void(^)(BOOL isNewMailRcived))complete fail:(void(^)(NSError *fail))fail;

@end
