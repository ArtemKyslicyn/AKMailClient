//
//  AKMailMessage.h
//  AKMailClientApp
//
//  Created by Arcilite on 15.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


@interface AKMailMessage : NSManagedObject

@property (nonatomic, retain) NSNumber *uid;
@property (nonatomic, retain) NSDate   *recivedData;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *htmlBody;

@end
