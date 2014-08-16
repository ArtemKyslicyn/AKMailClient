//
//  AKMailMessage.h
//  AKMailClientApp
//
//  Created by Arcilite on 15.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AKMailMessage : NSManagedObject

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSDate * recivedData;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * htmlBody;

@end
