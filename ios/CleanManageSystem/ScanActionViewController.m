//
//  ActionViewController.m
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/16.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import "ScanActionViewController.h"
#import "SVProgressHUD.h"
#import "ZBarViewControllerSingleton.h"
#import "User.h"
#import "Constants.h"
#import "SBJson.h"
#import "UIColor+Hex.h"
#import "ActionField.h"
#import "BarCodeUtil.h"
#import "MainAppDelegate.h"
#import "ScopeInfoDto.h"
#import "WasherInfoDto.h"
#import "UIColor+FlatUI.h"
#import "NSString+Replace.h"
#import "NSMutableURLRequest+UserAgent.h"


#define OBSERVER_REQUIRE_TEXT @"OBSERVER_REQUIRE_TEXT"

#define ALERT_SCOPE 1
#define ALERT_PATIENT 2
#define ALERT_CLEANING_TYPE 3
#define ALERT_SAME_SCOPE 4

#define USER_INFO_ROW_COUNT 3
#define SAVE_ROW_COUNT 1

#define ROW_USER_ID 0
#define ROW_USER_NAME 1
#define ROW_USER_KA 2

#define SECTION_USER 0
#define SECTION_ACTION_FIELD 1
#define SECTION_SAVE 2

#define ERROR_REQUIRE_AUTHOLOIZE_CODE 9999

#define TAG_PAIENT_ID_FIELD 1


@interface ScanActionViewController ()

@end

@implementation ScanActionViewController {
    float animatedDistance;
    // 画面上のアクションフィールド
    NSMutableArray* actionFields;
    int actionFieldIndex;
    int sectionActionFieldIndex;
    // 登録日時
    NSString* createdAt;
    // 保存メッセージ
    NSString* savedMessage;
    // 検証エラーメッセージ
    int invalidLastAction;
    // 経過日数
    NSString* elapsedMessage;
    // 実施登録日
    NSString* actionCompletedAt;
    // 患者情報
    PatInfoDto* savedResultPatInfoDto;
    
    // レスポンス
    BOOL isResponce;
    ZBarReaderViewController* reader;
    
    // alert
    CustomAlertViewController* customAlertViewController;
    UILabel* backLabel;
    float searchY;
    
    
    /* 患者検索 */
    // 患者IDのセクション
    int patientSection;
    NSString* patIdFieldId;
    // 検索患者情報
    PatInfoDto *searchPatInfoDto;
    // 患者情報行数
    int patInfoRowCount;
    // 患者情報行情報
    NSMutableArray*  patInfondexPaths;
    // 検索実施
    BOOL isSearchPatInfo;
    // 患者cell
    UITableViewCell *patIdCell;
    UILabel* searchPatInfoWarningLabel;
    
    /* スコープ */
    // スコープのセクション
    int scopeSection;
    // スコープ情報
    ScopeInfoDto* searchScopeInfoDto;
    // スコープ情報行数
    int scopeInfoRowCount;
    // スコープ情報行情報
    NSMutableArray* scopeInfondexPaths;
    // 検索実施
    BOOL isSearchScopeInfo;
    
    /* 洗浄種別 */
    // 洗浄種別のセクション
    int washerSection;
    // 洗浄種別情報
    WasherInfoDto* searchWasherInfoDto;
    // 洗浄種別情報行数
    int washerInfoRowCount;
    // 洗浄種別情報行情報
    NSMutableArray* washerInfondexPaths;
    // 検索実施
    BOOL isWasherScopeInfo;
    
    
    // 保存セル
    UITableViewCell* saveCell;
    
    // 必須テキストフィールドの状態が入る
    // key : テキストフィールドのインデックス
    // value : 0 -> 未入力, 1 -> 入力済み
    NSMutableDictionary *requireTextDictionary;
    
    // 保存ボタンの状態
    // YES : 有効, NO : 無効
    BOOL saveEnable;
    
    // 受信データ
    NSMutableData* receivedData;
    
    BOOL scopeFieldFocusFlg;
    
    
}
@synthesize actionTableView, headers, actionId, actionName, targetTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setGestureRecognizer];
    
    
    [self addBtn];
    
    // 保存セル状態初期設定
    saveEnable = YES;
    
    requireTextDictionary = [NSMutableDictionary dictionary];
    
    // タイトル
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 入力", actionName];
    self.navigationItem.backBarButtonItem.title = @"修正";
    actionFields = [self getActionFields];
    
    
    actionTableView.dataSource = self;
    actionTableView.delegate = self;
    
    // 可
    isSearchPatInfo = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    
    // 初回のみスコープへフォーカスを当てる
    if (scopeFieldFocusFlg == NO) {
        for (ActionField* actionField in actionFields) {
            if (actionField.isScope) {
                [actionField.textField becomeFirstResponder];
                scopeFieldFocusFlg = YES;
                break;
            }
        }
    }
    
}


