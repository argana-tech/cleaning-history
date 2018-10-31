//
//  NSString+Replace.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/13.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "NSString+Replace.h"

@implementation NSString (Replace)

+ (NSString*) replaceBr : (NSString*) src {
    NSString* dst = [src stringByReplacingOccurrencesOfString:@"¥n" withString:@"\n"];
    dst = [src stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    return dst;
}
@end
