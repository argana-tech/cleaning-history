//
//  RequestUtil.m
//  CleanManageSystem
//
//  Created by akifumin on 2014/03/06.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import "RequestUtil.h"

@implementation RequestUtil


#pragma mark - パラメータ文字列を作成
 + (NSString*) createQueryString : (NSMutableDictionary*)dictionary {
    
    NSMutableString *queryString = [NSMutableString stringWithFormat:@""];
    for (NSString* key in dictionary.allKeys) {
        NSString* str = [NSString stringWithFormat:@"%@=%@&", key, [dictionary objectForKey:key]];
        [queryString appendString:str];
    }
    
 
    return queryString;
}

@end
