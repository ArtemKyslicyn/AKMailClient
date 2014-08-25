//
//  AKModel.h
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AKCoreDataProvider.h"
#import "AKMailManager.h"
#import "Reachability.h"

@interface AKModel : NSObject

@property (nonatomic, retain) AKCoreDataProvider *dataSource;
@property (nonatomic, retain) AKMailManager      *mailManager;
@property (nonatomic, retain) Reachability       *recahbility;

+ (AKModel *)sharedManager;
- (void)syncInboxComplete:(void (^)(BOOL isNewMailRcived))complete
                     fail:(void (^)(NSError *fail))fail;
- (void)loadBodyForMailsComplete:(void (^)())complete
                            fail:(void (^)(NSError *fail))fail;

@end
