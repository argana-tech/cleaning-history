//
//  RecentActivity.m
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import "RecentActivity.h"
#import "Constants.h"
#import "User.h"
#import "NSString+Replace.h"
#import "SBJson.h"
#import "WasherInfoDto.h"
#import "NSMutableURLRequest+UserAgent.h"
#import "RequestUtil.h"
#import "RecentActivityDto.h"


@implementation RecentActivity
{
    NSString* _washerId;
    BOOL isResponce;
    NSMutableData *receivedData;
}



- (void) search {
    
    receivedData = [[NSMutableData alloc] init];
    
    User *user = [User getInstance];
    

    
    NSString *urlStr = [API_URL stringByAppendingString: API_RECENT_ACTIVITY];
//    urlStr = [urlStr stringByAppendingString:washerId];
    NSString* authParameter = [NSString stringWithFormat: @"?%@=%@", PRM_AUTH_KEY, user.authKey];
    urlStr = [urlStr stringByAppendingString:authParameter];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];

    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection) {
        LOG(@"[履歴の取得]-開始...");
        LOG(@"[履歴の取得]-[POST] url:%@", [url path]);
    }
    
}


#pragma mark - レスポンス受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        LOG(@"[履歴の取得]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        NSString* message = [NSString stringWithFormat:@"履歴の取得に失敗しました。\nstatusCode:%d (%@)",[httpResponse statusCode],
                             [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
        
        //        [self.delegate activityDeleteResult:Nil errorMessage:[NSString replaceBr:message]];
        [self.delegate recentActivityResult:nil errorMessage:message];
        return;
    } else {
        isResponce = YES;
    }
    
}

#pragma mark - データ受信
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (isResponce == NO) {
        return;
    }
    
    [receivedData appendData:data];
}

#pragma mark - DidFinishLoading データ受信が成功したとき
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (isResponce == NO) {
        return;
    }
    
    if ([receivedData length] < 1) {
        //　データ無し
        LOG(@"[履歴の取得]-データ受信エラー データ無し");
        NSString* message = @"履歴の取得に失敗しました。受信データがありませんでした。";
        [self.delegate recentActivityResult:nil errorMessage:message];
        return;
    }
    
    // JSONへ変換
    NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *statuses = [json_string JSONValue];
    LOG(@"[履歴の取得]-受信データ %@", statuses);
    
    NSString* error = [statuses objectForKey:@"error"];
    
    if (error == nil) {
        
        
        if ([statuses objectForKey:PRM_AUTH_KEY ] != nil ) {
            // 履歴の取得成功
            NSDictionary* resultActivities = [statuses objectForKey:@"activities"];
            
            NSMutableArray* result = [RecentActivityDto createArrayDto:resultActivities];
            
            [self.delegate recentActivityResult:result errorMessage:nil];
            
//            if (result)
//                // 成功
//                [self.delegate recentActivityResult:nil errorMessage:nil];
//                
//                
//            } else {
//                NSString* message = @"履歴の取得に失敗しました。結果が正しくありません。";
//                [self.delegate recentActivityResult:nil errorMessage:message];
//            }
        } else {
            // 失敗
            NSString* message = @"履歴の取得に失敗しました。認証キーが取得できませんでした。";
            [self.delegate recentActivityResult:nil errorMessage:message];
        }
    } else {
        // error
        NSString* message = [NSString stringWithFormat:@"履歴の取得に失敗しました。エラーが発生しました。"];
        [self.delegate recentActivityResult:nil errorMessage:message];
    }
    
    
}

#pragma mark - 通信エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    LOG(@"[履歴の取得]-通信エラー - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    NSString* message = @"サーバーと通信できないため履歴の取得に失敗しました。ネットワークの状態を確認してから再度履歴の取得を行ってください。";
    [self.delegate recentActivityResult:nil errorMessage:message];
}



@end

