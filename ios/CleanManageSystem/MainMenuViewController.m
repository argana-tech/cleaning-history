//
//  MainMenuViewController.m
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/12.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import "MainMenuViewController.h"
#import "User.h"
#import "Constants.h"
#import "SBJson.h"
#import "UIColor+Hex.h"
#import "SVProgressHUD.h"
#import "NSMutableURLRequest+UserAgent.h"
#import "RecentActivityDto.h"
#import "RecentActivityTableViewCell.h"
#import "ActivityFieldDto.h"
#import "UIColor+FlatUI.h"

#define USER_INFO_ROW_COUNT 3
#define LOGOUT_ROW_COUNT 1
#define RECENT_ACTIVIEY_ROW_COUNT 1


#define ROW_USER_ID 0
#define ROW_USER_NAME 1
#define ROW_USER_KA 2


#define SECTION_USER 0
#define SECTION_ACTION 1
#define SECTION_LOG_OUT 2
#define SECTION_RECENT_ACTIVITY 3

#define ERROR_REQUIRE_AUTHOLOIZE_CODE 0

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController {
    int actionIndex;
    int sectionActionIndex;
    NSMutableArray* recentActivities;
    
    RecentActivityDto* selectedRecentActivityDto;
}

@synthesize headers,userInfoRowData, actionMenuRowData, mainMenuTableview, logoutRowData;
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
    
    //[self searchRecentActivity ];
    
    
    [self setData];
    
    // ナビゲーション
    self.navigationItem.title = @"アクションを選択";
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *backButton = [UIBarButtonItem new];
    backButton.title = @"メニュー";
    self.navigationItem.backBarButtonItem = backButton;
    
    
    mainMenuTableview.dataSource = self;
    mainMenuTableview.delegate = self;
}



- (void) searchRecentActivity {
    RecentActivity *recentActivity = [RecentActivity new];
    recentActivity.delegate = self;
    [recentActivity search];
    
    recentActivities = [@[@""] mutableCopy];
}

- (void) recentActivityResult:(NSMutableArray *)_recentActivities errorMessage:(NSString *)errorMessage {
    
    if (errorMessage) {
        LOG(@"%@", errorMessage);
    } else {
        sectionActionIndex = 0;
        recentActivities = _recentActivities;
        [mainMenuTableview reloadData];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [SVProgressHUD dismiss];
    [self searchRecentActivity];
}

#pragma mark - ログアウト
-(void)logout {
    
    User *user = [User getInstance];
    
    // サーバーへリクエストを送信
    NSString *urlStr = [NSString stringWithFormat: @"%@?%@=%@&%@=%@", API_LOGOUT_URL, PRM_AUTH_KEY, user.authKey, PRM_CIS_ID, user.userId];
    NSURL *url                   = [NSURL URLWithString:[API_URL stringByAppendingString:urlStr]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    NSURLResponse *response      = nil;
    NSError *error               = nil;
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    LOG(@"[ログアウト]-[GET] url:%@", [url path]);
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // エラー情報
    if ( error ) {
        LOG(@"[ログアウト]-エラー [%@] Connection failed. Error - %@ %d %@", url, [error domain], [error code], [error localizedDescription]);
        [[self createAlertView:@"ログアウトエラー" message:[NSString stringWithFormat:@"ログアウトに失敗しました。エラーコード(%d)", [error code]]]show];
        return;
    }
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( [httpResponse statusCode] != 200 ) {
        LOG(@"[ログアウト]-レスポンスエラー [%@] statusCode:%d (%@)", url, [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        [[self createAlertView:@"ログアウトエラー" message:[NSString stringWithFormat:@"ログアウトに失敗しました。ステータスーコード(%d)", [httpResponse statusCode]]]show];
        return;
    }
    
    // データ
    if (!data) {
        LOG(@"[ログアウト]-データ受信エラー　データ無し [%@] data:nil", url);
        [[self createAlertView:@"ログアウトエラー" message:[NSString stringWithFormat:@"ログアウトに失敗しました。データを受け取れませんでした。"]]show];
        return;
    }
    
    // JSONへ
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *statuses = [json_string JSONValue];
    
    LOG(@"[ログアウト]-受信データ %@", statuses);
    
    NSString *errorStr = [statuses objectForKey:ERROR ];
    if (errorStr == nil) {
        // 利用者情報をクリア
        [user logout];
        
        [self performSegueWithIdentifier:@"FromMainMenuLogout" sender:self];
    } else {
        // エラー
        [self errorAction:errorStr];
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
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        
    }
}

-(void)timeOutErrorAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"タイムアウトエラー"
                                                        message:[NSString stringWithFormat: @"再度ログインし直してください。"]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"はい",
                              nil];
    alertView.tag = ERROR_REQUIRE_AUTHOLOIZE_CODE;
    [alertView show];
}

#pragma mark - アラートビューの作成
-(UIAlertView*) createAlertView :(NSString*)title message:(NSString*)message {
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
    return alertView;
}

#pragma mark - アラート閉じた後の処理
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ERROR_REQUIRE_AUTHOLOIZE_CODE:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        default:
            break;
    }
    
}

