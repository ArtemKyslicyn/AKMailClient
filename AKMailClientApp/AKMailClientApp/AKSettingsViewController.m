//
//  DetailViewController.h
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AKSettingsViewController.h"
#import "FXKeychain.h"

NSString * const UsernameKey         = @"username";
NSString * const PasswordKey         = @"password";
NSString * const HostnameKey         = @"hostname";
NSString * const FetchFullMessageKey = @"FetchFullMessageEnabled";

@implementation AKSettingsViewController{
    NSString * _email;
}

- (void)done:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text ? :@"" forKey:UsernameKey];
    [[FXKeychain defaultKeychain] setObject:self.passwordTextField.text ? :@"" forKey:PasswordKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.hostnameTextField.text ? :@"" forKey:HostnameKey];
    [[NSUserDefaults standardUserDefaults] setBool:[self.fetchFullMessageSwitch isOn] forKey:FetchFullMessageKey];
    
    if (![_email isEqualToString:self.emailTextField.text]) {
        [[AKModel sharedManager].dataSource removeAllMailInDB];
    }
}

- (IBAction)clearCacheAction:(id)sender
{
    [[AKModel sharedManager].dataSource removeAllMailInDB];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Settings", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _email = [[NSUserDefaults standardUserDefaults] stringForKey:UsernameKey];
    self.emailTextField.text = _email;
    self.passwordTextField.text = [[FXKeychain defaultKeychain] objectForKey:PasswordKey];
    NSString *hostName = [[NSUserDefaults standardUserDefaults] stringForKey:HostnameKey];
    if (hostName) {
        self.hostnameTextField.text = hostName;
    }
    
    self.fetchFullMessageSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:FetchFullMessageKey];
}

@end
