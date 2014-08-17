//
//  DetailViewController.m
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AKMailDetailViewController.h"
#import "AKMailMessage.h"

@interface AKMailDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation AKMailDetailViewController

#pragma mark - Managing the detail item

- (void)setMessageItem:(AKMailMessage *)messageItem
{
    _messageItem = messageItem;
    [self configureView];
  
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView{
    
    // Update the user interface for the detail item.
    if (self.messageItem) {

        if (self.messageItem.htmlBody.length>0) {
        
            [self.webView loadHTMLString:self.messageItem.htmlBody baseURL:nil];
            NSLog(@"HTML %@",self.messageItem.htmlBody);
            NSLog(@"Cached");

        }else{
            
            if ([AKModel sharedManager].recahbility.isReachable) {
               AKMailMessage * mailMessage = [[AKModel sharedManager].dataSource getMessageForManagedID:self.messageItem.objectID];
                [[AKModel sharedManager].mailManager getMailHTMLBodyForMessageUID:[mailMessage.uid unsignedIntValue] complete:^(NSString *msgHTMLBody) {
                    
                     //We get current context mananged object
                    
                    NSLog(@"HTML %@",msgHTMLBody);
                    mailMessage.htmlBody = msgHTMLBody;
                    NSLog(@"HTML %@",self.messageItem.htmlBody);
                    
                    [self.webView loadHTMLString: mailMessage.htmlBody baseURL:nil];
                    
                } fail:^(NSError *error) {
                    
                    
                }];
            }
            
        }
    }
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Mail List", @"Mail List");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Web view

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

@end
