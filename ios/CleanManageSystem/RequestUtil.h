//
//  RequestUtil.h
//  CleanManageSystem
//
//  Created by akifumin on 2014/03/06.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUtil : NSObject

+ (NSString*) createQueryString : (NSMutableDictionary*)dictionary;

@end