#pragma mark - アクションメニューの取得
-(NSMutableArray*) getActionFields {
    
    User *user = [User getInstance];
    // アクションIDよりアクションメニューを取得する
    NSString *urlStr = [NSString stringWithFormat: @"/api/action/%d.json?%@=%@",  actionId, PRM_AUTH_KEY, user.authKey];
    NSURL *url                   = [NSURL URLWithString:[API_URL stringByAppendingString:urlStr]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    NSURLResponse *response      = nil;
    NSError *error               = nil;
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //
    LOG(@"[アクションフィールド取得]-[GET] url:%@", [url path]);
    // エラー情報
    if ( error ) {
        LOG(@"[アクションフィールド取得]-通信エラー %@ %d %@", [error domain], [error code], [error localizedDescription]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"アクション取得エラー"
                                                            message:@"サーバーと通信できないためアクションの取得に失敗しました。ネットワークの状態を確認してから画面を開き直してください。"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        return [NSMutableArray array];
    }
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        // レスポンスエラー
        LOG(@"[アクションフィールド取得]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"アクション取得エラー"
                                                            message:[NSString stringWithFormat: @"アクションの取得に失敗しました。ステータスコード:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        return [NSMutableArray array];
    }
    
    if (!data) {
        // データ無し
        LOG(@"[アクションフィールド取得]-データ受信エラー データ無し");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"アクション取得エラー"
                                                            message:[NSString stringWithFormat: @"アクションフィールドの取得に失敗しました。アクションフィールドデータが取得できませんでした。"]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        return [NSMutableArray array];
    }
    
    // JSONへ
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *statuses = [json_string JSONValue];
    
    LOG(@"[アクションフィールド取得]-受信データ %@", statuses);
    
    
    NSString *errorStr = [statuses objectForKey:ERROR ];
    if (errorStr == nil) {
        // 正常
        
        // authKeyの再設定
        user.authKey = [statuses objectForKey:PRM_AUTH_KEY];
        
        NSDictionary *action = [statuses objectForKey:ACTION];
        NSDictionary *fields = [action objectForKey:FIELDS];
        NSMutableArray* _actionFileds = [NSMutableArray array];
        // スコープID
        [_actionFileds addObject:[ActionField scopeField]];
        for (NSDictionary *field in fields) {
            ActionField *actionField = [ActionField create:field];
            [_actionFileds addObject:actionField];
        }
        return _actionFileds;
    } else {
        // エラー
        [self errorAction:errorStr];
        return nil;
    }
}

-(void) errorAction: (NSString*)errorStr {
    // エラー
    if ([errorStr isEqualToString: ERROR_REQUIRE_AUTHOLOIZE]) {
        // timeout
        
        // 利用者情報をクリア
        User *user = [User getInstance];
        [user logout];
        
        [self timeOutErrorAlertView];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                            message:[NSString stringWithFormat: @"エラーが発生しました。%@", errorStr]
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        
    }
}

-(void)timeOutErrorAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"タイムアウトエラー"
                                                        message:[NSString stringWithFormat: @"再度ログインし直してください。"]
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"はい",
                              nil];
    alertView.tag = ERROR_REQUIRE_AUTHOLOIZE_CODE;
    [alertView show];
}

#pragma mark - キーボードタップ
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [actionTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [actionTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)addBtn {
}

#pragma mark - 保存押下
-(void) clickSave {
    
    for (ActionField *actionField in actionFields) {
        // フォーカスを外す
        [actionField.textField resignFirstResponder];
    }
    
    // 検証
    if ([self isValidateCheck]) {
        // OK!!
        [self save];
    } else {
        // NO!!
        return;
    }
}


#pragma mark - 保存処理(非同期)
-(void)save {
    // サーバーへリクエストを送信
    NSString *urlStr = [API_URL stringByAppendingString: @"/api/activity/save.json"];
    NSURL *url                   = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    
    // パラメータ作成
    NSMutableDictionary* params = [self createParams];
    NSString *post               = [self createQueryString:params];
    
    NSData *postData             = [post dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:postData];
    receivedData = [[NSMutableData alloc] init];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        // 通信開始
        [SVProgressHUD showWithStatus:@"保存中..." maskType:SVProgressHUDMaskTypeGradient];
        LOG(@"[保存]-処理開始");
        LOG(@"[保存]-[POST] url:%@ prm:%@", [url path], post);
    }
}

#pragma mark - 検証(同期)
-(BOOL) isValidateCheck {
    
    // サーバーへリクエストを送信
    NSString *urlStr = [API_URL stringByAppendingString: @"/api/activity/validate.json"];
    NSURL *url                   = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    // パラメータ作成
    NSMutableDictionary* params = [self createParams];
    NSString *post               = [self createQueryString:params];
    
    NSData *postData             = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response      = nil;
    NSError *error               = nil;
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:postData];
    
    
    //
    LOG(@"[入力チェック]-[GET] url:%@", post);
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if ([self isConnectionCheck:error response:response data:data]) {
        // 通信OK!!
        
        // JSON
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *statuses = [json_string JSONValue];
        LOG(@"[入力チェック]-受信データ %@", statuses);
        
        NSString *errorStr = [statuses objectForKey:ERROR ];
        if (errorStr == nil) {
            // 正常
            
            // authKeyの再設定
            User *user = [User getInstance];
            user.authKey = [statuses objectForKey:PRM_AUTH_KEY];
            
            // エラー内容
            NSDictionary *errors = [statuses objectForKey:ERRORS];
            if (0 < [errors count]) {
                // 検証NG!!
                [self validationError:statuses errors:errors];
                return NO;
            } else {
                // 検証OK!!
                return YES;
            }
        } else {
            // エラー
            [self errorAction:errorStr];
            return NO;
        }
    } else {
        // 通信NG
        return NO;
    }
}

