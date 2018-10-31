//
//  LoginViewController.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/12.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "ZBarViewControllerSingleton.h"
#import "Constants.h"
#import "SBJson.h"
#import "User.h"
#import "UIColor+Hex.h"
#import "BarCodeUtil.h"
#import <AudioToolbox/AudioServices.h>
#import "NSMutableURLRequest+UserAgent.h"

#define SECTION_USER 0
#define SECTION_PASSWORD 1
#define SECTION_LOGIN 2
#define SECTION_EXIT 3

#define ROW_ID @"ROW_ID"
#define ROW_PSSWORD @"ROW_PSSWORD"

#define ROW_LOGIN @"ROW_LOGIN"
#define ROW_EXIT @"ROW_EXIT"

#define ALERT_USER_ID 0
#define ALERT_PASSWORD 1
#define ALERT_EXIT 2

@interface LoginViewController ()

@end

@implementation LoginViewController {
    BOOL isResponce;
    ZBarReaderViewController* reader;
    
    // 受信データ
    NSMutableData* receivedData;
}
@synthesize loginTableview, rowData, userIdTexField, passwordTextField, loginButtonData, headers;

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
	// Do any additional setup after loading the view.
    
    loginTableview.dataSource = self;
    loginTableview.delegate = self;
    
    userIdTexField.text = @"";
    passwordTextField.text = @"";
    
    if ([Constants isDeviceiPad]) {
        // iPadだけシングルタップジェスチャーを追加。
        [self setGestureRecognizer];
    }
    
    rowData = @[@[ROW_ID],
                @[ROW_PSSWORD],
                @[ROW_LOGIN],
                @[ROW_EXIT],
                ];
    
    
    headers = @[@"担当者IDとパスワードを入力してください", @"", @"", @""];
    
}


#pragma mark - ログインボタン押下
-(void) clickLogin {
    
    BOOL isDebug = NO;
    if (isDebug == NO) {
        
        // スコープ
        if ([userIdTexField.text isEqualToString:@""]) {
            UIAlertView *alert =[[UIAlertView alloc]
                                 initWithTitle:@"入力チェック"
                                 message:@"担当者IDを入力してください"
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"はい", nil
                                 ];
            
            alert.tag = ALERT_USER_ID;
            
            [alert show];
            //            NSArray* aa = [alert subviews];
            //            UILabel* me = ((UILabel *)[aa objectAtIndex:0]);//
            //            me.textAlignment = NSTextAlignmentLeft;
            return ;
        }
        
        // パスワード
        if ([passwordTextField.text isEqualToString:@""]) {
            UIAlertView *alert =[[UIAlertView alloc]
                                 initWithTitle:@"入力チェック"
                                 message:@"パスワードを入力してください"
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"はい", nil
                                 ];
            
            alert.tag = ALERT_PASSWORD;
            [alert show];
            return ;
        }
        
    }
    // フォーカスを外す
    [userIdTexField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    
    [SVProgressHUD showWithStatus:@"ログイン中..." maskType:SVProgressHUDMaskTypeGradient];
    // ログイン
    [self login: userIdTexField.text password:passwordTextField.text];
    
}

#pragma mark - ログイン処理（非同期）
-(void) login: (NSString*)_userId password:(NSString*)password {
    
    // サーバーへリクエストを送信
    NSString *urlStr = [API_URL stringByAppendingString: API_LOGIN_URL];
    NSURL *url                   = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    // 担当者ID, パスワード
    NSString *post               = [NSString stringWithFormat:@"%@=%@&%@=%@", PRM_CIS_ID, _userId, PRM_CIS_PW, password];
    NSData *postData             = [post dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:postData];
    
    // 初期化
    receivedData = [[NSMutableData alloc] init];
    
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        LOG(@"[ログイン]-開始...");
        LOG(@"[ログイン]-[POST] url:%@ prm:%@", [url path], post);
    }
    
}


#pragma mark - レスポンス受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        LOG(@"[ログイン]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        [SVProgressHUD dismiss];
        NSString* message = [NSString stringWithFormat:@"ログインに失敗しました。\nstatusCode:%d (%@)",
                             [httpResponse statusCode],
                             [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ログインエラー"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
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
        LOG(@"[ログイン]-データ受信エラー データ無し");
        [SVProgressHUD dismiss];
        return;
    }
    
    // JSONへ変換
    NSString *json_string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *statuses = [json_string JSONValue];
    LOG(@"[ログイン]-受信データ %@", statuses);
    
    NSString* error = [statuses objectForKey:@"error"];
    
    if (error == nil) {
        
        
        if ([statuses objectForKey:PRM_AUTH_KEY ] != nil ) {
            // ログイン成功
            User *user = [User getInstance];
            
            //            [user login:(NSDictionary*)statuses];
            NSDictionary* staffInfo = [statuses objectForKey:PRM_STAFFM];
            [user login:[statuses objectForKey:PRM_CIS_ID]
               userName:[statuses objectForKey:PRM_CIS_NAME]
                authKey:[statuses objectForKey:PRM_AUTH_KEY]
             staffInfo : staffInfo
             ];
            
            // クリア
            userIdTexField.text = @"";
            passwordTextField.text = @"";
            
            
            
            [self performSegueWithIdentifier:@"MainMenuSegue" sender:self];
            
        } else {
            // 失敗
            [SVProgressHUD dismiss];
            UIAlertView *alert =[[UIAlertView alloc]
                                 initWithTitle:@"ログインエラー"
                                 message:@"ログインに失敗しました。再度入力してください。"
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"はい", nil
                                 ];
            [alert show];
        }
    } else {
        // error
        // 失敗
        [SVProgressHUD dismiss];
        NSString* errorMsg = @"";
        if ([error isEqualToString:LOGIN_ERROR_UNKOWN_CIS_USER]) {
            errorMsg = @"";
        }
        UIAlertView *alert =[[UIAlertView alloc]
                             initWithTitle:@"ログインエラー"
                             message:[NSString stringWithFormat:@"ログインに失敗しました。\n%@", errorMsg]
                             delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:@"はい", nil
                             ];
        [alert show];
    }
    
    receivedData = nil;
    
    
}

