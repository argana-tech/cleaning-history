
//
//  ActionDeleteInfo.m
//  CleanManageSystem
//
//  Created by akifumin on 2014/03/06.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import "ActivityDeleteInfo.h"
#import "Constants.h"
#import "User.h"
#import "NSString+Replace.h"
#import "SBJson.h"
#import "WasherInfoDto.h"
#import "NSMutableURLRequest+UserAgent.h"
#import "RequestUtil.h"

@implementation ActivityDeleteInfo
{
    NSString* _washerId;
    BOOL isResponce;
    NSMutableData *receivedData;
}



- (void) activityDelete: (NSString*) activityId {
    
    receivedData = [[NSMutableData alloc] init];
    
    User *user = [User getInstance];
    
    NSString *urlStr = [API_URL stringByAppendingString: API_ACTIVITY_REMOVE];
    NSURL *url                   = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    
    // パラメータ作成
    NSMutableDictionary* params = [@{
                                     PRM_AUTH_KEY : user.authKey,
                                     PRM_ACTIVITY_ID : activityId
                                     } mutableCopy];
    NSString *post               = [RequestUtil createQueryString:params];
    
    NSData *postData             = [post dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:postData];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        LOG(@"[アクティビティの取り消し]-開始...");
        LOG(@"[アクティビティの取り消し]-[POST] url:%@", [url path]);
        LOG(@"[アクティビティの取り消し]-[POST] parm:%@", params);
    }
    
}


#pragma mark - レスポンス受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        LOG(@"[アクティビティの取り消し]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        NSString* message = [NSString stringWithFormat:@"アクティビティの取り消しに失敗しました。\nstatusCode:%d (%@)",[httpResponse statusCode],
                             [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
        
        //        [self.delegate activityDeleteResult:Nil errorMessage:[NSString replaceBr:message]];
        [self.delegate activityDeleteResult:NO dadeleteIfnota:nil errorMessage:message];
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
        LOG(@"[アクティビティの取り消し]-データ受信エラー データ無し");
        NSString* message = @"アクティビティの取り消しに失敗しました。受信データがありませんでした。";
        [self.delegate activityDeleteResult:NO dadeleteIfnota:nil errorMessage:message];
        return;
    }
    
    // JSONへ変換
    NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *statuses = [json_string JSONValue];
    LOG(@"[アクティビティの取り消し]-受信データ %@", statuses);
    
    NSString* error = [statuses objectForKey:@"error"];
    
    if (error == nil) {
        
        
        if ([statuses objectForKey:PRM_AUTH_KEY ] != nil ) {
            // アクティビティの取り消し成功
            BOOL result = [[statuses objectForKey:@"result"] boolValue];
            if (result) {
                // 成功
                [self.delegate activityDeleteResult:YES dadeleteIfnota:statuses errorMessage:nil];
                
                
            } else {
                NSString* message = @"アクティビティの取り消しに失敗しました。結果が正しくありません。";
                [self.delegate activityDeleteResult:NO dadeleteIfnota:nil errorMessage:message];
            }
        } else {
            // 失敗
            NSString* message = @"アクティビティの取り消しに失敗しました。認証キーが取得できませんでした。";
            [self.delegate activityDeleteResult:NO dadeleteIfnota:nil errorMessage:message];
        }
    } else {
        // error
        NSString* message = [NSString stringWithFormat:@"アクティビティの取り消しに失敗しました。エラーが発生しました。"];
        [self.delegate activityDeleteResult:NO dadeleteIfnota:nil errorMessage:message];
    }
    
    
}

#pragma mark - 通信エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    LOG(@"[アクティビティの取り消し]-通信エラー - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    NSString* message = @"サーバーと通信できないためアクティビティの取り消しに失敗しました。ネットワークの状態を確認してから再度アクティビティの取り消しを行ってください。";
    [self.delegate activityDeleteResult:NO dadeleteIfnota:nil errorMessage:message];
}


@end