- (IBAction)fromScanActionSaveResult:(UIStoryboardSegue *)segue {
    
}


#pragma mark - データ設定
-(void) setData {
    // アクションメニュー
    actionMenuRowData = [self getActionMenus];
}

#pragma mark - アクションセル判断
-(BOOL)isActionSection: (int)section {
    int count = [actionMenuRowData count];
    if (0 < section && section < count + 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - ログアウトセル判断
-(BOOL)isLogoutSection : (int)section {
    int count = [actionMenuRowData count];
    if (section == count + 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 履歴判断
-(BOOL)isRecentActivitySection : (int)section {
    int count =  1 + 1 + [actionMenuRowData count];
    if (count <= section && section < count + 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 利用者セル判断
-(BOOL)isUserSection : (int)section {
    return section == 0 ? YES:NO;
}

#pragma mark - アクションメニューの取得
-(NSMutableArray*) getActionMenus {
    
    User *user = [User getInstance];
    NSString *urlStr = [NSString stringWithFormat: @"%@?%@=%@", API_LIST_ACTIONS_URL, PRM_AUTH_KEY, user.authKey];
    NSURL *url                   = [NSURL URLWithString:[API_URL stringByAppendingString:urlStr]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURLUserAgent:url];
    NSURLResponse *response      = nil;
    NSError *error               = nil;
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //
    LOG(@"[アクションメニュー取得]-[GET] url:%@", [url path]);
    // エラー情報
    if ( error ) {
        LOG(@"[アクションメニュー取得]-通信エラー %@ %d %@", [error domain], [error code], [error localizedDescription]);
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"アクション取得エラー"
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
        LOG(@"[アクションメニュー取得]-レスポンス受信エラー statusCode:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"アクション取得エラー"
                                  message:[NSString stringWithFormat: @"アクションの取得に失敗しました。ステータスコード:%d (%@)", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]]
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"はい",
                                  nil];
        [alertView show];
        
        return [NSMutableArray array];
    }
    
    if (!data) {
        // 受信データ無し
        LOG(@"[アクションメニュー取得]-データ受信エラー データ無し");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"アクション取得エラー"
                                                            message:[NSString stringWithFormat: @"アクションの取得に失敗しました。アクションデータが取得できませんでした。"]
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
    LOG(@"[アクションメニュー取得]-受信データ %@", statuses);
    
    // エラーを取得
    NSString *errorStr = [statuses objectForKey:ERROR ];
    if (errorStr == nil) {
        // 正常
        
        // authKeyを再設定
        user.authKey = [statuses objectForKey:PRM_AUTH_KEY];
        NSArray *actions = [statuses objectForKey:ACTIONS];
        return [actions mutableCopy];
        
    } else {
        // エラー
        [self errorAction:errorStr];
        return nil;
    }
}



#pragma mark - セルヘッダー高さ
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self isUserSection:section]) {
        return 50;
    } else if ([self isActionSection:section]) {
        return 0;
    } else if ([self isLogoutSection:section]) {
        return 40;
    } else if ([self isRecentActivitySection:section]) {
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
    if ([self isUserSection:section]) {
        return USER_INFO_ROW_COUNT;
    } else if ([self isActionSection:section]) {
        return 1;
    } else if ([self isLogoutSection:section]) {
        return LOGOUT_ROW_COUNT;
    } else if ([self isRecentActivitySection:section]) {
        return [recentActivities count];
    }  else {
        return 0;
    }
}


#pragma mark - ヘッダー文言
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self isUserSection:section]) {
        return @"担当者情報";
    } else if ([self isActionSection:section]) {
        if (sectionActionIndex == 0) {
            sectionActionIndex++;
            return @"アクション";
        }else {
            return @"";
        }
    } else if ([self isLogoutSection:section]) {
        return @"";
    } else if ([self isRecentActivitySection:section]) {
        return @"アクション履歴";
    }  else {
        return @"";
    }
}


#pragma mark - セクション数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    //    if (0 < [recentActivities count]) {
    //        return 5;
    //    } else {
    //        return 4;
    //    }
    
    int section = 1 + [actionMenuRowData count] + LOGOUT_ROW_COUNT + RECENT_ACTIVIEY_ROW_COUNT;
    LOG(@"section:%d (%d)", section, USER_INFO_ROW_COUNT + [actionMenuRowData count] + LOGOUT_ROW_COUNT);
    return section;
}


