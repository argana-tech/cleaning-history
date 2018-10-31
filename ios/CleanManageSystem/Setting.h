//
//  Setting.h
//  CleanManageSystem
//　　　NSUserdefalutを管理するクラス
//  Created by akifumin on 2013/12/06.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Setting : NSObject

#pragma mark - スキャナ音
+ (NSString*) getSoundValue;
+ (void) setSoundValue :(NSString*) sound;

#pragma mark - スキャナライト
+ (BOOL) isScanLight;
+ (void) setScanLight :(BOOL) light;

@end
