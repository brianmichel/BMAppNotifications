//
//  BMAppNotificationCenter.m
//  BMAppNotifications
//
//  Created by Brian Michel on 11/2/12.
//  Copyright (c) 2012 Foureyes. All rights reserved.
//

#import "BMAppNotificationCenter.h"

const CGFloat BMAppNotificationTableWidth = 320.0;
const CGFloat BMAppNotificationAlphaScaleFactor = 3.5;

static NSString * BMAppNotificationCellReuseId = @"BMAppNotificationTableCell";

@interface BMAppNotificationWindow : UIWindow

@end

@interface BMAppNotificationsViewController : UIViewController

@property (strong) UITableView *tableView;

@end

@interface BMAppNotificationCenter () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong) NSArray *observers;
@property (strong) BMAppNotificationWindow *notificationsWindow;
@property (strong) BMAppNotificationsViewController *notificationsController;

@end

@implementation BMAppNotificationCenter

@synthesize deliveredNotifications = _deliveredNotifications;
@synthesize displayClass = _displayClass;

+ (BMAppNotificationCenter *)sharedCenter {
  static dispatch_once_t onceToken;
  static BMAppNotificationCenter *sharedCenter = nil;
  dispatch_once(&onceToken, ^{
    sharedCenter = [[BMAppNotificationCenter alloc] init];
  });
  return sharedCenter;
}

- (id)init {
  self = [super init];
  if (self) {
    //setup vcs and windows
    _deliveredNotifications = [NSMutableArray array];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    self.notificationsWindow = [[BMAppNotificationWindow alloc] initWithFrame:screenRect];
    self.notificationsWindow.alpha = 1.0;
    self.notificationsWindow.backgroundColor = [UIColor clearColor];
     
    self.notificationsController = [[BMAppNotificationsViewController alloc] init];
    self.notificationsController.view.autoresizingMask = UIViewAutoresizingNone;
    self.notificationsController.view.autoresizesSubviews = NO;
    self.notificationsController.tableView.autoresizingMask = self.notificationsController.view.autoresizingMask;
    
    self.notificationsController.tableView.delegate = self;
    self.notificationsController.tableView.dataSource = self;
    
    self.notificationsWindow.rootViewController = self.notificationsController;
    
    self.notificationsWindow.hidden = NO;
  }
  return self;
}

#pragma mark - API

- (void)deliverNotification:(BMAppNotification *)notification {  
  [_deliveredNotifications insertObject:notification atIndex:0];
  [self.notificationsController.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)registerClassForDisplay:(Class)displayClass {
  if ([displayClass isSubclassOfClass:[UITableViewCell class]]) {
    _displayClass = displayClass;
    [self.notificationsController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
  } else {
    [NSException raise:NSInvalidArgumentException format:@"%@ Attemped to register class \"%@\" for displayClass. Display class MUST be a subclass of class \"UITableViewCell\"", self, displayClass];
  }
}

#pragma mark - UITableView Datasource / Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.deliveredNotifications count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 65.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Class classToUserForDisplay = self.displayClass ? self.displayClass : [UITableViewCell class];
 
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BMAppNotificationCellReuseId];
  
  if (!cell) {
    cell = [[classToUserForDisplay alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:BMAppNotificationCellReuseId];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidPan:)];
    panGesture.delegate = self;
    [cell addGestureRecognizer:panGesture];
  }
  
  BMAppNotification *note = self.deliveredNotifications[indexPath.row];

  cell.textLabel.text = note.title;
  cell.detailTextLabel.text = note.subtitle;
  cell.imageView.image = note.image;
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate && [self.delegate respondsToSelector:@selector(notificationCenter:willActivateNotification:)]) {
    BMAppNotification *note = self.deliveredNotifications[indexPath.row];
    [self.delegate notificationCenter:self willActivateNotification:note];
  }
  return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  BMAppNotification *note = self.deliveredNotifications[indexPath.row];
  [self.deliveredNotifications removeObject:note];
  [self.notificationsController.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(notificationCenter:didActivateNotification:)]) {
    [self.delegate notificationCenter:self didActivateNotification:note];
  }
}