#pragma mark - 通信エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    LOG(@"[ログイン]-通信エラー - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [SVProgressHUD dismiss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ログインエラー"
                                                        message:@"サーバーと通信できないためログインに失敗しました。ネットワークの状態を確認してから再度ログインを行ってください。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"はい",
                              nil];
    [alertView show];
}


#pragma mark - アラート閉じた後の処理
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
            
        case ALERT_USER_ID:
            [userIdTexField becomeFirstResponder];
            break;
        case ALERT_PASSWORD:
            [passwordTextField becomeFirstResponder];
            break;
        case ALERT_EXIT:
            if ( buttonIndex == 1) {
                exit(0);
            }
        default:
            
            break;
            
    }
    
}


#pragma mark - テーブル行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self getRowData:section] count];
    
}


#pragma mark - ヘッダー
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [headers objectAtIndex:section];
}


#pragma mark - セクション数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [headers count];
}


#pragma mark - 行選択イベント
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *rowItem = [[self getRowData:indexPath.section] objectAtIndex:indexPath.row];
    if ([rowItem  isEqualToString:ROW_LOGIN]) {
        //　ログイン
        [self clickLogin];
        
    } else  if ([rowItem  isEqualToString:ROW_ID]) {
        // 利用者ID
        [userIdTexField becomeFirstResponder];
        
    } else  if ([rowItem  isEqualToString:ROW_PSSWORD]) {
        // パスワード
        [passwordTextField becomeFirstResponder];
    } else if ([rowItem isEqualToString:ROW_EXIT]) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"終了確認" message:@"アプリケーションを終了しますか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        alert.tag = ALERT_EXIT;
        [alert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除
}



#pragma mark - 行作成
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%d_%d", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSString *rowItem = [[self getRowData:indexPath.section] objectAtIndex:indexPath.row];
        if ([rowItem  isEqualToString:ROW_ID]) {
            // ID
            
            float w = [Constants getiPhoneValue:160 iPadCoeffcient:IPAD_COEFFCIENT] ;
            float h = [Constants getiPhoneValue:30 iPadCoeffcient:IPAD_COEFFCIENT];
            float x = [Constants getiPhoneValue:110 iPadValue:300];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            // ラベル
            cell.textLabel.text = @"担当者ID";
            cell.textLabel.font = [Constants getFont];
            float y = ([Constants getiPhoneValue:tableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT] - h ) / 2;
            
            // テキスト
            UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
            textFiled.textAlignment = NSTextAlignmentLeft;
            textFiled.placeholder = @"必須";
            textFiled.delegate = self;
            textFiled.returnKeyType = UIReturnKeyNext;
            textFiled.keyboardType = UIKeyboardTypeNamePhonePad;
            textFiled.font = [Constants getFont];
            userIdTexField = textFiled;
            [userIdTexField becomeFirstResponder];
            [cell addSubview:textFiled];
            
            // スキャンボタン
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            float camera_h = [Constants getiPhoneValue:40 iPadCoeffcient:IPAD_COEFFCIENT];
            button.frame = CGRectMake(x + w + 5, ([Constants getiPhoneValue:tableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT] - camera_h ) / 2, camera_h, camera_h);
            [button setBackgroundImage:[UIImage imageNamed:@"camera_3.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickScan) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        } else if ([rowItem  isEqualToString:ROW_PSSWORD]) {
            // パスワード
            
            float w = [Constants getiPhoneValue:150 iPadCoeffcient:IPAD_COEFFCIENT] ;
            float h = [Constants getiPhoneValue:30 iPadCoeffcient:IPAD_COEFFCIENT];
            float x = [Constants getiPhoneValue:110 iPadValue:300];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = @"パスワード";
            cell.textLabel.font = [Constants getFont];
            
            float y = ([Constants getiPhoneValue:tableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT] - h ) / 2;
            // テキスト
            UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
            textFiled.textAlignment = NSTextAlignmentLeft;
            textFiled.placeholder = @"必須";
            textFiled.delegate = self;
            textFiled.secureTextEntry = YES;
            textFiled.returnKeyType = UIReturnKeyJoin;
            textFiled.keyboardType = UIKeyboardTypeNamePhonePad;
            textFiled.font = [Constants getFont];
            passwordTextField = textFiled;
            [cell addSubview:textFiled];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        } else if ([rowItem  isEqualToString:ROW_LOGIN]) {
            // ログイン
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = @"ログイン";
             cell.textLabel.font = [Constants getFont];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithHex:@"#7fbfff"];
            
        } else if ([rowItem  isEqualToString:ROW_EXIT]) {
            // ログイン
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = @"終了";
             cell.textLabel.font = [Constants getFont];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithHex:@"#ff7f7f"];
        }
        
    }
    
    return cell;
    
}

