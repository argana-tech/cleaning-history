//
//  NSMutableURLRequest+UserAgent.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/20.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "NSMutableURLRequest+UserAgent.h"

@implementation NSMutableURLRequest (UserAgent)

#pragma mark - リクエストにユーザエージェントを追加する
+ (id)requestWithURLUserAgent:(NSURL *)URL {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
    [request setValue:[NSMutableURLRequest buildUserAgent] forHTTPHeaderField:@"User-Agent"];
    return request;
}

#pragma mark - ユーザエージェントを組み立てる
// [アプリ名]/[アプリバージョン] ([端末]; [OSバージョン]; [OS名]; [端末言語])
+ (NSString*)buildUserAgent {
    NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString *modelname = [UIDevice currentDevice].model;
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *iOSName = [[UIDevice currentDevice] systemName];
    NSArray  *langs = [NSLocale preferredLanguages];
    NSString *currentLanguage = [langs objectAtIndex:0];
    NSString *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@; %@; %@)", bundleName, version, modelname, iOSVersion, iOSName, currentLanguage];
    
    NSLog(@"User-Agent:%@", userAgent);
    
    return userAgent;
}
@end
