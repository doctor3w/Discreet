#import "DListener.h"
#import "headers.h"
#import <AudioToolbox/AudioServices.h>

//BOOL notificationsPending();

@implementation Discreet 

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    SBNotificationCenterController *ncc = (SBNotificationCenterController *)[%c(SBNotificationCenterController) sharedInstance];

    if ([ncc.viewController notificationsPending])
    {
        NSLog(@"[Discreet] Detected pending notifications, sending vibration signal.");
    	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
	[event setHandled:YES]; // To prevent the default OS implementation
}

+ (void)load {
	@autoreleasepool
	{
		[[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.drewsdunne.discreet"];
	}
}

@end