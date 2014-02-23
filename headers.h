@interface SBBulletinObserverViewController : UIViewController 
- (id)firstSection;
@end

@interface SBNotificationCenterViewController : UIViewController
- (id)_allModeViewControllerCreateIfNecessary:(_Bool)arg1;
@end

@interface SBNotificationCenterViewController (Discreet)
- (BOOL)notificationsPending;
@end

@interface SBNotificationCenterController : NSObject 
+ (id)sharedInstanceIfExists;
+ (id)sharedInstance;
@property(readonly, nonatomic) SBNotificationCenterViewController *viewController; 
@end