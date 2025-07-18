#import "SettingsViewController.h"
#import "../Components/Prefs/SwitchTableCell.h"
#import "../Components/Prefs/StepperTableCell.h"
#import "../Utils.h"
#import "../Manager.h"

@interface PGSettingsViewController ()
@property (nonatomic, assign) BOOL hasDynamicSpecifiers;
@property (nonatomic, retain) NSMutableDictionary *dynamicSpecifiers;
@end

@implementation PGSettingsViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"PureGram Settings";
        [self.navigationController.navigationBar setPrefersLargeTitles:false];
    }
    return self;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleInsetGrouped;
}

// Pref Section
- (PSSpecifier *)newSectionWithTitle:(NSString *)header footer:(NSString *)footer {
    PSSpecifier *section = [PSSpecifier preferenceSpecifierNamed:header target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
    if (footer != nil) {
        [section setProperty:footer forKey:@"footerText"];
    }
    return section;
}

// Pref Switch Cell
- (PSSpecifier *)newSwitchCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText key:(NSString *)keyText changeAction:(SEL)changeAction {
    PSSpecifier *switchCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];

    [switchCell setProperty:keyText forKey:@"key"];
    [switchCell setProperty:keyText forKey:@"id"];
    [switchCell setProperty:@YES forKey:@"big"];
    [switchCell setProperty:PGSwitchTableCell.class forKey:@"cellClass"];
    [switchCell setProperty:NSBundle.mainBundle.bundleIdentifier forKey:@"defaults"];
    //[switchCell setProperty:@([PGManager getBoolPref:keyText]) forKey:@"default"];
    [switchCell setProperty:NSStringFromSelector(changeAction) forKey:@"switchAction"];
    if (detailText != nil) {
        [switchCell setProperty:detailText forKey:@"subtitle"];
    }
    return switchCell;
}

// Pref Stepper Cell
- (PSSpecifier *)newStepperCellWithTitle:(NSString *)titleText key:(NSString *)keyText min:(double)min max:(double)max step:(double)step label:(NSString *)label singularLabel:(NSString *)singularLabel {
    PSSpecifier *stepperCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSTitleValueCell edit:nil];

    [stepperCell setProperty:keyText forKey:@"key"];
    [stepperCell setProperty:keyText forKey:@"id"];
    [stepperCell setProperty:@YES forKey:@"big"];
    [stepperCell setProperty:PGStepperTableCell.class forKey:@"cellClass"];
    [stepperCell setProperty:NSBundle.mainBundle.bundleIdentifier forKey:@"defaults"];

    [stepperCell setProperty:@(min) forKey:@"min"];
    [stepperCell setProperty:@(max) forKey:@"max"];
    [stepperCell setProperty:@(step) forKey:@"step"];
    [stepperCell setProperty:label forKey:@"label"];
    [stepperCell setProperty:singularLabel forKey:@"singularLabel"];

    return stepperCell;
}

// Pref Link Cell
- (PSSpecifier *)newLinkCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText url:(NSString *)url iconURL:(NSString *)iconURL iconTransparentBG:(BOOL)iconTransparentBG {
    PSSpecifier *LinkCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSButtonCell edit:nil];

    [LinkCell setButtonAction:@selector(hb_openURL:)];
    [LinkCell setProperty:HBLinkTableCell.class forKey:@"cellClass"];
    [LinkCell setProperty:url forKey:@"url"];
    if (detailText != nil) {
        [LinkCell setProperty:detailText forKey:@"subtitle"];
    }
    if (iconURL != nil) {
        [LinkCell setProperty:iconURL forKey:@"iconURL"];
        [LinkCell setProperty:@YES forKey:@"iconCircular"];
        [LinkCell setProperty:@YES forKey:@"big"];
        [LinkCell setProperty:@56 forKey:@"height"];
        [LinkCell setProperty:@(iconTransparentBG) forKey:@"iconTransparentBG"];
    }

    return LinkCell;
}

