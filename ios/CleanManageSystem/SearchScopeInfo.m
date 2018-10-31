//
//  SearchScopeInfo.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/09.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "SearchScopeInfo.h"
#import "User.h"
#import "Constants.h"
#import "SBJson.h"
#import "ScopeInfoDto.h"
#import "NSString+Replace.h"
#import "NSMutableURLRequest+UserAgent.h"

#define FORMAT_RESULT  @"format_result"

@implementation SearchScopeInfo
{
    BOOL isResponce;
    NSString* _scopeId;
    NSMutableData* receivedData;
    NSInteger tag;
}

static const NSString *LAST_ACTIVITY = @"last_activity";
static const NSString *DUPLICATE_ACTION = @"duplicate_action";
static const NSString *DUPLICATE_ACTION_MESSAGE = @"duplicate_action_message";


#pragma mark - スコープ情報検索処理（非同期）
-(void) searchScopeId: (NSString*)scopeId actionId : (int)actionId tag:(NSInteger)_tag {
    
    tag = _tag;
    receivedData = [[NSMutableData alloc] init];
    _scopeId = scopeId;
    User *user = [User getInstance];
    // サーバーへリクエストを送信
    NSString *urlStr = [API_URL stringByAppendingString: API_SCOPE];
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat: @"?%@=%@&%@=%d", PRM_SCOPE_ID, scopeId, PRM_ACTION_ID, actionId]];
    NSString* authParameter = [NSString stringWithFormat: @"&%@=%@", PRM_AUTH_KEY, user.authKey];
    urlStr = [urlStr stringByAppendingString:authParameter];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        LOG(@"[スコープ情報検索]-開始...");
        LOG(@"[スコープ情報検索]-[POST] url:%@", [url path]);
    }
    
}


#pragma mark - レスポンス受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        LOG(@"[スコープ情報検索]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        NSString* message = [NSString stringWithFormat:@"スコープ情報検索に失敗しました。\nstatusCode:%d (%@)",[httpResponse statusCode],
                             [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
        
        [self.delegate searchScopeInfoResult:Nil errorMessage:[NSString replaceBr:message]];
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
        LOG(@"[スコープ情報検索]-データ受信エラー データ無し");
        NSString* message = @"スコープ情報検索に失敗しました。受信データがありませんでした。";
        [self.delegate searchScopeInfoResult:Nil errorMessage:[NSString replaceBr:message]];
        return;
    }
    
    // JSONへ変換
    NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *statuses = [json_string JSONValue];
    LOG(@"[スコープ情報検索]-受信データ %@", statuses);
    
    NSString* error = [statuses objectForKey:@"error"];
    
    ScopeInfoDto* scopeInfoDto = [ScopeInfoDto new];
    scopeInfoDto.tag = tag;
    if (error == nil) {
        
        
        if ([statuses objectForKey:PRM_AUTH_KEY ] != nil ) {
            
            
            // スコープ情報検索成功
            NSDictionary* scopeInfoDictionary = (NSDictionary*)[statuses objectForKey:LAST_ACTIVITY];
            if (0 < [scopeInfoDictionary count]) {
                ScopeInfoDto* scopeInfoDto = [ScopeInfoDto create:scopeInfoDictionary];
                scopeInfoDto.tag = tag;
                scopeInfoDto.isEnable = YES;
                
                NSString* message = nil;
                BOOL duplicate = [scopeInfoDictionary[DUPLICATE_ACTION] boolValue];
                if (duplicate) {
                    message = scopeInfoDictionary[DUPLICATE_ACTION_MESSAGE];
                }
                
                BOOL formatResult = [statuses[FORMAT_RESULT] boolValue];
                if (!formatResult) {
                    // フォーマットが違う
                    if (0 < [message length]) {
                        message  = [NSString stringWithFormat:@"%@。\n", message];
                    } else {
                        message = @"";
                    }
                    
                    message = [NSString stringWithFormat: @"%@「%@」はスコープIDではない可能性があります", message, _scopeId];
                    scopeInfoDto.errorMessage = @"スコープIDではない可能性があります";
                }
                
                [self.delegate searchScopeInfoResult:scopeInfoDto errorMessage:[NSString replaceBr:message] ];
                
                
            } else {
                // スコープ
                NSString* message;

                BOOL formatResult = [statuses[FORMAT_RESULT] boolValue];
                if (formatResult) {
                    // 履歴なしの場合は新規の場合があるので登録OK
                    scopeInfoDto.isEnable = YES;
                    message = [NSString stringWithFormat: @"「%@」で検索しましたが該当するスコープ情報は見つかりませんでした。", _scopeId];
                    scopeInfoDto.errorMessage = @"スコープ情報がありません";
                } else {
                    // フォーマットが違う
                    message = [NSString stringWithFormat: @"「%@」はスコープIDではない可能性があります", _scopeId];
                    scopeInfoDto.errorMessage = @"スコープIDではない可能性があります";
                }
              
                
                [self.delegate searchScopeInfoResult:scopeInfoDto errorMessage:message];
            }
        } else {
            // 失敗
            NSString* message = @"スコープ情報検索に失敗しました。";
            [self.delegate searchScopeInfoResult:scopeInfoDto errorMessage:[NSString replaceBr:message]];
        }
    } else {
        // error
        NSString* message = [NSString stringWithFormat:@"スコープ情報検索に失敗しました。\n"];
        [self.delegate searchScopeInfoResult:scopeInfoDto errorMessage:[NSString replaceBr:message]];
    }
    
    
}

#pragma mark - 通信エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    LOG(@"[スコープ情報検索]-通信エラー - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    NSString* message = @"サーバーと通信できないためスコープ情報検索に失敗しました。ネットワークの状態を確認してから再度スコープ情報検索を行ってください。";
    [self.delegate searchScopeInfoResult:Nil errorMessage:[NSString replaceBr:message]];
}


@end
