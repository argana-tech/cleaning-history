//
//  SaveResultViewController.m
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/16.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import "SaveResultViewController.h"

#import "User.h"
#import "Constants.h"
#import "SBJson.h"
#import "UIColor+Hex.h"
#import "UIColor+FlatUI.h"
#import "ActionField.h"
#import "SVProgressHUD.h"

// セクションの行数
#define USER_INFO_ROW_COUNT 3
#define ACTION_FIELDS_COUNT 1
#define DATE_ROW_COUNT 1
#define ACTION_BACK_ROW_COUNT 1

// 担当者情報の行番号
#define ROW_USER_ID 0
#define ROW_USER_NAME 1
#define ROW_USER_KA 2

//// 各セクションの
#define SECTION_USER @"SECTION_USER"
#define SECTION_PAT_INFO @"SECTION_PAT_INFO"
#define SECTION_ACTION_FIELD @"SECTION_ACTION_FIELD"
#define SECTION_ACTION_BACK @"SECTION_ACTION_BACK"
#define SECTION_ACTION_DELETE @"SECTION_ACTION_DELETE"

enum INVALID_LAST_ACTION_CODE {
    INVALID_LAST_ACTION_SUCESS,
    INVALID_LAST_ACTION_ERROR
};

enum ALERT_TAG {
    
    ACTIVITY_DELETE,
    ACTIVITY_DELETE_COMPLATE
};
static const int CHECK_MARK_HEIGHT = 30;

@interface SaveResultViewController ()

@end

@implementation SaveResultViewController {
    int actionFieldIndex;
    int sectionActionFieldIndex;
    
    // 経過日数
    UILabel* elapsedLabel;
    // 保存メッセージ
    UILabel* savedMessageLabel;
    
    // テーブルデータ
    NSArray* rowData;
    // ヘッダー
    NSArray* headers;
    
    
}
@synthesize savResultTableView, actionFields;

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
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 保存完了", self.actionName];
    
    // トップのヘッダーの作成
    [self createHeaderLabel];
    
    savResultTableView.delegate = self;
    savResultTableView.dataSource = self;
    
    if (self.patInfoDto != nil) {
        rowData = @[SECTION_USER, SECTION_ACTION_FIELD, SECTION_PAT_INFO, SECTION_ACTION_BACK, SECTION_ACTION_DELETE];
        headers = @[@"担当者情報", @"保存情報",  @"患者情報", @"", @""];
    } else {
        rowData = @[SECTION_USER, SECTION_ACTION_FIELD, SECTION_ACTION_BACK, SECTION_ACTION_DELETE];
        headers = @[@"担当者情報", @"保存情報", @"", @""];
    }
}


-(void) clickBack {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self performSegueWithIdentifier:@"FromScanActionSaveResult" sender:self];
}

- (void) clickDelete {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"実施記録の取り消し" message:@"実施記録の取り消しを行いますか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    alert.tag = ACTIVITY_DELETE;
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case ACTIVITY_DELETE:
            [self alertViewClickDelete:buttonIndex];
            break;
        case ACTIVITY_DELETE_COMPLATE:
            [self alertViewClickDelelteComplate];
            break;
        default:
            break;
    }

}

- (void) alertViewClickDelelteComplate {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) alertViewClickDelete: (NSInteger) buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            LOG(@"取り消し-キャンセル");
            break;
        case 1:
            LOG(@"取り消し-実行");
            [self activityDelete];
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark 取り消し
- (void) activityDelete {
    
    
    [SVProgressHUD showWithStatus:@"取り消し中" maskType:SVProgressHUDMaskTypeGradient];
    ActivityDeleteInfo* activityDelete = [ActivityDeleteInfo new];
    activityDelete.delegate = self;
    [activityDelete activityDelete:self.activityId];
}



- (void) activityDeleteResult:(BOOL)result dadeleteIfnota:(NSDictionary *)deleteIfno errorMessage:(NSString *)errorMessage {

    NSString* message = deleteIfno[@"message"];
    if (result) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取り消し完了" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"アクション選択へ戻る", nil];
        alert.tag = ACTIVITY_DELETE_COMPLATE;
        [alert show];
    } else {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取り消し失敗" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
        
    }
    
}



