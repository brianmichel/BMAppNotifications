//
//  ViewController.h
//  MLNotifications
//
//  Created by Brian Michel on 11/2/12.
//  Copyright (c) 2012 Foureyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong) IBOutlet UITextField *titleField;
@property (strong) IBOutlet UITextField *subtitleField;
@property (strong) IBOutlet UIButton *sendNotificationButton;
@property (strong) IBOutlet UIButton *changeStyleButton;

- (IBAction)sendNotification:(id)sender;
- (IBAction)changeStyle:(id)sender;

@end