#pragma mark - Pan Gesture
- (void)cellDidPan:(UIPanGestureRecognizer *)panGesture {
  BOOL reset = NO;
  BOOL complete = NO;

  CGPoint translatedPoint = [panGesture translationInView:panGesture.view.superview];
  CGPoint velocity = [panGesture velocityInView:panGesture.view.superview];

  switch (panGesture.state) {
    case UIGestureRecognizerStateBegan:
      //Do nothing...
      break;
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateFailed:
      reset = velocity.x < 1000;
      complete = !reset;
      break;
    default:
      break;
  }

  if ((panGesture.view.frame.origin.x + translatedPoint.x) < 0) {
    panGesture.view.frame = CGRectMake(0, panGesture.view.frame.origin.y, panGesture.view.frame.size.width, panGesture.view.frame.size.height);
    panGesture.view.alpha = 1.0;
  } else {
     panGesture.view.frame = CGRectMake(translatedPoint.x, panGesture.view.frame.origin.y, panGesture.view.frame.size.width, panGesture.view.frame.size.height);
    panGesture.view.alpha = 1 -  (translatedPoint.x / (panGesture.view.frame.size.width * BMAppNotificationAlphaScaleFactor));
  }

  if (reset) {
    [UIView animateWithDuration:0.3 animations:^{
      panGesture.view.frame = CGRectMake(0, panGesture.view.frame.origin.y, panGesture.view.frame.size.width, panGesture.view.frame.size.height);
      panGesture.view.alpha = 1.0;
    }];
  }

  if (complete) {
    [UIView animateWithDuration:0.3 animations:^{
      panGesture.view.frame = CGRectMake(self.notificationsController.tableView.frame.size.width, panGesture.view.frame.origin.y, panGesture.view.frame.size.width, panGesture.view.frame.size.height);
      panGesture.view.alpha = 0.0;
    } completion:^(BOOL finished) {
      NSIndexPath *indexPath = [self.notificationsController.tableView indexPathForRowAtPoint:CGPointMake(0, panGesture.view.frame.origin.y)];
      if (indexPath) {
        BMAppNotification *notification = self.deliveredNotifications[indexPath.row];
        [self.deliveredNotifications removeObject:notification];
        [self.notificationsController.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        if (self.delegate && [self.delegate respondsToSelector:@selector(notificationCenter:didDismissNotification:)]) {
          [self.delegate notificationCenter:self didDismissNotification:notification];
        }
      }
    }];
  }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

- (void)dealloc {
  for (id observer in self.observers) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
  }
}

@end

@implementation BMAppNotificationsViewController

- (id)init {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableView.tableHeaderView = blankView;
    self.tableView.tableFooterView = blankView;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view addSubview:self.tableView];
  self.tableView.frame = CGRectMake(self.view.frame.size.width - BMAppNotificationTableWidth, 0, BMAppNotificationTableWidth, self.view.frame.size.height);
}


- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  BOOL isLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
  self.tableView.frame = CGRectMake((isLandscape ? self.view.frame.size.height : self.view.frame.size.width) - BMAppNotificationTableWidth, 0, BMAppNotificationTableWidth, (isLandscape ? self.view.frame.size.width : self.view.frame.size.height));
}

@end

@implementation BMAppNotificationWindow

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  BMAppNotificationsViewController *vc = (BMAppNotificationsViewController *)self.rootViewController;
  NSAssert([vc isKindOfClass:[BMAppNotificationsViewController class]], @"BMAppNotificationWindow MUST have a BMAppNotificationsViewController as it's root view controller");
  for (UITableViewCell *cell in vc.tableView.visibleCells) {
    if ([cell pointInside:[cell convertPoint:point fromView:self] withEvent:event]) {
      return YES;
    }
  }
  return NO;
}

@end

@implementation BMAppNotification

+ (BMAppNotification *)notificationWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle userInfo:(NSDictionary *)userInfo {
  return [[BMAppNotification alloc] initWithImage:image title:title subtitle:subtitle userInfo:userInfo];
}

- (id)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle userInfo:(NSDictionary *)userInfo {
  self = [super init];
  if (self) {
    self.image = image;
    self.title = title;
    self.subtitle = subtitle;
    self.userInfo = userInfo;
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<title: %@, subtitle: %@, image: %@, userInfo: %@>", self.title, self.subtitle, self.image, self.userInfo];
}

@end