#pragma mark - 通信チェック
-(BOOL) isConnectionCheck :(NSError*) error response: (NSURLResponse*) response data : (NSData*) data{
    
    
    // エラー情報
    if ( error ) {
        // エラー
        LOG(@"[入力チェック]-通信エラー  %@ %d %@", [error domain], [error code], [error localizedDescription]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"入力チェックエラー"
                                                            message:@"サーバーと通信できないため入力チェックに失敗しました。ネットワークの状態を確認してから再度保存をタップしてください。"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        
        return NO;
    }
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        // レスポンスエラー!!
        LOG(@"[入力チェック]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        LOG(@"[入力チェック]-レスポンス受信エラー DATA:%@", json_string);
        json_string = Nil;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"入力チェックエラー"
                                                            message:[NSString stringWithFormat: @"入力チェックに失敗しました。ステータスコード:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        
        return NO;
    }
    
    if (!data) {
        // データ受信エラー!!
        LOG(@"[入力チェック]-データ受信エラー データ無し");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"入力チェックエラー"
                                                            message:[NSString stringWithFormat: @"入力チェックに失敗しました。入力チェック結果の取得に失敗しました。"]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}




#pragma mark - 検証NG
-(void)validationError : (NSDictionary*)statuses errors :(NSDictionary*) errors {
    
    
    // 入力チェック、フォーマットチェックエラー
    NSMutableString* message = [NSMutableString stringWithFormat:@""];
    // 直前チェックエラーメッセージ
    NSString *validateLastActionMessage;
    
    
    if ([errors objectForKey:PRM_SCOPE_ID]) {
        NSString *msg = [NSString stringWithFormat:@"・%@\n", [errors objectForKey:PRM_SCOPE_ID]];
        [message appendString: msg];
    }
    
    for (NSString* key in errors) {
        if ([key isEqualToString:ERRORS_VALIDATE_LAST_ACTION]) {
            // 直前チェック
            validateLastActionMessage = [errors objectForKey:key];
        } else {
            if ([key isEqualToString:PRM_SCOPE_ID]) {
                
            } else {
                // 入力チェック
                NSString *msg = [NSString stringWithFormat:@"・%@\n", [errors objectForKey:key]];
                [message appendString: msg];
            }
        }
    }
    
    // エラー種類判断、入力チェックエラーを先に表示させる。入力チェックエラーがなくなったら直前チェックエラーを表示する。
    if (0 < [message length]) {
        // 入力チェックエラー
        
        UIAlertView *alert =[[UIAlertView alloc]
                             initWithTitle:@"入力エラー"
                             message:message
                             delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:@"はい", nil
                             ];
        
        [alert show];
        
    } else if (validateLastActionMessage != nil) {
        // 直前チェックエラー
        NSNumber *validateLastActionCode = [statuses objectForKey:ERRORS_VALIDATE_LAST_ACTION];
        if ([validateLastActionCode intValue]== VALIDATE_LAST_ACTION_ERROR) {
            // error
            [self showCustomAlerView:@"直前チェック"
                             message:validateLastActionMessage
                        messageColor:[UIColor redColor]
                       okButtonTitle:@"はい" cancellButtonTitle:nil tag: VALIDATE_LAST_ACTION_ERROR];
        } else if ([validateLastActionCode intValue] == VALIDATE_LAST_ACTION_CONFIRM) {
            // confirm
            [self showCustomAlerView:@"直前チェック"
                             message:validateLastActionMessage
                        messageColor:[UIColor redColor]
                       okButtonTitle:@"はい" cancellButtonTitle:@"いいえ" tag: VALIDATE_LAST_ACTION_CONFIRM];
        }
        
    } else {
        // error
    }
}

#pragma mark - パラメータを作成
-(NSMutableDictionary*)createParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for (ActionField *actionField  in actionFields) {
        if ([actionField.type isEqualToString:FIELDS_TYPE_BOOLEAN] ) {
            [params setObject:@(actionField.actionSwitch.on) forKey:[NSString stringWithFormat:@"fields[%d]", actionField.fieldId]];
        } else  if ([actionField.type isEqualToString:FIELDS_TYPE_BARCODE] || [actionField.type isEqualToString:FIELDS_TYPE_INPUT] ) {
            if (actionField.fieldId  < 0) {
                // PRM_SCOPE_ID
                [params setObject:actionField.textField.text forKey:PRM_SCOPE_ID];
            } else {
                [params setObject:actionField.textField.text forKey:[NSString stringWithFormat:@"fields[%d]", actionField.fieldId]];
            }
        }
    }
    
    // PRM_STAFFM_SH_ID
    User *user = [User getInstance];
    [params setObject:user.userId forKey:PRM_STAFFM_SH_ID];
    
    // PRM_ACTION_ID
    [params setObject:@(self.actionId) forKey:PRM_ACTION_ID];
    
    // PRM_ACTIVITY_ID
    if (self.activityId != nil) {
        // activityIdをつけると更新モードになる
        [params setObject:self.activityId forKey:PRM_ACTIVITY_ID];
    }
    
    return params;
}

#pragma mark - パラメータ文字列を作成
-(NSString*) createQueryString : (NSMutableDictionary*)dictionary {
    
    NSMutableString *queryString = [NSMutableString stringWithFormat:@""];
    for (NSString* key in dictionary.allKeys) {
        NSString* str = [NSString stringWithFormat:@"%@=%@&", key, [dictionary objectForKey:key]];
        [queryString appendString:str];
    }
    
    // authKey
    User *user = [User getInstance];
    
    NSString* str = [NSString stringWithFormat:@"%@=%@", PRM_AUTH_KEY, user.authKey];
    [queryString appendString:str];
    
    return queryString;
}

#pragma mark - 保存レスポンス受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        // レスポンスエラー
        isResponce = NO;
        LOG(@"[保存]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        [SVProgressHUD dismiss];
        NSString* message = [NSString stringWithFormat:@"保存に失敗しました。ステータスコード:%d (%@)",
                             [httpResponse statusCode],
                             [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存エラー"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        return;
    } else {
        // レスポンスエラー
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
    
    [SVProgressHUD dismiss];
    
    if (isResponce == NO) {
        // レスポンスエラー
        NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSDictionary *statuses = [json_string JSONValue];
        LOG(@"[保存]-レスポンスエラー[HTML] %@", json_string);
        LOG(@"[保存]-レスポンスエラー[JSON] %@", statuses);
        statuses = nil;
        json_string = nil;
        return;
    }
    
    if ([receivedData length] < 1) {
        LOG(@"[保存]-データ受信エラー データ無し");
        return;
    }
    NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *statuses = [json_string JSONValue];
    LOG(@"[保存]-受信データ %@", statuses);
    
    
    NSString *errorStr = [statuses objectForKey:ERROR];
    if (errorStr == nil) {
        // authKeyの設定
        User *user = [User getInstance];
        user.authKey = [statuses objectForKey:PRM_AUTH_KEY];
        NSDictionary* activity = [statuses objectForKey:ACTIVITY];
        
        // 登録時間を設定
        createdAt = [activity objectForKey:ACTIVITY_CREATED_AT];
        actionCompletedAt = [activity objectForKey:ACTIVITY_ACTION_COMPLETED_AT];
        
        self.activityId = [activity objectForKey:ACTIVITY_ID];
        
        // 直前チェックエラー 1:エラー 0:エラー無し
        invalidLastAction = [[statuses objectForKey:SAVED_INVALID_LAST_ACTION] intValue];
        
        // 保存メッセージ
        savedMessage = [statuses objectForKey:SAVED_MESSAGE];
        if ( [NSNull null] == (NSObject*)savedMessage ) {
            savedMessage = @"";
        } else  {
            savedMessage = [NSString replaceBr:savedMessage];
        }
        
        // 経過日数
        elapsedMessage = [statuses objectForKey:SAVED_ELAPSED_MESSAGE];
        if ( [NSNull null] == (NSObject*)elapsedMessage ) {
            elapsedMessage = @"";
        }
        
        // 患者情報の取得
        NSMutableDictionary* patInfoDictionary;// [patActivityField objectForKey:FIELDS_PATIENT_DATA];
        NSMutableDictionary* activityFields = [activity objectForKey:ACTIVITY_ACTIVITY_FIELDS];
        for (NSString* key in activityFields.keyEnumerator) {
            NSMutableDictionary* patActivityField = [activityFields objectForKey:key];
            //            NSNumber* isPatId = [patActivityField objectForKey:FIELDS_IS_PATIENT_ID_FIELD];
            patInfoDictionary = [patActivityField objectForKey:FIELDS_PATIENT_DATA];
            if ([patInfoDictionary class] == [NSNull class]) {
                savedResultPatInfoDto = nil;
            } else {
                savedResultPatInfoDto = [PatInfoDto create:patInfoDictionary];
            }
        }
        
        // 戻るボタンの文言変更
        UIBarButtonItem *backButton = [UIBarButtonItem new];
        backButton.title = @"修正";
        self.navigationItem.backBarButtonItem = backButton;
        
        [self performSegueWithIdentifier:@"SaveResultSegue" sender:self];
    } else {
        // エラー
        [self errorAction:errorStr];
    }
    
}

#pragma mark - 保存コネクションエラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    LOG(@"[保存]-通信エラー %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [SVProgressHUD dismiss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存エラー"
                                                        message:@"サーバーと通信できないため保存に失敗しました。ネットワークの状態を確認してから再度保存を行ってください。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"はい",
                              nil];
    [alertView show];
}

-(void) saveResult:(id)sender {
    [self performSegueWithIdentifier:@"SaveResultSegue" sender:self];
}

#pragma mark - アラート閉じた後の処理
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView.tag < 0) {
        int validateLastActionCode = alertView.tag  * -1;
        if (validateLastActionCode == VALIDATE_LAST_ACTION_ERROR) {
            LOG(@"[直前チェック]-エラー!");
        } else if (validateLastActionCode == VALIDATE_LAST_ACTION_CONFIRM) {
            
            if (buttonIndex == 0) {
                // NO
                LOG(@"[直前チェック]-確認NO");
            } else if (buttonIndex == 1) {
                // OK
                LOG(@"[直前チェック]-確認OK");
                // 保存
                [self save];
                
            }
        } else {
            
        }
    } else if (alertView.tag == ERROR_REQUIRE_AUTHOLOIZE_CODE) {
        // タイムアウトエラー
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        int actionIndex = alertView.tag;
        
        ActionField *actionField = [actionFields objectAtIndex:actionIndex];
        if (actionField.textField != nil) {
            // [actionField.textField becomeFirstResponder];
        }
    }
}


