//
//  Constants.m
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/10/09.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import "Constants.h"
#import "Setting.h"

@implementation Constants

+ (SystemSoundID) getScanSoundID {
    
    NSString* soundValue = [Setting getSoundValue];
    if ([soundValue length] < 1) {
        soundValue = @"scan_1";
        [Setting setSoundValue:@"scan_1"];
    }
    int soundValuNum = [soundValue intValue];
    SystemSoundID soundID;
    if ( soundValuNum == 0) {
        
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:soundValue withExtension:@"wav"];
        AudioServicesCreateSystemSoundID ((CFURLRef)CFBridgingRetain(soundURL), &soundID);
    } else {
        soundID = soundValuNum;
    }
    return soundID;
}

+ (BOOL) isDeviceiPad {
    NSString *model = [UIDevice currentDevice].model;
    if ([model isEqualToString:@"iPad"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (CGFloat) getiPadOffset {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 100;
    } else {
        return 0;
    }
}


//
+ (float) getiPhoneValue:(float)iPhoneValue iPadCoeffcient: (float)iPadCoeffcient {
    if([Constants isDeviceiPad]) {
        return  iPhoneValue * iPadCoeffcient;
    } else {
        return iPhoneValue;
    }
}

//
+ (float) getiPhoneValue : (float) value iPadValue:(float)iPadValue {
    if([Constants isDeviceiPad]) {
        return iPadValue;
    } else {
        return value;
    }
}

+ (UIFont*) getFont {
    float fontSize = [Constants getiPhoneValue:IPHONE_DEFAULT_FONT_SIZE iPadValue:IPAD_DEFAULT_FONT_SIZE];
    return [UIFont systemFontOfSize:fontSize];
}



@end
