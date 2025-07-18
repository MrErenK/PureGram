#import <substrate.h>
#import "InstagramHeaders.h"
#import "Tweak.h"
#import "Utils.h"
#import "Manager.h"
#import "Controllers/SettingsViewController.h"

// * Tweak version *
NSString *PGVersionString = @"0.0.1";

// Tweak first-time setup
%hook IGInstagramAppDelegate
- (_Bool)application:(UIApplication *)application didFinishLaunchingWithOptions:(id)arg2 {
    %orig;

    // Default PureGram config
    NSDictionary *pgDefaults = @{
        @"hide_ads": @(YES),
        @"no_suggested_post": @(YES),
        @"no_suggested_reels": @(YES),
        @"no_suggested_threads": @(YES),
        @"dw_feed_posts": @(YES),
        @"dw_reels": @(YES),
        @"dw_story": @(YES),
        @"save_profile": @(YES),
        @"dw_finger_count": @(3),
        @"dw_finger_duration": @(0.5)
    };
    [[NSUserDefaults standardUserDefaults] registerDefaults:pgDefaults];

    // Open settings for first-time users
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PureGramFirstRun"] == nil) {
        NSLog(@"[PureGram] First run, initializing");

        // Display settings modal on screen
        NSLog(@"[PureGram] Displaying PureGram first-time settings modal");
        UIViewController *rootController = [[self window] rootViewController];
        PGSettingsViewController *settingsViewController = [PGSettingsViewController new];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];

        [rootController presentViewController:navigationController animated:YES completion:nil];

        // Done with first-time setup
        [[NSUserDefaults standardUserDefaults] setValue:@"PureGramFirstRun" forKey:@"PureGramFirstRun"];

    }

    NSLog(@"[PureGram] Cleaning cache...");
    [PGManager cleanCache];

    return true;
}

- (void)applicationDidEnterBackground:(id)arg1 {
    %orig;
}
- (void)applicationWillEnterForeground:(id)arg1 {
    %orig;
}
%end

// Disable sending modded insta bug reports
%hook IGWindow
- (void)showDebugMenu {
    return;
}
%end



/////////////////////////////////////////////////////////////////////////////

%hook HBLinkTableCell
- (void)viewDidLoad {
    %orig;

    UILabel *titleLabel = [self titleLabel];
    [titleLabel setTextColor:[PGUtils PGColour_Primary]];
}
- (void)loadIconIfNeeded {
    if ([[self.specifier propertyForKey:@"iconTransparentBG"] isEqual:@(YES)]) {
        self.iconView.backgroundColor = [UIColor clearColor];
    }

    %orig;
}
%end

%hook HBForceCepheiPrefs
+ (BOOL)forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear {
    return YES;
}
%end