#pragma mark -
-(void) setGestureRecognizer {
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
}

#pragma mark -
-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    for (ActionField *actionField in actionFields) {
        [actionField.textField resignFirstResponder];
    }
}

#pragma mark -
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.singleTap) {
        // キーボード表示中のみ有効
        for (ActionField *actionField in actionFields) {
            if (actionField.textField.isFirstResponder) {
                return YES;
            }
        }
        return NO;
    }
    return YES;
}


#pragma mark - セルヘッダー高さ
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self isUserSection:section]) {
        return 50;
    } else if ([self isActionSection:section row:0]) {
        return 10;
    } else if ([self isLogoutSection:section]) {
        return 40;
    } else {
        return 0;
    }
}

#pragma mark - セルフッター高さ
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self isUserSection:section]) {
        return 50;
    } else {
        return 0;
    }
}




#pragma mark - セクション毎の行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return [[self getRowData:section] count];
    
    if ([self isUserSection:section]) {
        return USER_INFO_ROW_COUNT;
        
    } else if ([self isActionSection:section row:0]) {
        // アクションセクション
        if (patientSection == section) {
            // 患者ID
            if (searchPatInfoDto) {
                // 患者情報があれば表示
                return patInfoRowCount + 1;
            } else {
                // 患者情報が無ければ1行
                return 1;
            }
        } else if (scopeSection == section) {
            // スコープ
            if (searchScopeInfoDto) {
                // スコープ情報があれば表示
                return scopeInfoRowCount + 1;
            } else {
                // スコープ情報が無ければ1行
                return 1;
            }
        } else if (washerSection == section) {
            // 洗浄種別
            if (searchWasherInfoDto) {
                // 洗浄種別情報があれば表示
                return washerInfoRowCount + 1;
            } else {
                // 洗浄種別情報が無ければ1行
                return 1;
            }
            
        } else {
            // 患者ID以外は1行
            return 1;
        }
        
    } else if ([self isLogoutSection:section]) {
        return SAVE_ROW_COUNT;
    }  else {
        return 0;
    }
}


#pragma mark - ヘッダー文言
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self isUserSection:section]) {
        return @"担当者情報";
    } else if ([self isActionSection:section row:0]) {
        if (sectionActionFieldIndex == 0) {
            sectionActionFieldIndex++;
            return @"入力項目";
        }else {
            return @"";
        }
    } else if ([self isLogoutSection:section]) {
        return @"";
    }  else {
        return @"";
    }
}


#pragma mark - セクション数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return USER_INFO_ROW_COUNT + [actionFields count] + SAVE_ROW_COUNT;
}

#pragma mark - 行作成(カスタムせる)
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%d_%d", indexPath.section, indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([self isUserSection:indexPath.section]) {
        // 利用者
        if (cell == nil) {
            cell = [self getUserInfoCell: indexPath.row cellIdentifier:cellIdentifier];
        }
    } else if ([self isActionSection:indexPath.section row:indexPath.row]) {
        // アクション
        if (cell == nil) {
            cell = [self getActionFieldCell: indexPath cellIdentifier:cellIdentifier];
        }
    } else if ([self isScopeInfo:indexPath]) {
        // スコープ情報は再利用しない
        cell = [searchScopeInfoDto getScopeInfoCell: (indexPath.row - 1) cellIdentifier:cellIdentifier];
        
    } else if ([self isPatientInfo:indexPath]) {
        // 患者情報は再利用しない
        cell = [searchPatInfoDto getPatInfoCell: (indexPath.row - 1) cellIdentifier:cellIdentifier addHeadString:@""];
        
    } else if ([self isWasherInfo:indexPath]) {
        // 洗浄情報は再利用しない
        cell = [searchWasherInfoDto getWasherInfoCell:(indexPath.row - 1) cellIdentifier:cellIdentifier];
    } else if ([self isLogoutSection:indexPath.section]) {
        // ログアウト
        if (cell == nil) {
            cell = [self getLogoutCell: indexPath.row cellIdentifier:cellIdentifier];
        }
    }
    
    return cell;
    
    
}

#pragma mark - 利用者セル作成
-(UITableViewCell*) getUserInfoCell: (int)row cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell *cell;
    User *user = [User getInstance];
    if (row == ROW_USER_ID) {
        // 利用者ID
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text = @"担当者ID";
        cell.detailTextLabel.text = user.userId;
        
        // font
        cell.textLabel.font = [Constants getFont];
        cell.detailTextLabel.font = [Constants getFont];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
    } else if (row == ROW_USER_NAME) {
        // 氏名
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text = @"氏名";
        cell.detailTextLabel.text = user.userName;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        // font
        cell.textLabel.font = [Constants getFont];
        cell.detailTextLabel.font = [Constants getFont];
        
    } else if (row == ROW_USER_KA) {
        // 診療科
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text = @"診療科・部署";
        cell.detailTextLabel.text = user.kaName;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        // font
        cell.textLabel.font = [Constants getFont];
        cell.detailTextLabel.font = [Constants getFont];
    }
    
    return cell;
}

