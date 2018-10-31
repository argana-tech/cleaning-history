//
//  ZBarViewControllerSingleton.m
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/09/30.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import "ZBarViewControllerSingleton.h"

@implementation ZBarViewControllerSingleton {
    ZBarReaderViewController *reader;
}

+ (ZBarViewControllerSingleton*)sharedManager {
    static ZBarViewControllerSingleton* sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[ZBarViewControllerSingleton alloc]
                           initSharedInstance];
    });
    return sharedSingleton;
}

- (id)initSharedInstance {
    self = [super init];
    if (self) {
        // 初期化処理
        
       reader = [ZBarReaderViewController new];
        // overlay
        reader.showsCameraControls = NO;
        reader.showsZBarControls = NO;
        

    }
    return self;
}


-  (ZBarReaderViewController*) getZBarReaderViewController {
    return reader;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