#pragma mark - テキストフィールド、エンターキー押下
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField == userIdTexField) {
        [passwordTextField becomeFirstResponder];
    } else if (textField == passwordTextField) {
        [self clickLogin];
    }
    return YES;
}

#pragma mark - バーコード
-(void)clickScan {
    
    //    [SVProgressHUD showWithStatus:@"スキャナ起動中..." maskType:SVProgressHUDMaskTypeGradient];
    [self performSelector:@selector(clickScanDelay) withObject:nil afterDelay:0.1];
}

-(void)clickScanDelay {;
    
    NSString *title = @"担当者ID";
    
    ZBarViewControllerSingleton* singleton = [ZBarViewControllerSingleton sharedManager];
    reader = [singleton getZBarReaderViewController];
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
    //    // 全てを無効
    //    [scanner setSymbology: 0
    //                   config: ZBAR_CFG_ENABLE
    //                       to: 0];
    //    // NW-7を有効
    //    [scanner setSymbology: ZBAR_CODABAR
    //                   config: ZBAR_CFG_ENABLE
    //                       to: 1];
    
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


#pragma mark - バーコード読み取り時
- (void) imagePickerController: (UIImagePickerController*) _reader  didFinishPickingMediaWithInfo: (NSDictionary*) info {
    NSDictionary* disciotnay = [NSDictionary dictionaryWithObjectsAndKeys:
                                _reader, [UIImagePickerController class],
                                info, [NSDictionary class],
                                nil];
    
    [self performSelector:@selector(imagePickerControllerDelay:) withObject:disciotnay afterDelay:0.001];
    
}

#pragma mark - バーコード読み取り時
- (void) imagePickerControllerDelay: (NSDictionary*)dictionary {
    
    NSDictionary* info = [dictionary objectForKey:[NSDictionary class]];
    
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
    // シャッター音再生
    //    AudioServicesPlaySystemSound (SCAN_SOUND);
    
    // 読取成功
    if (symbol.type == ZBAR_CODABAR) {
        // codabar(nw-7)
        userIdTexField.text = [BarCodeUtil extractCodabar:symbol.data];
    } else {
        userIdTexField.text = symbol.data;
    }
    
    // 0.1秒後にスキャナを閉じる
    [self performSelector:@selector(dismissReader) withObject:nil afterDelay:0.1];
}

// スキャナを閉じる
-(void) dismissReader {
    [reader dismissViewControllerAnimated:YES completion:nil];
}

-(void) focusPassword {
    [passwordTextField becomeFirstResponder];
}


#pragma mark - MainMenuからログアウト処理
- (IBAction)fromMainMenuLogout:(UIStoryboardSegue *)segue {
    
    // 初期化
    userIdTexField.text = @"";
    passwordTextField.text = @"";
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == SECTION_EXIT) {
        //          NSString *cellIdentifier = [NSString stringWithFormat:@"Section_%d",section];
        //          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        NSString* version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"ver.%@", version];
        return label;
    } else {
        return nil;
    }
    
}



#pragma mark - ヘッダー高さ
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
            
        case SECTION_USER:
            return 30;
            break;
        case SECTION_PASSWORD:
            return 5;
            break;
        case SECTION_LOGIN:
            return 25;
            break;
        case SECTION_EXIT:
            return 10;
            break;
        default:
            return 10;
            break;
    }
}
#pragma mark - フッター高さ
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case SECTION_LOGIN:
            return 0;
            break;
        case SECTION_USER:
            return 0;
            break;
        case SECTION_PASSWORD:
            return 0;
            break;
        case SECTION_EXIT:
            return 40;
            break;
        default:
            return 0;
            break;
    }
}


-(NSMutableArray*) getRowData : (int)section {
    
    return [rowData objectAtIndex:section];
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
    [passwordTextField resignFirstResponder];
    [userIdTexField resignFirstResponder];
}

#pragma mark -
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.singleTap) {
        // キーボード表示中のみ有効
        if (passwordTextField.isFirstResponder || userIdTexField.isFirstResponder) {
            return YES;
        }
        
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [userIdTexField becomeFirstResponder];

    userIdTexField.text = @"00000033";
    passwordTextField.text = @"33";
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return [Constants getiPhoneValue:loginTableview.rowHeight iPadCoeffcient:IPAD_COEFFCIENT];

}



@end
