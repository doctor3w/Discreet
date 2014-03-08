#import <Preferences/Preferences.h>

#define PREFS_PATH           [NSString stringWithFormat:@"%@/Library/Preferences/com.drewsdunne.discreet.plist", NSHomeDirectory()]
#define kSettingsChanged         @"com.drewsdunne.discreet/settingsChanged"

@interface DiscreetPrefsListController: PSListController 
- (IBAction)follow:(id)arg1;
- (IBAction)donate:(id)arg1;
- (IBAction)visitWebsite:(id)arg1;
- (IBAction)emailSupport:(id)arg1;
@end

@implementation DiscreetPrefsListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"DiscreetPrefs" target:self] retain];
	}
	return _specifiers;
}

- (IBAction)follow:(id)arg1
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/drewsdunne"]];
}
- (IBAction)donate:(id)arg1
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=UXPEZSPPFFLVC"]];
}
- (IBAction)emailSupport:(id)arg1
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:drewsdunne1@gmail.com"]];
}
- (IBAction)visitWebsite:(id)arg1
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://drewsdunne.com/"]];
}
@end