#pragma mark - セクション毎の行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString* rowItem = rowData[section];
    
    if ([rowItem isEqualToString:SECTION_USER]) {
        return USER_INFO_ROW_COUNT;
    } else if ([rowItem isEqualToString:SECTION_PAT_INFO]) {
        // 患者情報
        return DISP_PAT_INFO_ROW_COUNT;
    } else if ([rowItem isEqualToString:SECTION_ACTION_FIELD]) {
        return [actionFields count] + 1;
    } else if ([rowItem isEqualToString:SECTION_ACTION_BACK]) {
        return 1;
    } else if ([rowItem isEqualToString:SECTION_ACTION_DELETE]) {
        return 1;
    } else {
        return 0;
    }
    
    
}


#pragma mark - ヘッダー文言
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return headers[section];
}


#pragma mark - セクション数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.patInfoDto != nil) {
        // 患者情報があれば表示
        return [headers count];
    } else {
        return [headers count];
    }
}

// 行作成(カスタムせる)
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%d_%d", indexPath.section, indexPath.row];
    //
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSString* rowItem = rowData[indexPath.section];
        if ([rowItem isEqualToString:SECTION_USER]) {
            // 利用者
            cell = [self getUserInfoCell: indexPath.row cellIdentifier:cellIdentifier];
        } else if ([rowItem isEqualToString:SECTION_PAT_INFO]) {
            // 患者情報
            cell = [self.patInfoDto getPatInfoCell: indexPath.row cellIdentifier:cellIdentifier];
            
        } else if ([rowItem isEqualToString:SECTION_ACTION_FIELD]) {
            // 保存項目
            if ([actionFields count] <= indexPath.row ) {
                // 保存時間
                cell = [self getDateCell: indexPath.row cellIdentifier:cellIdentifier];
            } else {
                // アクション
                cell = [self getActionFieldCell: indexPath.row cellIdentifier:cellIdentifier];
            }
        } else if ([rowItem isEqualToString:SECTION_ACTION_BACK]) {
            // アクション選択画面へ
            cell = [self getLogoutCell: indexPath.row cellIdentifier:cellIdentifier];
        } else if ([rowItem isEqualToString:SECTION_ACTION_DELETE]) {
            // 取り消し
            cell = [self getDeleteCell:indexPath.row cellIdentifier:cellIdentifier];
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
        cell.selectionStyle = UITableViewCellAccessoryNone;
        

        
    } else if (row == ROW_USER_NAME) {
        // 氏名
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text = @"氏名";
        cell.detailTextLabel.text = user.userName;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
    } else if (row == ROW_USER_KA) {
        // 診療科
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text = @"診療科・部署";
        cell.detailTextLabel.text = user.kaName;
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    
    // font
    cell.textLabel.font = [Constants getFont];
    cell.detailTextLabel.font = [Constants getFont];
    
    return cell;
}

#pragma mark - アクションフィールドセル作成
-(UITableViewCell*) getActionFieldCell: (int)row cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell *cell;
    
    ActionField* actionField = [actionFields objectAtIndex:actionFieldIndex];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.textLabel.text = actionField.name;
    cell.tag = actionField.fieldId;
    
    if([actionField.type isEqualToString: FIELDS_TYPE_BARCODE]) {
        // バーコード
        cell.detailTextLabel.text = actionField.textField.text;
        
    } else if([actionField.type isEqualToString: FIELDS_TYPE_INPUT]) {
        // 手入力
        cell.detailTextLabel.text = actionField.textField.text;
        
    } else if([actionField.type isEqualToString: FIELDS_TYPE_BOOLEAN]) {
        // はい/いいえ
        cell.detailTextLabel.text = actionField.actionSwitch.on?@"はい" : @"いいえ";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // font
    cell.textLabel.font = [Constants getFont];
    cell.detailTextLabel.font = [Constants getFont];
    
    actionFieldIndex++;
    return cell;
}

#pragma mark - 登録時間セル作成
-(UITableViewCell*) getDateCell: (int)row cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.textLabel.text = @"登録時間";
    cell.detailTextLabel.text = self.actionCompletedAt;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // font
    cell.textLabel.font = [Constants getFont];
    cell.detailTextLabel.font = [Constants getFont];
    
    return cell;
}

