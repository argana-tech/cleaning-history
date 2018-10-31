//
//  SearchWasherInfo.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/13.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "SearchWasherInfo.h"
#import "Constants.h"
#import "User.h"
#import "NSString+Replace.h"
#import "SBJson.h"
#import "WasherInfoDto.h"
#import "NSMutableURLRequest+UserAgent.h"

static const NSString *WASHER_DATA = @"washer_data";

// 浸漬消毒
#define TYPE_DIP @"浸漬消毒"

@implementation SearchWasherInfo {
    NSString* _washerId;
    BOOL isResponce;
    NSMutableData *receivedData;
    NSInteger tag;
}



- (void) searchWahser: (NSString*) washerId tag:(NSInteger)_tag {
    
    tag = _tag;
    receivedData = [[NSMutableData alloc] init];
    _washerId = washerId;
    User *user = [User getInstance];
    // サーバーへリクエストを送信
    NSString *urlStr = [API_URL stringByAppendingString: API_WASHER];
    urlStr = [urlStr stringByAppendingString:washerId];
    NSString* authParameter = [NSString stringWithFormat: @"?%@=%@", PRM_AUTH_KEY, user.authKey];
    urlStr = [urlStr stringByAppendingString:authParameter];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        LOG(@"[洗浄種別情報検索]-開始...");
        LOG(@"[洗浄種別情報検索]-[POST] url:%@", [url path]);
    }
    
}


#pragma mark - レスポンス受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        LOG(@"[洗浄種別情報検索]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        NSString* message = [NSString stringWithFormat:@"洗浄種別情報検索に失敗しました。\nstatusCode:%d (%@)",[httpResponse statusCode],
                             [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
        
        [self.delegate searchWasherResult:Nil errorMessage:[NSString replaceBr:message]];
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
        LOG(@"[洗浄種別情報検索]-データ受信エラー データ無し");
        NSString* message = @"洗浄種別情報検索に失敗しました。受信データがありませんでした。";
        [self.delegate searchWasherResult:Nil errorMessage:[NSString replaceBr:message]];
        return;
    }
    
    // JSONへ変換
    NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *statuses = [json_string JSONValue];
    LOG(@"[洗浄種別情報検索]-受信データ %@", statuses);
    
    NSString* error = [statuses objectForKey:@"error"];
    
    WasherInfoDto* washerInfoDto = [WasherInfoDto new];
    washerInfoDto.tag = tag;
    
    if (error == nil) {
        
        
        if ([statuses objectForKey:PRM_AUTH_KEY ] != nil ) {
            BOOL result = [statuses[@"result"] boolValue];
            if (result) {
                
                
                // 洗浄種別情報検索成功
                NSDictionary* washerInfoDictionary = (NSDictionary*)[statuses objectForKey:WASHER_DATA];
                if (0 < [washerInfoDictionary count]) {
                    WasherInfoDto* washerInfoDto = [WasherInfoDto create:washerInfoDictionary];
                    washerInfoDto.tag = tag;
                    washerInfoDto.isEnable = YES;
                    
                    NSString* message = nil;
                    if( [washerInfoDto.alertMessage class] != [NSNull class] ) {
                        message = washerInfoDto.alertMessage;
                    }
                    [self.delegate searchWasherResult:washerInfoDto errorMessage:[NSString replaceBr:message] ];
                    
                    
                } else {
                    NSString* message = [NSString stringWithFormat: @"「%@」で検索しましたが該当する洗浄種別は見つかりませんでした。\n登録されていない洗浄・消毒機器、または洗浄・消毒機器IDではない可能性があります。", _washerId];
                    [self.delegate searchWasherResult:washerInfoDto errorMessage:message];
                }
            } else {
                NSString* message = [NSString stringWithFormat: @"「%@」はフォーマットが異なります。", _washerId];
                [self.delegate searchWasherResult:washerInfoDto errorMessage:message];
            }
        } else {
            // 失敗
            NSString* message = @"洗浄種別情報検索に失敗しました。";
            [self.delegate searchWasherResult:washerInfoDto errorMessage:[NSString replaceBr:message]];
        }
    } else {
        // error
        NSString* message = [NSString stringWithFormat:@"洗浄種別情報検索に失敗しました。\n"];
        [self.delegate searchWasherResult:washerInfoDto errorMessage:[NSString replaceBr:message]];
    }
    
    
}

#pragma mark - 通信エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    LOG(@"[洗浄種別情報検索]-通信エラー - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    NSString* message = @"サーバーと通信できないため洗浄種別情報検索に失敗しました。ネットワークの状態を確認してから再度洗浄種別情報検索を行ってください。";
    [self.delegate searchWasherResult:Nil errorMessage:[NSString replaceBr:message]];
}



@end