#pragma mark - アクションフィールドセル作成
-(UITableViewCell*) getActionFieldCell: (NSIndexPath*)indexPath cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell *cell;
    
    ActionField* actionField = [actionFields objectAtIndex:actionFieldIndex];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.textLabel.text = actionField.name;
    cell.tag = actionField.fieldId;
    cell.textLabel.font = [Constants getFont];
    
    if([actionField.type isEqualToString: FIELDS_TYPE_BARCODE]) {
        // バーコード
        float camera_x = [Constants getiPhoneValue:275 iPadValue:500];
        
        CGRect textFieldFrame = [self getTextFieldFrame:actionField.name
                                               textFont:cell.textLabel.font
                                               textSize:cell.textLabel.frame.size
                                             limitWidth:camera_x
                                             cellHieght:cell.frame.size.height];
        UITextField *textFiled = [[UITextField alloc] initWithFrame:textFieldFrame];
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textFiled.textAlignment = NSTextAlignmentRight;
        if (actionField.require) {
            textFiled.placeholder = @"必須";
        } else {
            textFiled.placeholder = actionField.name;
        }
        // タグにはインデックスを設定
        textFiled.tag = actionFieldIndex;
        textFiled.delegate = self;
        textFiled.font = [Constants getFont];
        actionField.textField = textFiled;
        
        
        
        
        [cell addSubview:textFiled];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        float camera_h = [Constants getiPhoneValue:40 iPadCoeffcient:IPAD_COEFFCIENT];
        button.frame = CGRectMake([Constants getiPhoneValue:camera_x iPadValue:camera_x + 50], ([Constants getiPhoneValue:actionTableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT]  - camera_h ) / 2, camera_h, camera_h);
        
        [button setBackgroundImage:[UIImage imageNamed:@"camera_3.png"] forState:UIControlStateNormal];
        // タグにはインデックスを設定
        button.tag = actionFieldIndex;
        [button addTarget:self action:@selector(barcordScan:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        
    } else if([actionField.type isEqualToString: FIELDS_TYPE_INPUT]) {
        // 手入力
        
        CGRect textFieldFrame = [self getTextFieldFrame:actionField.name textFont:cell.textLabel.font textSize:cell.textLabel.frame.size limitWidth:315 cellHieght:cell.frame.size.height];
        UITextField *textFiled = [[UITextField alloc] initWithFrame:textFieldFrame];
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFiled.textAlignment = NSTextAlignmentRight;
        if (actionField.require) {
            textFiled.placeholder = @"必須";
        } else {
            textFiled.placeholder = actionField.name;
        }
        //        textFiled.text = @"123456789A";
        // タグにはインデックスを設定
        textFiled.tag = actionFieldIndex;
        textFiled.delegate = self;
        textFiled.returnKeyType = UIReturnKeyNext;
        textFiled.font = [Constants getFont];
        actionField.textField = textFiled;
        
        [cell addSubview:textFiled];
        
    } else if([actionField.type isEqualToString: FIELDS_TYPE_BOOLEAN]) {
        //        float w = 150;
        //        float h = 30;
        //        float x = 250;
        //        float y = (cell.frame.size.height - h ) / 2;
        
        float w = [Constants getiPhoneValue:150 iPadCoeffcient:IPAD_COEFFCIENT] ;
        float h = [Constants getiPhoneValue:30 iPadCoeffcient:IPAD_COEFFCIENT];
        float x = [Constants getiPhoneValue:250 iPadValue:400];
        float y = ([Constants getiPhoneValue:actionTableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT] - h ) / 2;
        
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(x, y, w, h)];
        actionField.actionSwitch = sw;
        sw.tag = actionFieldIndex;
        [cell addSubview:sw];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    actionFieldIndex++;
    
    // セクション
    if (actionField.isScope) {
        // スコープセクション
        scopeSection = indexPath.section;
    } else if (actionField.isWasherId) {
        // 洗浄種別セクション
        washerSection = indexPath.section;
    }
    
    // フィールド判断
    if (actionField.isPatientId) {
        // 患者IDのセクションを保持
        patientSection = indexPath.section;
        patIdFieldId = [NSString stringWithFormat:@"%d", actionField.fieldId ];
        patIdCell = cell;
        actionField.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else  if ([actionFields count] == actionFieldIndex) {
        actionField.textField.returnKeyType = UIReturnKeyNext;
    } else {
        actionField.textField.returnKeyType = UIReturnKeyNext;
    }
    
    
    // 必須
    if (actionField.require) {
        // 必須があるので保存セルは無効状態へ
        saveEnable = NO;
        // 必須
        [self requireTextDisable:@(actionField.textField.tag)];
        
        // 必須テキストフィールドの監視
        [actionField.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        
        [actionField.textField addTarget:self action:@selector(requireTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    
    
    //
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

-(void) requireTextFieldChanged : (UITextField*) textField {
    
    
    NSString *newTextString = textField.text;
    if ( 0 <  [newTextString length]) {
        [self requireTextEnable:@(textField.tag)];
    } else {
        [self requireTextDisable:@(textField.tag)];
    }
    
    // 有効無効
    [self doSaveButtonEnable];
    
    
}


-(void) requireTextEnable : (NSNumber*) tag {
    [requireTextDictionary setObject:@1 forKey:tag];
}

-(void) requireTextDisable : (NSNumber*) tag {
    [requireTextDictionary setObject:@0 forKey:tag];
}

- (void) doSaveButtonEnable {
    for (NSString* key in requireTextDictionary) {
        NSNumber* num = requireTextDictionary[key];
        if ( [num intValue] < 1) {
            saveEnable = NO;
            [self saveCellDisabled];
            return;
        }
    }
    
    saveEnable = YES;
    [self saveCellEnabled];
}

#pragma mark - 必須テキストフィールドの監視
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"text"]) {
        UITextField* textField = (UITextField*)object;
        NSString *newTextString = textField.text;
        if ( 0 <  [newTextString length]) {
            [self requireTextEnable:@(textField.tag)];
        } else {
            [self requireTextDisable:@(textField.tag)];
        }
    }
}

-(CGRect) getTextFieldFrame :  (NSString*) text textFont:(UIFont*)textFont textSize:(CGSize)textSize limitWidth:(CGFloat) limitWidth cellHieght : (CGFloat) cellHieght{
    
    float text_x = [Constants getiPhoneValue:20 iPadCoeffcient:IPAD_COEFFCIENT] ;
    float input_h = [Constants getiPhoneValue:30 iPadCoeffcient:IPAD_COEFFCIENT];
    
    // テキストフィールドのサイズ計算
    float y = ([Constants getiPhoneValue:cellHieght iPadCoeffcient:IPAD_COEFFCIENT] - input_h ) / 2;
    float text_w = [self getTextSize:text textFont:textFont textSize:textSize];
    float input_w = limitWidth - ( (text_x + text_w) + (5 * 2) );
    float input_x = (text_x + text_w) + 5;
    CGRect textFieldFrame = CGRectMake(input_x, y, input_w, input_h);
    
    
    return textFieldFrame;
}


-(CGFloat) getTextSize : (NSString*) text textFont:(UIFont*)textFont textSize:(CGSize)textSize {
    textSize = [text
                sizeWithFont:textFont
                constrainedToSize:textSize
                lineBreakMode:NSLineBreakByWordWrapping];
    return textSize.width;
}

#pragma mark - テキストフィールド、エンターキー押下
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        int nextIndex = (textField.tag + 1);
        if (nextIndex < [actionFields count]) {
            ActionField* actionField = [actionFields objectAtIndex: nextIndex];
            [actionField.textField becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
            
        }
        
    }
    return YES;
}

#pragma mark - テキスト最大文字制限
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    ActionField *actionField = [actionFields objectAtIndex:textField.tag];
    
    if ([actionField.type isEqualToString: FIELDS_TYPE_BARCODE]) {
        // バーコードは入力された値そのままを設定する
        if (0 < actionField.maxLength) {
            if ([text length] <= [actionField.maxLength intValue]) {
                textField.text = text;
            }
            return NO;
        } else {
            textField.text = text;
            return NO;
        }
    } else {
        // キーボードの種類に応じた値を返す
        if (0 < actionField.maxLength) {
            return [text length] <= [actionField.maxLength intValue];
        } else {
            return YES;
        }
    }
}

#pragma mark - 保存セル作成
-(UITableViewCell*) getLogoutCell: (int)row cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.text = @"保存";
    cell.textLabel.font = [Constants getFont];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    saveCell = cell;
    
    // 保存セル状態設定
    [self saveCellDisabled];
    
    return cell;
}

#pragma mark - 保存セル 無効
- (void) saveCellDisabled {
    
    saveCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [UIView animateWithDuration:0.5 animations:^(void)
     {
         saveCell.textLabel.textColor = [UIColor lightGrayColor];
         saveCell.backgroundColor = [UIColor silverColor];
     }];
    
}

#pragma mark - 保存セル　有効
- (void) saveCellEnabled {
    
    
    saveCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    [UIView animateWithDuration:0.5 animations:^(void)
     {
         saveCell.textLabel.textColor = [UIColor colorWithHex:@"#7fbfff"];
         saveCell.backgroundColor = [UIColor whiteColor];
     }];
}

CGPoint absPoint(UIView* view)
{
    CGPoint ret = CGPointMake(view.frame.origin.x, view.frame.origin.y);
    if ([view superview] != nil) {
        CGPoint addPoint = absPoint([view superview]);
        ret = CGPointMake(ret.x + addPoint.x, ret.y + addPoint.y);
    }
    return ret;
}

#pragma mark - 患者情報フィールド判断
- (BOOL) isPatientInfo : (NSIndexPath*) indexPath {
    if (indexPath.row == 0) {
        return NO;
    } else {
        
        if (indexPath.section == patientSection) {
            return YES;
        } else {
            return NO;
        }
        
    }
}

#pragma mark - スコープ情報フィールド判断
- (BOOL) isScopeInfo : (NSIndexPath*) indexPath {
    if (indexPath.row == 0) {
        return NO;
    } else {
        
        if (indexPath.section == scopeSection) {
            return YES;
        } else {
            return NO;
        }
        
    }
}

#pragma mark - 洗浄情報フィールド判断
- (BOOL) isWasherInfo : (NSIndexPath*) indexPath {
    if (indexPath.row == 0) {
        return NO;
    } else {
        
        if (indexPath.section == washerSection) {
            return YES;
        } else {
            return NO;
        }
        
    }
}

#pragma mark - アクションフィールド判断
-(BOOL)isActionSection: (int)section row:(int)row {
    if (0 < row) {
        return NO;
    } else {
        int count = [actionFields count];
        if (0 < section && section < count + 1) {
            return YES;
        } else {
            return NO;
        }
    }
}

#pragma mark - 保存判断
-(BOOL)isLogoutSection : (int)section {
    int count = [actionFields count];
    if (section == count + 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 利用者セル判断
-(BOOL)isUserSection : (int)section {
    return section == 0 ? YES:NO;
}

#pragma mark - バーコード読取
-(void)barcordScan : (UIButton*)button {
    
    ActionField *actionField = [actionFields objectAtIndex:button.tag];
    targetTextField = actionField.textField;
    
    
    for (ActionField *_actionField in actionFields) {
        [_actionField.textField resignFirstResponder];
    }
    
    
    [self performSelector:@selector(barcordScanDelay:) withObject:actionField.name afterDelay:0.1];
    
}

#pragma mark - バーコード読取
-(void)barcordScanDelay : (NSString*)scanTitle {
    
    
    ZBarViewControllerSingleton* singleton = [ZBarViewControllerSingleton sharedManager];
    reader = [singleton getZBarReaderViewController];
    //    BarcodeViewController *reader = [BarcodeViewController new];
    
    NSString *title = scanTitle;
    
    // overlay
    reader.showsCameraControls = NO;
    reader.showsZBarControls = NO;
    reader.title = title;
    BarcodeOverlay *barcodeOverlay = [BarcodeOverlay myView];
    barcodeOverlay.zBarReaderViewController = reader;
    barcodeOverlay.title = title;
    reader.cameraOverlayView = barcodeOverlay;
    
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    /*
     * 読み込むバーコードの設定
     *  レスポンスのためにも利用するもののみ有効にしたほうがいい。
     *  とりあえず全て有効にしている。
     */
    //    ZBarImageScanner *scanner = reader.scanner;
    //
    //    // 全てを無効
    //    [scanner setSymbology: 0
    //                   config: ZBAR_CFG_ENABLE
    //                       to: 0];
    //    // NW-7を有効
    //    [scanner setSymbology: ZBAR_CODABAR
    //                   config: ZBAR_CFG_ENABLE
    //                       to: 1];
    
    //
    UIBarButtonItem *backButton = [UIBarButtonItem new];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;
    
    //
    [self presentViewController:reader animated:YES completion:^(){
        [barcodeOverlay setFocus];
        [barcodeOverlay setFocusTimer];
    }];
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (YES);
}

#pragma mark - バーコード読取完了
- (void) imagePickerController: (UIImagePickerController*) _reader  didFinishPickingMediaWithInfo: (NSDictionary*) info {
    
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for(symbol in results) {
        break;
    }
    
    // タイマーのストップ
    BarcodeOverlay *barcodeOverlay = (BarcodeOverlay*)reader.cameraOverlayView;
    [barcodeOverlay stopFocusTimer];
    reader.cameraOverlayView = nil;
    
    //効果音再生
    AudioServicesPlaySystemSound ([Constants getScanSoundID]);
    
    // 読取成功
    if (symbol.type == ZBAR_CODABAR) {
        // codabar(nw-7)
        targetTextField.text = [BarCodeUtil extractCodabar:symbol.data];
    } else {
        targetTextField.text = symbol.data;
    }
    
    // テキスト判断
    ActionField *actionField = [actionFields objectAtIndex:targetTextField.tag];
    if (actionField.isPatientId) {
        // 患者検索（非同期）
        [self searchPatientInfo:actionField.textField];
    } else if (actionField.isScope) {
        // スコープ検索（非同期）
        [self searchScopeInfo:actionField.textField];
    } else if (actionField.isWasherId) {
        // 洗浄種別
        [self searchWasherInfo:actionField.textField];
    }
    
    // 0.1秒後にスキャナを閉じる
    [self performSelector:@selector(dismissReader) withObject:nil afterDelay:0.1];
}

-(void) searchWasherInfo : (UITextField*) textField {
    
    // 洗浄種別情報リセット
    washerInfoRowCount = 0;
    if (searchWasherInfoDto != nil) {
        // 洗浄種別情報行の削除
        [actionTableView deleteRowsAtIndexPaths:washerInfondexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    // 洗浄種別情報の初期化
    searchWasherInfoDto = nil;
    
    // 文字数チェック
    if (0 < [textField.text length]) {
        
        [SVProgressHUD showWithStatus:@"洗浄種別情報照会中"];
        // 洗浄種別検索
        SearchWasherInfo* searchWasherInfo = [SearchWasherInfo new];
        searchWasherInfo.delegate = self;
        [searchWasherInfo searchWahser:textField.text tag:textField.tag];
    }
}

#pragma mark - 洗浄種別検索結果
-(void) searchWasherResult:(WasherInfoDto *)washerInfoDto errorMessage:(NSString *)errorMessage {
    
    
    if (washerInfoDto.isEnable) {
        
        [SVProgressHUD showSuccessWithStatus:@"洗浄種別照会完了"];
        LOG(@"洗浄種別検索 成功!! %@", washerInfoDto);
        
        if (errorMessage) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"洗浄種別確認" message:errorMessage delegate:nil cancelButtonTitle:@"はい" otherButtonTitles:nil];
            [alert show];
            
        }
        
        searchWasherInfoDto = washerInfoDto;
        //
        washerInfoRowCount = [washerInfoDto rowCount];
        
        // テーブルに挿入する
        washerInfondexPaths = [NSMutableArray array];
        for (int i = 1 ; i <= washerInfoRowCount;i++) {
            [washerInfondexPaths addObject:[NSIndexPath indexPathForItem:i inSection:washerSection]];
        }
        
        [actionTableView insertRowsAtIndexPaths:washerInfondexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // 有効
        [self requireTextEnable:@(washerInfoDto.tag)];
        
        
    } else {
        if (0 < [errorMessage length]) {
            LOG(@"洗浄種別検索エラー");
            [SVProgressHUD dismiss];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"洗浄種別検索" message:errorMessage delegate:nil cancelButtonTitle:@"はい" otherButtonTitles:nil];
            [alert show];
            searchWasherInfoDto = nil;
            
        }
        
        // 無効
        [self requireTextDisable:@(washerInfoDto.tag)];
    }
    
    [self doSaveButtonEnable];
}


-(void) searchScopeInfo : (UITextField*) textField {
    // スコープ情報リセット
    scopeInfoRowCount = 0;
    if (searchScopeInfoDto != nil) {
        // スコープ情報行の削除
        [actionTableView deleteRowsAtIndexPaths:scopeInfondexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    // スコープ情報の初期化
    searchScopeInfoDto = nil;
    
    if (0 < [textField.text length]) {
        
        [SVProgressHUD showWithStatus:@"スコープ情報照会中"];
        // スコープ検索
        SearchScopeInfo* searchScopeInfo = [SearchScopeInfo new];
        searchScopeInfo.delegate = self;
        [searchScopeInfo searchScopeId:textField.text actionId:actionId tag:textField.tag];
    }
    
}

-(void) searchScopeInfoResult:(ScopeInfoDto *)scopeInfoDto errorMessage:(NSString *)errorMessage {
    
    
    if (scopeInfoDto.isEnable) {
        
        [SVProgressHUD showSuccessWithStatus:@"スコープ照会完了"];
        LOG(@"スコープ検索 成功!! %@", scopeInfoDto);
        
        if (errorMessage) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"スコープ検索" message:errorMessage delegate:nil cancelButtonTitle:@"はい" otherButtonTitles:nil];
            [alert show];
            
        }
        
        searchScopeInfoDto = scopeInfoDto;
        //
        scopeInfoRowCount = [scopeInfoDto rowCount];
        
        // テーブルに挿入する
        scopeInfondexPaths = [NSMutableArray array];
        for (int i = 1 ; i <= scopeInfoRowCount;i++) {
            [scopeInfondexPaths addObject:[NSIndexPath indexPathForItem:i inSection:scopeSection]];
        }
        
        [actionTableView insertRowsAtIndexPaths:scopeInfondexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // 有効
        [self requireTextEnable:@(scopeInfoDto.tag)];
        
    } else {
        if (0 < [errorMessage length]) {
            LOG(@"スコープ検索エラー");
            [SVProgressHUD dismiss];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"スコープ検索" message:errorMessage delegate:nil cancelButtonTitle:@"はい" otherButtonTitles:nil];
            [alert show];
            searchScopeInfoDto = nil;
            
        }
        
        // 無効
        [self requireTextDisable:@(scopeInfoDto.tag)];
    }
    
    [self doSaveButtonEnable];
}

#pragma mark - 患者情報
-(void) searchPatientInfo : (UITextField*) textField {
    
    // 患者情報行数のリセット
    patInfoRowCount = 0;
    if (searchPatInfoDto != nil) {
        // 患者情報行の削除
        [actionTableView deleteRowsAtIndexPaths:patInfondexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    // 患者情報の初期化
    searchPatInfoDto = nil;
    
    if (0 < [textField.text length]) {
        [SVProgressHUD showWithStatus:@"患者照会中"];
        // 患者検索
        SearchPatInfo* searchPatInfo = [SearchPatInfo new];
        searchPatInfo.delegate = self;
        [searchPatInfo searchPatId:textField.text tag:textField.tag];
    }
}

// 患者IDを正規表現で評価
-(BOOL) isInputCheck : (UITextField*) textField actionField : (ActionField*) actionField {
    
    NSString *str = textField.text;
    NSString *pattern = actionField.regexp;
    NSString* top = [pattern substringWithRange:NSMakeRange(0, 1)];
    if ([top isEqualToString:@"/"]) {
        pattern = [pattern substringWithRange:NSMakeRange(1, [pattern length] - 1)];
    }
    
    NSString* last = [pattern substringWithRange:NSMakeRange((pattern.length - 1), 1)];
    if ([last isEqualToString:@"/"] ) {
        pattern = [pattern substringWithRange:NSMakeRange(0, (pattern.length - 2))];
    }
    
    NSError* err = nil;
    NSRegularExpression* regex = nil;
    // 検索する文字列
    NSString* string = str;
    
    // 正規表現オブジェクト作成
    regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:&err];
    // 比較
    NSTextCheckingResult *match = [regex firstMatchInString:string
                                                    options:0
                                                      range:NSMakeRange(0, string.length)];
    
    if (!match) {
        return NO;
    } else {
        return YES;
    }
    
}

// メッセージを表示 自動的に消える
-(void) addSearchPatInfoWarning : (NSString*) message {
    
    CGRect rect = patIdCell.frame;
    //                    CGPoint offset =  actionTableView.contentOffset;
    //                    rect.origin.x = rect.origin.x - offset.x;
    //                    rect.origin.y = rect.origin.y - offset.y;
    searchPatInfoWarningLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, rect.origin.y + rect.size.height + 3, 280, 44)];
    searchPatInfoWarningLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    CALayer *layer = [searchPatInfoWarningLabel layer];
    [layer setCornerRadius:6];
    
    UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260, 50)];
    //                    text.adjustsFontSizeToFitWidth = YES;
    text.text = message;
    text.textColor = [UIColor whiteColor];
    text.numberOfLines= 0;
    text.font = [UIFont boldSystemFontOfSize:15];
    [text sizeToFit];
    [searchPatInfoWarningLabel addSubview:text];
    [actionTableView addSubview:searchPatInfoWarningLabel];
    
    CGRect tmp = searchPatInfoWarningLabel.frame;
    tmp.size.height = text.frame.size.height + 10;
    searchPatInfoWarningLabel.frame = tmp;
    
    /* 拡大・縮小 */
    // 拡大縮小を設定
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // アニメーションのオプションを設定
    animation.duration = 0.2; // アニメーション速度
    animation.repeatCount = 1; // 繰り返し回数
    animation.autoreverses = NO; // アニメーション終了時に逆アニメーション
    
    // 拡大・縮小倍率を設定
    animation.fromValue = [NSNumber numberWithFloat:1.2]; // 開始時の倍率
    animation.toValue = [NSNumber numberWithFloat:1.0]; // 終了時の倍率
    
    // アニメーションを追加
    [searchPatInfoWarningLabel.layer addAnimation:animation forKey:@"scale-layer"];
    
    // アニメーション
    [UIView animateWithDuration:1.5f // アニメーション速度2.5秒
                          delay:2.0f // 1秒後にアニメーション
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // 画像を2倍に拡大
                         searchPatInfoWarningLabel.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         // アニメーション終了時
                         [searchPatInfoWarningLabel removeFromSuperview];
                         [text removeFromSuperview];
                     }];
}

