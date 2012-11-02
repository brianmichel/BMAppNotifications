//
//  ViewController.m
//  MLNotifications
//
//  Created by Brian Michel on 11/2/12.
//  Copyright (c) 2012 Foureyes. All rights reserved.
//

#import "ViewController.h"
#import "SweetDisplayCell.h"

@interface ViewController () <BMAppNotificationCenterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [[BMAppNotificationCenter sharedCenter] registerClassForDisplay:[SweetDisplayCell class]];
  [BMAppNotificationCenter sharedCenter].delegate = self;
}

- (IBAction)sendNotification:(id)sender {
  UIImage *image = arc4random() % 2 ? [UIImage imageNamed:@"blackCat"] : nil;
  [[BMAppNotificationCenter sharedCenter] deliverNotification:[BMAppNotification notificationWithImage:image title:self.titleField.text subtitle:self.subtitleField.text userInfo:nil]];
  [self.titleField resignFirstResponder];
  [self.subtitleField resignFirstResponder];
}

- (IBAction)changeStyle:(id)sender {
  [[BMAppNotificationCenter sharedCenter] registerClassForDisplay:[UITableViewCell class]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Delegate
- (void)notificationCenter:(BMAppNotificationCenter *)center didActivateNotification:(BMAppNotification *)notification {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.title message:[NSString stringWithFormat:@"You clicked on a notification with title \"%@\", subtitle \"%@\".", notification.title, notification.subtitle] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

@end
