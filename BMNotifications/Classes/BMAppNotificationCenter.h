//
//  BMAppNotificationCenter.h
//  BMAppNotifications
//
//  Created by Brian Michel on 11/2/12.
//  Copyright (c) 2012 Foureyes. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXTERN NSString * const kBMAppNotificationCenterWillActivateNotification;
OBJC_EXTERN NSString * const kBMAppNotificationCenterDidActivateNotification;
OBJC_EXTERN NSString * const kBMAppNotificationCenterDidDismissNotification;

OBJC_EXTERN NSString * const kBMAppNotificationCenterNotificationKey;

@class BMAppNotificationCenter, BMAppNotification;
@protocol BMAppNotificationCenterDelegate <NSObject>

@optional
  //Called when a touch starts on a given notification.
- (void)notificationCenter:(BMAppNotificationCenter *)center willActivateNotification:(BMAppNotification *)notification;
  //Called when the same touch is lifted from a given notification.
- (void)notificationCenter:(BMAppNotificationCenter *)center didActivateNotification:(BMAppNotification *)notification;
  //Called when the given notification is dismissed, but NOT activated
- (void)notificationCenter:(BMAppNotificationCenter *)center didDismissNotification:(BMAppNotification *)notification;
@end

@interface BMAppNotificationCenter : NSObject

@property (strong, readonly) NSMutableArray *deliveredNotifications;
@property (assign, readonly) Class displayClass;
@property (weak) id<BMAppNotificationCenterDelegate>delegate;

+ (BMAppNotificationCenter *)sharedCenter;
- (void)deliverNotification:(BMAppNotification *)notification;
- (void)registerClassForDisplay:(Class)displayClass; // Will raise an NSInvalidArgumentException unless `displayClass` is a subclass of `UITableViewCell`.
@end

@interface BMAppNotification : NSObject
+ (BMAppNotification *)notificationWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle userInfo:(NSDictionary *)userInfo;

- (id)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle userInfo:(NSDictionary *)userInfo;

@property (copy) UIImage *image;
@property (copy) NSDictionary *userInfo;
@property (copy) NSString *title;
@property (copy) NSString *subtitle;

@end