/*
 * 患者検索処理終了後に呼び出される
 * 成功 : patInfoDtoに患者情報
 * 失敗 : errorMessageにエラー内容
 */
-(void) searchPatInfoResult:(PatInfoDto *)patInfoDto errorMessage:(NSString *)errorMessage {
    
    
    
    
    if (patInfoDto.isEnable) {
        
        
        [SVProgressHUD showSuccessWithStatus:@"患者照会完了"];
        LOG(@"患者検索 成功!! %@", patInfoDto);
        searchPatInfoDto = patInfoDto;
        // 患者氏名とカナの２つ表示する
        patInfoRowCount = DISP_PAT_INFO_ROW_COUNT;
        
        // テーブルに挿入する
        patInfondexPaths = [NSMutableArray array];
        for (int i = 1 ; i <= patInfoRowCount;i++) {
            [patInfondexPaths addObject:[NSIndexPath indexPathForItem:i inSection:patientSection]];
        }
        
        [actionTableView insertRowsAtIndexPaths:patInfondexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        // 有効
        [self requireTextEnable:@(patInfoDto.tag)];
        
    } else {
        LOG(@"患者検索エラー");
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"患者検索エラー" message:errorMessage delegate:nil cancelButtonTitle:@"はい" otherButtonTitles:nil];
        [alert show];
        searchPatInfoDto = nil;
        
        // 無効
        [self requireTextDisable:@(patInfoDto.tag)];
        
        
    }
    
    [self doSaveButtonEnable];
}

