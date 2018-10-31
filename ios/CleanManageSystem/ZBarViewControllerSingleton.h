//
//  ZBarViewControllerSingleton.h
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/09/30.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBarReaderViewController.h"

@interface ZBarViewControllerSingleton : NSObject

+ (ZBarViewControllerSingleton*)sharedManager;
- (id)initSharedInstance;
-  (ZBarReaderViewController*) getZBarReaderViewController;
@end
