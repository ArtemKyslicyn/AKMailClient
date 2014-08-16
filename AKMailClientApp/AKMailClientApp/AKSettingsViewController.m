//
//  DetailViewController.h
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AKSettingsViewController.h"
#import "FXKeychain.h"

NSString * const UsernameKey = @"username";
NSString * const PasswordKey = @"password";
NSString * const HostnameKey = @"hostname";
NSString * const FetchFullMessageKey = @"FetchFullMessageEnabled";
NSString * const OAuthEnabledKey = @"OAuth2Enabled";

@implementation AKSettingsViewController

- (void)done:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text ?: @"" forKey:UsernameKey];
    [[FXKeychain defaultKeychain] setObject:self.passwordTextField.text ?: @"" forKey:PasswordKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.hostnameTextField.text ?: @"" forKey:HostnameKey];
    [[NSUserDefaults standardUserDefaults] setBool:[self.fetchFullMessageSwitch isOn] forKey:FetchFullMessageKey];
    [[NSUserDefaults standardUserDefaults] setBool:[self.useOAuth2Switch isOn] forKey:OAuthEnabledKey];
    
    //[self.delegate settingsViewControllerFinished:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.emailTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:UsernameKey];
    self.passwordTextField.text = [[FXKeychain defaultKeychain] objectForKey:PasswordKey];
    self.hostnameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:HostnameKey];
    self.fetchFullMessageSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:FetchFullMessageKey];
    self.useOAuth2Switch.on = [[NSUserDefaults standardUserDefaults] boolForKey:OAuthEnabledKey];
}

@end