#pragma mark -
// スキャナを閉じる
-(void) dismissReader {
    [reader dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Segue呼び出し
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *view = [segue destinationViewController];
    
    if ([view class] == [SaveResultViewController class]) {
        // 保存完了画面へ
        SaveResultViewController *savc = (SaveResultViewController*) view;
        savc.actionId = actionId;
        savc.activityId = self.activityId;
        savc.actionName = actionName;
        savc.savedMessage = savedMessage;
        savc.elapsedMessage = elapsedMessage;
        savc.actionFields = actionFields;
        savc.patInfoDto = savedResultPatInfoDto;
        savc.invalidLastAction = invalidLastAction;
        // 登録時間を設定
        savc.createdAt = createdAt;
        savc.actionCompletedAt = actionCompletedAt;
    }
    
}


#pragma mark - カスタムアラートを開く
- (void) showCustomAlerView: (NSString*) title
                    message:(NSString*)message
               messageColor:(UIColor*)messageColor
              okButtonTitle:(NSString*)okButtonTitle
         cancellButtonTitle:(NSString*)cancellButtonTitle
                        tag:(NSInteger)tag {
    
    customAlertViewController = [CustomAlertViewController new];
    customAlertViewController.delegate = self;
    customAlertViewController.message = message;
    customAlertViewController.alertTitle = title;
    customAlertViewController.messageColor = messageColor;
    customAlertViewController.okButtonTitle = okButtonTitle;
    customAlertViewController.cancellButtonTitle = cancellButtonTitle;
    customAlertViewController.tag = tag;
    customAlertViewController.font = [UIFont systemFontOfSize:19];
    
    UIView *view = customAlertViewController.view;
    UIWindow* mainWindow = (((MainAppDelegate*) [UIApplication sharedApplication].delegate).window);
    backLabel = [[UILabel alloc] initWithFrame:mainWindow.frame];
    backLabel.center = self.view.center;
    backLabel.backgroundColor = [UIColor blackColor];
    backLabel.alpha = 0.1;
    [mainWindow addSubview:backLabel];
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn| // EaseInカーブ
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         backLabel.alpha = 0.4;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    view.center = self.view.center;
    [mainWindow addSubview:view];
}


#pragma mark - カスタムアラートを閉じた時に呼ばれる
- (void)closeAlertView:(CustomAlertViewController *)controller
{
    // PickerViewをアニメーションを使ってゆっくり非表示にする
    UIView *pickerView = controller.view;
    
    [UIView beginAnimations:nil context:(void *)pickerView];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    pickerView.alpha = 0;
    [backLabel setAlpha:0.0];
    [UIView commitAnimations];
}

#pragma mark - カスタムアラートを閉じ、アニメーションが終了した時に呼ばれる
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // PickerViewをサブビューから削除
    UIView *pickerView = (__bridge UIView *)context;
    [pickerView removeFromSuperview];
    [backLabel removeFromSuperview];
}

