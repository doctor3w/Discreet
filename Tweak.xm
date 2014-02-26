#import <libactivator/libactivator.h>
#import <AudioToolbox/AudioServices.h>

#define PREFS_PATH           [NSString stringWithFormat:@"%@/Library/Preferences/com.drewsdunne.discreet.plist", NSHomeDirectory()]
#define kSettingsChanged         @"com.drewsdunne.discreet/settingsChanged"

BOOL lsOnly;

static inline void setSettingsNotification(CFNotificationCenterRef center,
									void *observer,
									CFStringRef name,
									const void *object,
									CFDictionaryRef userInfo) {
	NSString *val = (NSString *)[[NSDictionary dictionaryWithContentsOfFile:PREFS_PATH] objectForKey:@"onlyLS"];
	lsOnly = val.boolValue;
}

@interface SBBulletinObserverViewController : UIViewController 
- (id)firstSection;
@end

@interface SBNotificationCenterViewController : UIViewController
- (id)_allModeViewControllerCreateIfNecessary:(_Bool)arg1;
- (BOOL)notificationsPending;
@end

@interface SBNotificationCenterController : NSObject 
+ (id)sharedInstanceIfExists;
+ (id)sharedInstance;
@property(readonly, nonatomic) SBNotificationCenterViewController *viewController; 
@end

@interface SBLockScreenViewControllerBase
- (_Bool)lockScreenIsShowingBulletins;
@end

@interface SBLockScreenManager
+ (id)sharedInstance;
@property(readonly, nonatomic) SBLockScreenViewControllerBase *lockScreenViewController;
@end

@interface Discreet : NSObject <LAListener>

@end

@implementation Discreet 

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	//NSString *val = (NSString *)[[NSDictionary dictionaryWithContentsOfFile:PREFS_PATH] objectForKey:@"onlyLS"];
	//BOOL lsOnly = val.boolValue;
	if (lsOnly)
	{
		SBLockScreenManager *lsm = (SBLockScreenManager *)[%c(SBLockScreenManager) sharedInstance];
		if ([lsm.lockScreenViewController lockScreenIsShowingBulletins])
		{
			[self vibe];
			[self vibe];
		}
	} else {
		SBNotificationCenterController *ncc = (SBNotificationCenterController *)[%c(SBNotificationCenterController) sharedInstance];
    	if ([ncc.viewController notificationsPending])
    	{
    		[self vibe];
    		[self vibe];
    	}
	}
	[event setHandled:YES]; // To prevent the default OS implementation
}

- (void)vibe {
	AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

+ (void)load {
	@autoreleasepool
	{
		[[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.drewsdunne.discreet"];
	}
}

@end

%hook SBNotificationCenterViewController

%new

- (BOOL)notificationsPending {
	return [(SBBulletinObserverViewController *)[self _allModeViewControllerCreateIfNecessary:NO] firstSection] != nil;
}

%end

%ctor {
	NSString *val = (NSString *)[[NSDictionary dictionaryWithContentsOfFile:PREFS_PATH] objectForKey:@"onlyLS"];
	lsOnly = val.boolValue;
	CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(r, NULL, &setSettingsNotification, (CFStringRef)kSettingsChanged, NULL, 0);
}