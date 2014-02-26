#import <Preferences/Preferences.h>

#define PREFS_PATH           [NSString stringWithFormat:@"%@/Library/Preferences/com.drewsdunne.discreet.plist", NSHomeDirectory()]
#define kSettingsChanged         @"com.drewsdunne.discreet/settingsChanged"

@interface DiscreetPrefsListController: PSListController {
	NSMutableDictionary *_settings;
}
@property (nonatomic, retain, readwrite) NSMutableDictionary *settings;
- (IBAction)sendSettings:(id)sender;
@end

@implementation DiscreetPrefsListController
- (id)initForContentSize:(CGSize)size {
	if ((self = [super initForContentSize:size])) {
		self.settings = [[NSMutableDictionary dictionaryWithContentsOfFile:PREFS_PATH] retain];
	}
	return self;
}
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"DiscreetPrefs" target:self] retain];
	}
	return _specifiers;
}

- (void)writeSettings {
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:self.settings format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];

	if (!data)
		return;
	if (![data writeToFile:PREFS_PATH atomically:NO]) {
		NSLog(@"ChangeCarrier: failed to write preferences. Permissions issue?");
		return;
	}
}

- (IBAction)sendSettings:(id)sender {
	UISwitch *lsOnlySwitch = (UISwitch *)sender;
	[self.settings setObject:[NSString stringWithFormat:@"%d",lsOnlySwitch.on] forKey:@"onlyLS"];
	[self writeSettings];

	CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterPostNotification(r, (CFStringRef)kSettingsChanged, NULL, (CFDictionaryRef)self.settings, true);
}
@end

// vim:ft=objc