// セルの高さ
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isUserSection:indexPath.section]) {
        return [Constants getiPhoneValue:tableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT];
        
    } else if ([self isScopeInfo:indexPath]) {
        
        return [Constants getiPhoneValue:30 iPadCoeffcient:IPAD_COEFFCIENT];
    } else if ([self isWasherInfo:indexPath]) {
        return [Constants getiPhoneValue:30 iPadCoeffcient:IPAD_COEFFCIENT];
    } else if ([self isPatientInfo:indexPath]) {
        return [Constants getiPhoneValue:30 iPadCoeffcient:IPAD_COEFFCIENT];
    } else {
        return [Constants getiPhoneValue:tableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT];
    }
}

//- (CGFloat) getCellHeight : (CGFloat) height {
//    if([Constants isDeviceiPad]) {
//        return  height * 1.5;
//    } else {
//        return height;
//    }
//}

#pragma mark - 行選択イベント
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isUserSection:indexPath.section]) {
        
    } else if ([self isActionSection:indexPath.section row:indexPath.row]) {
        
    } else if ([self isLogoutSection:indexPath.section]) {
        
        if (saveEnable) {
            [self clickSave];
        }
    }  else {
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - アラートビュー
-(void) touchAlertViewButton : (TOUCH_BUTTON_TYPE) buttonType tag:(NSInteger)tag {
    
    
    int validateLastActionCode = tag;
    if (validateLastActionCode == VALIDATE_LAST_ACTION_ERROR) {
        LOG(@"[直前チェック]-エラー!");
    } else if (validateLastActionCode == VALIDATE_LAST_ACTION_CONFIRM) {
        
        switch (buttonType) {
            case CANCELL:
                LOG(@"[直前チェック]-確認NO");
                break;
            case OK:
                LOG(@"[直前チェック]-確認OK");
                // 保存
                [self save];
                break;
            default:
                break;
        }
    } else {
        LOG(@"確認ダイアログにて存在しないコードで表示されました。");
    }
}


#pragma mark - キーボードスクロール
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    ActionField *actionField = actionFields[textField.tag];
    if (actionField.isPatientId) {
        [self searchPatientInfo:textField];
    } else if (actionField.isScope) {
        [self searchScopeInfo:textField];
    } else if (actionField.isWasherId) {
        [self searchWasherInfo:textField];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
//// debug
//-(void)viewDidAppear:(BOOL)animated {
//
//    if (0 < [actionFields count]) {
//        ActionField *scopeId =  actionFields[0];
//        scopeId.textField.text = @"214-1984";
//    }
//
//    if (1 < [actionFields count]) {
//        ActionField *patiId =  actionFields[1];
//        patiId.textField.text = @"20085185";
//    }
//}




@end
