//
//  AKMailCell.h
//  AKMailClientApp
//
//  Created by Arcilite on 13.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKMailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

@end