#pragma mark - 行選択イベント
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isActionSection:indexPath.section]) {
        // アクション
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.selectActionId = cell.tag;
        self.selectActionName = cell.textLabel.text;
        
        [self performSegueWithIdentifier:@"ScanActionSegue" sender:self];
        
    } else if ([self isLogoutSection:indexPath.section]) {
        // ログアウト
        [self logout];
    } else if ([self isRecentActivitySection:indexPath.section]) {
        // 履歴
        [self recentActivity:recentActivities[indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 行作成
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%d_%d", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    
    if ([self isRecentActivitySection:indexPath.section]) {
        // 履歴
        cell = [self getRecentActivityCell: indexPath.row cellIdentifier:cellIdentifier];
    } else if (cell == nil) {
        if ([self isUserSection:indexPath.section]) {
            // 利用者
            cell = [self getUserInfoCell: indexPath.row cellIdentifier:cellIdentifier];
        } else if ([self isActionSection:indexPath.section]) {
            // アクション
            cell = [self getActionCell: indexPath.row cellIdentifier:cellIdentifier];
        } else if ([self isLogoutSection:indexPath.section]) {
            // ログアウト
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

#pragma mark - アクションセル作成
-(UITableViewCell*) getActionCell: (int)row cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell *cell;
    
    NSDictionary* action = [actionMenuRowData objectAtIndex:actionIndex];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.text = [action objectForKey:ACTIONS_NAME];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.tag = [[action objectForKey:ACTIONS_ID] intValue];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor lightBlueColor];//[UIColor colorWithHex:@"#7fbfff"];
    
    // font
    cell.textLabel.font = [Constants getFont];
    
    actionIndex++;
    return cell;
}

#pragma mark - ログアウトセル作成
-(UITableViewCell*) getLogoutCell: (int)row cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.text = @"ログアウト";
    cell.textLabel.textColor = [UIColor colorWithHex:@"#ff7f7f"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    // font
    cell.textLabel.font = [Constants getFont];
    
    return cell;
}

#pragma mark - 履歴セル作成
-(UITableViewCell*) getRecentActivityCell: (int)row cellIdentifier:(NSString*)cellIdentifier {
    RecentActivityTableViewCell *cell;
    cell = [[RecentActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    
    RecentActivityDto *dto = recentActivities[row];
    cell.activityName.text = dto.actionName;
    cell.createdAt.text =dto.actionCompletedAt;
    cell.scopeId.text = [NSString stringWithFormat:@"スコープID: %@", dto.scopeId];
    cell.userName.text = dto.staffmShName;
    ActivityFieldDto* activityField = dto.activityFields[0];
    cell.value.text = [NSString stringWithFormat:@"%@: %@",activityField.actionFieldName, activityField.value];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // font
    cell.textLabel.font = [Constants getFont];
    
    return cell;
}

- (void) recentActivity : (RecentActivityDto*) recentActivityDto {
    selectedRecentActivityDto = recentActivityDto;
    [self performSegueWithIdentifier:@"RecentActivitySegue" sender:self];
}

// 呼び出し
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *view = [segue destinationViewController];
    if ([view class] == [ScanActionViewController class]) {
        ScanActionViewController *savc = (ScanActionViewController*) view;
        savc.actionId = self.selectActionId;
        savc.actionName = self.selectActionName;
    } else if ([view class] == [RecentActivityViewController class]) {
        RecentActivityViewController* ravc = (RecentActivityViewController*)view;
        ravc.recentActivityDto = selectedRecentActivityDto;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// セルの高さ
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([self isRecentActivitySection:indexPath.section]) {
        if([Constants isDeviceiPad]) {
            return  99;
        } else {
            return 68;
        }
    } else {
        return [Constants getiPhoneValue:tableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT];
    }
    
}



@end