#pragma mark - アクション選択画面へセル作成
-(UITableViewCell*) getLogoutCell: (int)row cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.text = @"入力完了";
    cell.textLabel.textColor = [UIColor colorWithHex:@"#7fbfff"];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    // font
    cell.textLabel.font = [Constants getFont];
    
    return cell;
}

#pragma mark - アクション選択画面へ取り消しセル作成
-(UITableViewCell*) getDeleteCell: (int)row cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.text = @"取り消し";
    cell.textLabel.textColor = [UIColor colorWithHex:@"#ff7f7f"];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [Constants getFont];
    
    
    return cell;
}


// 呼び出し
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

// 行選択イベント
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* rowItem = rowData[indexPath.section];
    
    if ([rowItem isEqualToString:SECTION_ACTION_BACK]) {
        [self clickBack];
    } else if ([rowItem isEqualToString:SECTION_ACTION_DELETE]) {
        [self clickDelete];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除
}


#pragma mark - セルヘッダー高さ
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSString* rowItem = rowData[section];
    if ([rowItem isEqualToString:SECTION_USER]) {
        // 利用者
        return [self getUserHeaderHight];
    } else if ([rowItem isEqualToString:SECTION_PAT_INFO]) {
        // 患者情報
        return 30;
        
    } else if ([rowItem isEqualToString:SECTION_ACTION_FIELD]) {
        // 保存項目
        return 30;
    } else if ([rowItem isEqualToString:SECTION_ACTION_BACK]) {
        // アクション選択画面へ
        return 10;
    } else if ([rowItem isEqualToString:SECTION_ACTION_DELETE]) {
        // 取り消し
        return 10;
    } else {
        return 0;
    }
}

-(CGFloat) getUserHeaderHight {
    
    float h = 0;
    if ( 0 < [self.savedMessage length]) {
        h += savedMessageLabel.frame.size.height;
    }
    
    if (0 < [self.elapsedMessage length] ) {
        
        h += elapsedLabel.frame.size.height;

    }
    
    if (h == 0) {
        return 50;//[Constants getiPhoneValue:50 iPadCoeffcient:IPAD_COEFFCIENT ];
    } else {
        h += [Constants getiPhoneValue:35 + 10 + CHECK_MARK_HEIGHT iPadCoeffcient:IPAD_COEFFCIENT ];
        return h;//[Constants getiPhoneValue:h iPadCoeffcient:IPAD_COEFFCIENT ];
    }
    
}

-(BOOL) isLastActionError {
    if (self.invalidLastAction == INVALID_LAST_ACTION_ERROR) {
        return YES;
    } else if (self.invalidLastAction == INVALID_LAST_ACTION_SUCESS) {
        return NO;
    } else {
        LOG(@"直前チェックエラーに存在しないコードが設定されています。errorCode:%d", self.invalidLastAction);
        return NO;
    }
}

-(UIColor*) getMessageBackColor {
    if ([self isLastActionError]) {
        return [UIColor whiteColor];
    } else {
        return [UIColor whiteColor];
    }
    
}

-(UIColor*) getMessageStrColor {
    if ([self isLastActionError]) {
        return [UIColor redColor];
    } else {
        return [UIColor greenSeaColor];
    }
    
}

-(UIImage*) getCheckMarkImage {
    if ([self isLastActionError]) {
        return [UIImage imageNamed:@"none_2_50"];
    } else {
        return [UIImage imageNamed:@"check_greensea_50"];
    }
}

-(CGFloat) getCheckMarkOrginY {
    return 7;
}