// Tweak settings
- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [NSMutableArray arrayWithArray:@[
            [self newLinkCellWithTitle:@"Donate" detailTitle:@"Consider donating to support this tweak <3" url:@"https://ko-fi.com/socuul" iconURL:@"https://i.imgur.com/g4U5AMi.png" iconTransparentBG:YES],

            // Section 2: Feed
            [self newSectionWithTitle:@"Feed" footer:nil],
            [self newSwitchCellWithTitle:@"Hide ads" detailTitle:@"Removes all ads from the Instagram app" key:@"hide_ads" changeAction:nil],
            [self newSwitchCellWithTitle:@"No suggested posts" detailTitle:@"Removes suggested posts from your feed" key:@"no_suggested_post" changeAction:nil],
            [self newSwitchCellWithTitle:@"No suggested for you" detailTitle:@"Hides suggested accounts for you to follow" key:@"no_suggested_account" changeAction:nil],
            [self newSwitchCellWithTitle:@"No suggested reels" detailTitle:@"Hides suggested reels to watch" key:@"no_suggested_reels" changeAction:nil],
            [self newSwitchCellWithTitle:@"No suggested threads posts" detailTitle:@"Hides suggested threads posts" key:@"no_suggested_threads" changeAction:nil],

            // Section 3: Save media
            [self newSectionWithTitle:@"Save media" footer:nil],
            [self newSwitchCellWithTitle:@"Download feed posts" detailTitle:@"Long-press with finger(s) to download posts in the home tab" key:@"dw_feed_posts" changeAction:nil],
            [self newSwitchCellWithTitle:@"Download reels" detailTitle:@"Long-press with finger(s) on a reel to download" key:@"dw_reels" changeAction:nil],
            [self newSwitchCellWithTitle:@"Download reels" detailTitle:@"Long-press with finger(s) while viewing someone's story to download" key:@"dw_story" changeAction:nil],
            [self newSwitchCellWithTitle:@"Save profile picture" detailTitle:@"On someone's profile, click their profile picture to enlarge it, then hold to download" key:@"save_profile" changeAction:nil],
            [self newStepperCellWithTitle:@"Use %@ %@ for long-press" key:@"dw_finger_count" min:1 max:5 step:1 label:@"fingers" singularLabel:@"finger"],
            [self newStepperCellWithTitle:@"%@ %@ press to download" key:@"dw_finger_duration" min:0 max:10 step:0.25 label:@"sec" singularLabel:@"sec"],

            // Section 10: Credits
            [self newSectionWithTitle:@"Credits" footer:[NSString stringWithFormat:@"PureGram %@\n\nInstagram v%@", PGVersionString, [PGUtils IGVersionString]]],
            [self newLinkCellWithTitle:@"SCInsta Developer" detailTitle:@"SoCuul" url:@"https://socuul.dev" iconURL:@"https://i.imgur.com/WSFMSok.png" iconTransparentBG:NO],
            [self newLinkCellWithTitle:@"PureGram Modifier" detailTitle:@"MrErenK" url:@"https://github.com/MrErenK" iconURL:@"https://avatars.githubusercontent.com/u/77717109" iconTransparentBG:NO],
            [self newLinkCellWithTitle:@"View SCInsta Repo" detailTitle:@"View the main tweak's source code on GitHub" url:@"https://github.com/SoCuul/SCInsta" iconURL:@"https://i.imgur.com/BBUNzeP.png" iconTransparentBG:YES],
            [self newLinkCellWithTitle:@"View PureGram Repo" detailTitle:@"View my tweak's source code on GitHub" url:@"https://github.com/MrErenK/PureGram" iconURL:@"https://avatars.githubusercontent.com/u/77717109" iconTransparentBG:YES]
        ]];

        [self collectDynamicSpecifiersFromArray:_specifiers];
    }

    return _specifiers;
}

- (void)reloadSpecifiers {
    [super reloadSpecifiers];

    [self collectDynamicSpecifiersFromArray:self.specifiers];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasDynamicSpecifiers) {
        PSSpecifier *dynamicSpecifier = [self specifierAtIndexPath:indexPath];
        BOOL __block shouldHide = false;

        [self.dynamicSpecifiers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableArray *specifiers = obj;
            if ([specifiers containsObject:dynamicSpecifier]) {
                shouldHide = [self shouldHideSpecifier:dynamicSpecifier];

                UITableViewCell *specifierCell = [dynamicSpecifier propertyForKey:PSTableCellKey];
                specifierCell.clipsToBounds = shouldHide;
            }
        }];
        if (shouldHide) {
            return 0;
        }
    }

    return UITableViewAutomaticDimension;
}

