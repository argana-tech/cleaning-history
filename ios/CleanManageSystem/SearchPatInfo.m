//
//  SearchPatInfo.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/11/26.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "SearchPatInfo.h"
#import "Constants.h"
#import "SBJson.h"
#import "User.h"
#import "NSMutableURLRequest+UserAgent.h"

@implementation SearchPatInfo {
    BOOL isResponce;
    NSString* _patId;
    NSMutableData* receivedData;
    NSInteger tag;
}


#pragma mark - 患者検索処理（非同期）
-(void) searchPatId: (NSString*)patId tag:(NSInteger)_tag {
    
    tag = _tag;
    receivedData = [[NSMutableData alloc] init];
    _patId = patId;
    User *user = [User getInstance];
    // サーバーへリクエストを送信
    NSString *urlStr = [API_URL stringByAppendingString: API_PATIENT];
    urlStr = [urlStr stringByAppendingString:patId];
    NSString* authParameter = [NSString stringWithFormat: @"?%@=%@", PRM_AUTH_KEY, user.authKey];
    urlStr = [urlStr stringByAppendingString:authParameter];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        LOG(@"[患者検索]-開始...");
        LOG(@"[患者検索]-[POST] url:%@", [url path]);
    }
    
}


#pragma mark - レスポンス受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        LOG(@"[患者検索]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        NSString* message = [NSString stringWithFormat:@"患者検索に失敗しました。\nstatusCode:%d (%@)",[httpResponse statusCode],
                             [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
        
        [self.delegate searchPatInfoResult:Nil errorMessage:message];
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
        LOG(@"[患者検索]-データ受信エラー データ無し");
        NSString* message = @"患者検索に失敗しました。受信データがありませんでした。";
        [self.delegate searchPatInfoResult:Nil errorMessage:message];
        return;
    }
    
    // JSONへ変換
    NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *statuses = [json_string JSONValue];
    LOG(@"[患者検索]-受信データ %@", statuses);
    
    NSString* error = [statuses objectForKey:@"error"];
    
    PatInfoDto* patInfoDto = [PatInfoDto new];
    patInfoDto.tag = tag;
    
    if (error == nil) {
        
        
        if ([statuses objectForKey:PRM_AUTH_KEY ] != nil ) {
            
            BOOL result = [statuses[@"result"] boolValue];
            if (result) {
                // 患者検索成功
                NSDictionary* patInfoDictionary = (NSDictionary*)[statuses objectForKey:PATIENT];
                if (0 < [patInfoDictionary count]) {
                    
                    PatInfoDto* patInfoDto = [PatInfoDto create:patInfoDictionary];
                    patInfoDto.tag = tag;
                    patInfoDto.isEnable = YES;
                    [self.delegate searchPatInfoResult:patInfoDto errorMessage:nil];
                    
                } else {
                    NSString* message = [NSString stringWithFormat: @"「%@」で検索しましたが該当するデータは見つかりませんでした。", _patId];
                    [self.delegate searchPatInfoResult:patInfoDto errorMessage:message];
                }
            } else {
                NSString* message = [NSString stringWithFormat: @"「%@」で検索しましたが該当するデータは見つかりませんでした。", _patId];
                [self.delegate searchPatInfoResult:patInfoDto errorMessage:message];
            }
            
          
        } else {
            // 失敗
            NSString* message = @"患者検索に失敗しました。";
            [self.delegate searchPatInfoResult:patInfoDto errorMessage:message];
        }
    } else {
        // error
        NSString* message = [NSString stringWithFormat:@"患者検索に失敗しました。\n"];
        [self.delegate searchPatInfoResult:patInfoDto errorMessage:message];
    }
    
    
}

#pragma mark - 通信エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    LOG(@"[患者検索]-通信エラー - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    NSString* message = @"サーバーと通信できないため患者検索に失敗しました。ネットワークの状態を確認してから再度患者検索を行ってください。";
    [self.delegate searchPatInfoResult:Nil errorMessage:message];
}


@end
