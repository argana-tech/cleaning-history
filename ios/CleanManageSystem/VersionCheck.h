//
//  VersionCheck.h
//  CleanManageSystem
//
//  Created by akifumin on 2014/01/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionCheck : NSObject

+ (BOOL) isUpdateVersion : (NSError *__autoreleasing *) updateError ;

@end
