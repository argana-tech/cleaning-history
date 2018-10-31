//
//  BarCodeUtil.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/11/14.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "BarCodeUtil.h"

@implementation BarCodeUtil
+(NSString*) extractCodabar: (NSString*) codabarCode {
    long length = [codabarCode length];
    return [codabarCode substringWithRange:NSMakeRange(1, length - 2)];
}
@end