- (void)collectDynamicSpecifiersFromArray:(NSArray *)array {
    if (!self.dynamicSpecifiers) {
        self.dynamicSpecifiers = [NSMutableDictionary new];

    } else {
        [self.dynamicSpecifiers removeAllObjects];
    }

    for (PSSpecifier *specifier in array) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];

        if (dynamicSpecifierRule.length > 0) {
            NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];

            if (ruleComponents.count == 3) {
                NSString *opposingSpecifierID = [ruleComponents objectAtIndex:0];
                if ([self.dynamicSpecifiers objectForKey:opposingSpecifierID]) {
                    NSMutableArray *specifiers = [[self.dynamicSpecifiers objectForKey:opposingSpecifierID] mutableCopy];
                    [specifiers addObject:specifier];


                    [self.dynamicSpecifiers removeObjectForKey:opposingSpecifierID];
                    [self.dynamicSpecifiers setObject:specifiers forKey:opposingSpecifierID];
                } else {
                    [self.dynamicSpecifiers setObject:[NSMutableArray arrayWithArray:@[specifier]] forKey:opposingSpecifierID];
                }

            } else {
                [NSException raise:NSInternalInconsistencyException format:@"dynamicRule key requires three components (Specifier ID, Comparator, Value To Compare To). You have %ld of 3 (%@) for specifier '%@'.", ruleComponents.count, dynamicSpecifierRule, [specifier propertyForKey:PSTitleKey]];
            }
        }
    }

    self.hasDynamicSpecifiers = (self.dynamicSpecifiers.count > 0);
}
- (DynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string {
    NSDictionary *operatorValues = @{ @"==" : @(EqualToOperatorType), @"!=" : @(NotEqualToOperatorType), @">" : @(GreaterThanOperatorType), @"<" : @(LessThanOperatorType) };
    return [operatorValues[string] intValue];
}
- (BOOL)shouldHideSpecifier:(PSSpecifier *)specifier {
    if (specifier) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];

        PSSpecifier *opposingSpecifier = [self specifierForID:[ruleComponents objectAtIndex:0]];
        id opposingValue = [self readPreferenceValue:opposingSpecifier];
        id requiredValue = [ruleComponents objectAtIndex:2];

        if ([opposingValue isKindOfClass:NSNumber.class]) {
            DynamicSpecifierOperatorType operatorType = [self operatorTypeForString:[ruleComponents objectAtIndex:1]];

            switch (operatorType) {
                case EqualToOperatorType:
                    return ([opposingValue intValue] == [requiredValue intValue]);
                    break;

                case NotEqualToOperatorType:
                    return ([opposingValue intValue] != [requiredValue intValue]);
                    break;

                case GreaterThanOperatorType:
                    return ([opposingValue intValue] > [requiredValue intValue]);
                    break;

                case LessThanOperatorType:
                    return ([opposingValue intValue] < [requiredValue intValue]);
                    break;
            }
        }

        if ([opposingValue isKindOfClass:NSString.class]) {
            return [opposingValue isEqualToString:requiredValue];
        }

        if ([opposingValue isKindOfClass:NSArray.class]) {
            return [opposingValue containsObject:requiredValue];
        }
    }

    return NO;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    [Prefs setValue:value forKey:[specifier identifier]];

    NSLog(@"[PureGram] Set user default. Key: %@ | Value: %@", [specifier identifier], value);

    if (self.hasDynamicSpecifiers) {
        NSString *specifierID = [specifier propertyForKey:PSIDKey];
        PSSpecifier *dynamicSpecifier = [self.dynamicSpecifiers objectForKey:specifierID];

        if (dynamicSpecifier) {
            [self.table beginUpdates];
            [self.table endUpdates];
        }
    }
}
- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    return [Prefs valueForKey:[specifier identifier]]?:[specifier properties][@"default"];
}

@end
