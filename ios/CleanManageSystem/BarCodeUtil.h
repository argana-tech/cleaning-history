//
//  BarCodeUtil.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/11/14.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarCodeUtil : NSObject

+(NSString*) extractCodabar: (NSString*) codabarCode;

@end
