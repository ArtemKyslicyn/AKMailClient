//
//  DetailViewController.h
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UsernameKey;
extern NSString * const PasswordKey;
extern NSString * const HostnameKey;
extern NSString * const FetchFullMessageKey;


@protocol AKSettingsViewControllerDelegate;

@interface AKSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *hostnameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *fetchFullMessageSwitch;

- (IBAction)done:(id)sender;
- (IBAction)clearCacheAction:(id)sender;

@end