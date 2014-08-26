//
//  DetailViewController.h
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


@class AKMailMessage;

@interface AKMailDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) AKMailMessage *messageItem;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
