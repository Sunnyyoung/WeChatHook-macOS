//
//  TweakPreferencesController.m
//  WeChatTweak
//
//  Created by Sunnyyoung on 2017/8/12.
//  Copyright © 2017年 Sunnyyoung. All rights reserved.
//

#import "TweakPreferencesController.h"
#import "NSBundle+WeChatTweak.h"
#import "WTConfigManager.h"
#import "TweakColorView.h"

@interface TweakPreferencesController () <MASPreferencesViewController>

@property (weak) IBOutlet NSPopUpButton *autoAuthButton;
@property (weak) IBOutlet NSPopUpButton *notificationTypeButton;
@property (weak) IBOutlet NSPopUpButton *compressedJSONEnabledButton;
@property (weak) IBOutlet TweakColorView *recallColorView;

@end

@implementation TweakPreferencesController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSClickGestureRecognizer *click = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(recallColorAction:)];
    [self.recallColorView addGestureRecognizer:click];
    self.recallColorView.backgroundColor = [NSColor tweak_revokeBackgroundColor];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self reloadData];
}

- (void)reloadData {
    WTConfigManager *configManager = WTConfigManager.sharedInstance;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL enabledAutoAuth = [userDefaults boolForKey:WeChatTweakPreferenceAutoAuthKey];
    RevokeNotificationType notificationType = [userDefaults integerForKey:WeChatTweakPreferenceRevokeNotificationTypeKey];
    [self.autoAuthButton selectItemAtIndex:enabledAutoAuth ? 1 : 0];
    [self.notificationTypeButton selectItemAtIndex:notificationType];
    [self.compressedJSONEnabledButton selectItemAtIndex:configManager.compressedJSONEnabled ? 0 : 1];
}

#pragma mark - Event method

- (IBAction)switchAutoAuthAction:(NSPopUpButton *)sender {
    BOOL enabled = sender.indexOfSelectedItem == 1;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:WeChatTweakPreferenceAutoAuthKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)switchNotificationTypeAction:(NSPopUpButton *)sender {
    RevokeNotificationType type = sender.indexOfSelectedItem;
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:WeChatTweakPreferenceRevokeNotificationTypeKey];
}

- (IBAction)switchCompressedJSONEnabledAction:(NSPopUpButton *)sender {
    BOOL enabled = sender.indexOfSelectedItem == 0;
    WTConfigManager.sharedInstance.compressedJSONEnabled = enabled;
}

- (void)recallColorAction:(id)sender {
    NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
    colorPanel.mode = NSColorPanelModeRGB;
    [colorPanel setAction:@selector(changeColorAction:)];
    [colorPanel setTarget:self];
    [colorPanel orderFront:nil];
    colorPanel.color = self.recallColorView.backgroundColor;
}

- (void)changeColorAction:(NSColorPanel *)sender {
    NSColor *color = sender.color;
    self.recallColorView.backgroundColor = color;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [userDefaults setObject:colorData forKey:WeChatTweakPreferenceRevokeBackgroundColorKey];
    [userDefaults synchronize];
}

#pragma mark - MASPreferencesViewController

- (NSString *)identifier {
    return @"tweak";
}

- (NSString *)toolbarItemLabel {
    return @"Tweak";
}

- (NSImage *)toolbarItemImage {
    return [[NSBundle tweakBundle] imageForResource:@"Prefs-Tweak"];
}

- (BOOL)hasResizableWidth {
    return NO;
}

- (BOOL)hasResizableHeight {
    return NO;
}

@end
