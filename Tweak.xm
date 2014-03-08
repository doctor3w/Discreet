#import <libactivator/libactivator.h>
#import <AudioToolbox/AudioServices.h>

#define PREFS_PATH           [NSString stringWithFormat:@"%@/Library/Preferences/com.drewsdunne.discreet.plist", NSHomeDirectory()]
#define kSettingsChanged         @"com.drewsdunne.discreet/settingsChanged"

static BOOL _lsOnly;

//Headers
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

void load_settings()
{
	BOOL lsOnly = [(NSString *)[[NSDictionary dictionaryWithContentsOfFile:PREFS_PATH] objectForKey:@"onlyLS"] boolValue];
	_lsOnly = lsOnly;
}

static inline void setSettingsNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	load_settings();
}

//Activator Listener
@interface Discreet : NSObject <LAListener>

@end

@implementation Discreet 

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	if (_lsOnly)
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
	load_settings();

	CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(r, NULL, &setSettingsNotification, (CFStringRef)kSettingsChanged, NULL, 0);
}