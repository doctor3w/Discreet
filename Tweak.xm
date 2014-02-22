#import "DListener.h"
#import <libactivator/libactivator.h>
#import "headers.h"
#import <AudioToolbox/AudioServices.h>

%hook SBNotificationCenterViewController

%new

- (BOOL)notificationsPending {
	return [(SBBulletinObserverViewController *)[self _allModeViewControllerCreateIfNecessary:NO] firstSection] != nil;
}

%end

/*%ctor {
	[[LAActivator sharedInstance] registerListener:[[DListener alloc] init] forName:@"com.drewsdunne.discreet"];
}*/