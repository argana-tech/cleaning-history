//
//  Setting.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/06.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "Setting.h"

#define SCAN_SOUND_VALUE @"SCAN_SOUND_VALUE"

#define SCAN_LIGHT @"SCAN_LIGHT"

@implementation Setting

#pragma mark - スキャナ音を取得
+ (NSString*) getSoundValue {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud stringForKey:SCAN_SOUND_VALUE];
}

#pragma mark - スキャナ音を更新
+ (void) setSoundValue :(NSString*) sound {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:sound forKey:SCAN_SOUND_VALUE];
}

#pragma mark - スキャナ画面のライト点灯状態を取得
+ (BOOL) isScanLight {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL light = [ud boolForKey:SCAN_LIGHT];
    return light;
}

#pragma mark - スキャナ画面のライト状態を更新
+ (void) setScanLight :(BOOL) light {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(light) forKey:SCAN_LIGHT];
}

@end
