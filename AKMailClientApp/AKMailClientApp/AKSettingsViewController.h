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
extern NSString * const OAuthEnabledKey;

@protocol AKSettingsViewControllerDelegate;

@interface AKSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *hostnameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *fetchFullMessageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *useOAuth2Switch;

@property (nonatomic, weak) id<AKSettingsViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;

@end

@protocol SettingsViewControllerDelegate <NSObject>
- (void)settingsViewControllerFinished:(AKSettingsViewController *)viewController;
@end