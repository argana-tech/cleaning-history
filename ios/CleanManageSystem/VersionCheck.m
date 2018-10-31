//
//  VersionCheck.m
//  CleanManageSystem
//
//  Created by akifumin on 2014/01/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import "VersionCheck.h"
#import "Constants.h"
#import "NSMutableURLRequest+UserAgent.h"


@implementation VersionCheck


#pragma mark アプリを更新する必要があるか YES:最新のアプリがリリースされている NO:最新の状態
+ (BOOL) isUpdateVersion : (NSError *__autoreleasing *) updateError {
    
    
    // サーバーへリクエストを送信
    NSString *urlStr = [API_URL stringByAppendingString: API_VERSION_TXT];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response      = nil;
    NSError *error ;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* message;
    if (error) {
        // エラー
        message = [NSString stringWithFormat:@"サーバーからの最新アプリバージョンが取得できませんでした。\n%@", error];
        
    } else {
        
        if (data) {
            // データあり
            
            // error
            NSString *error_str =  [error localizedDescription];
            if (0 < [error_str length]) {
                // エラー
                message = [NSString stringWithFormat:@"サーバーからの最新アプリバージョンが取得できませんでした。\n%@", error_str];
            } else {
                // 取得成功
                
                NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSString* versionTxt = [ret stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                NSString* version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                // バージョン比較 完全一致 app:1.0.1 = serv:1.0.1 ○
                if ([version isEqualToString:versionTxt]) {
                    // 最新のバージョン
                    return NO;
                } else {
                    // 最新のバージョンではない
                    return YES;
                }
                
/*
                // バージョン比較 完全比較 app:1.0.1 < serv:1.0.2
                int result = [VersionCheck compareVersion:version serverVersion:versionTxt];
                
                if (0 == result) {
                    // 最新のバージョン
                    return NO;
                } else if (0 < result) {
                    // 最新のより最新バージョン
                    NSString* message =  [NSString stringWithFormat:@"本アプリはサーバーで管理しているバージョンよりもバージョンが上です。\n\n本アプリ:%@\nサーバー:%@", version, versionTxt];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"アプリバージョンチェック" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
                    [alert show];
                    return NO;
                } else {
                    // 最新のバージョンではない
                    return YES;
                }
 */
            }
        } else {
            // データなし
            message = @"サーバーから最新のアプリバージョン情報を取得できませんでした。";
        }
    }
    
    // エラー設定
    *updateError = [[NSError alloc] initWithDomain:message code:0 userInfo:nil];
    return YES;
}

// アプリのバージョンとサーバで管理しているバージョンを比較する
// 結果
//   0: 同じ
//   1: サーバで管理しているバージョンよりも新しい
//  -1: 最新ではない
+ (int) compareVersion : (NSString*) apliVersion serverVersion:(NSString*)serverVersion {
    LOG(@"ver. アプリ:%@ サーバー:%@", apliVersion, serverVersion);
    if (apliVersion == serverVersion) {
        return 0;
    }
    
    NSArray *apli_components = [apliVersion componentsSeparatedByString:@"." ];
    NSArray *server_components = [serverVersion componentsSeparatedByString:@"." ];
    int len = fmin([apli_components count],[server_components count]);
    
    for (int i = 0; i < len; i++) {
        // A bigger than B
        if ([apli_components[i] intValue] > [server_components[i] intValue]) {
            return 1;
        }
        
        // B bigger than A
        if ([apli_components[i] intValue] < [server_components[i] intValue]) {
            return -1;
        }
    }
    
    // If one's a prefix of the other, the longer one is greater.
    if ([apli_components count] > [server_components count]) {
        return 1;
    }
    
    if ([apli_components count] < [server_components count]) {
        return -1;
    }
    
    // Otherwise they are the same.
    return 0;
}


@end