#pragma ヘッダーの作成
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* header;
    NSString* rowItem = rowData[section];
    if ([rowItem isEqualToString:SECTION_USER]) {
        CGFloat x = [Constants getiPhoneValue:300 iPadValue:tableView.frame.size.width - 20];
        CGRect frame = CGRectMake(10, 0, x, [self getUserHeaderHight]);
        header = [[UIView alloc] initWithFrame:frame];
        
        // メッセージ
        float h = [self getUserHeaderHight] - 40;

        UILabel* headerMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, x, h)];
        
        headerMessageLabel.backgroundColor = [self getMessageBackColor];
        CALayer *layer = [headerMessageLabel layer];
        [layer setCornerRadius:6.0];
        [layer setBorderColor:[self getMessageStrColor].CGColor];
        [layer setBorderWidth:[Constants getiPhoneValue:2.5 iPadValue:5]];
        
        
        
        // チェックマーク
        UIImage* image = [self getCheckMarkImage];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        CGRect tmp = imageView.frame;
        // 中央に配置
        tmp.origin = CGPointMake((headerMessageLabel.frame.size.width - imageView.frame.size.width) / 2, [self getCheckMarkOrginY] );
        tmp.size = CGSizeMake([Constants getiPhoneValue:tmp.size.width iPadCoeffcient:IPAD_COEFFCIENT ] , [Constants getiPhoneValue:tmp.size.height iPadCoeffcient:IPAD_COEFFCIENT ]);
        imageView.frame = tmp;
        [headerMessageLabel addSubview:imageView];
        
        // メッセージをヘッダーに追加
        [headerMessageLabel addSubview:savedMessageLabel];
        
        if (0 < [self.elapsedMessage length]) {
            // 経過時間を表示
            [headerMessageLabel addSubview:elapsedLabel];
        }
        
        // ヘッダーに追加
        if ( 0 < [self.savedMessage length] || 0 < [self.elapsedMessage length]) {
            [header addSubview:headerMessageLabel];
        }
        
        // 担当者情報ヘッダー
        frame = CGRectMake(15, [self getUserHeaderHight] - 30, x, 30);
        UILabel* title = [[UILabel alloc] initWithFrame:frame];
        title.textColor = [UIColor grayColor];
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:14];
        title.text = @"担当者情報";
        

        
        [header addSubview:title];
        
    } else {
        header = nil;
    }
    return header;
}

#pragma mark - ヘッダーメッセージの作成
// 画面ロード時に作成しておく
-(void) createHeaderLabel {
    
    
    
    CGFloat w = [Constants getiPhoneValue:300 iPadValue:self.view.frame.size.width - 20];
    CGRect frame = CGRectMake(10, 0, w, 30);
    savedMessageLabel = [[UILabel alloc] initWithFrame:frame];
    savedMessageLabel.textColor = [self  getMessageStrColor];
    // 中央
    savedMessageLabel.textAlignment = NSTextAlignmentCenter;
    savedMessageLabel.font = [UIFont boldSystemFontOfSize:[Constants getiPhoneValue:19 iPadValue:38]];
    savedMessageLabel.numberOfLines = 0;
    
    // メッセージ
    savedMessageLabel.text = self.savedMessage;
    
    [savedMessageLabel sizeToFit];
    if ([Constants getiPhoneValue:40 iPadValue:80] < savedMessageLabel.frame.size.height) {
        // 2行以上だと左寄席
        savedMessageLabel.textAlignment = NSTextAlignmentLeft;
    }
    savedMessageLabel.frame = CGRectMake(10, 4 + [Constants getiPhoneValue:CHECK_MARK_HEIGHT iPadCoeffcient:IPAD_COEFFCIENT ], w, savedMessageLabel.frame.size.height);
    
    // 経過日数
    if (0 < [self.elapsedMessage length]) {
        frame = CGRectMake(2, savedMessageLabel.frame.size.height + [Constants getiPhoneValue:CHECK_MARK_HEIGHT iPadCoeffcient:IPAD_COEFFCIENT ] + 1, w, [Constants getiPhoneValue:21 iPadCoeffcient:IPAD_COEFFCIENT ]);
        elapsedLabel = [[UILabel alloc] initWithFrame:frame];
        elapsedLabel.textColor = [self getMessageStrColor];
        elapsedLabel.textAlignment = NSTextAlignmentCenter;
        elapsedLabel.font = [UIFont systemFontOfSize:[Constants getiPhoneValue:17 iPadValue:34]];
        elapsedLabel.text = self.elapsedMessage;
        elapsedLabel.adjustsFontSizeToFitWidth = YES;
        
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Constants getiPhoneValue:tableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
