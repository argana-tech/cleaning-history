//
//  RecentActivityViewController.m
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/11.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import "RecentActivityViewController.h"
#import "UIColor+FlatUI.h"
#import "ActivityFieldDto.h"
#import "SVProgressHUD.h"
#import "Constants.h"

#define STAFF_ROW_ID @"STAFF_ROW_ID"
#define STAFF_ROW_NAME @"STAFF_ROW_NAME"
#define STAFF_ROW_SEC @"STAFF_ROW_SEC"

#define DATA_ROW_SCOPE @"DATA_ROW_SCOPE"
#define DATA_ROW_DATE @"DATA_ROW_DATE"

#define PAT_ROW_NAME @"PAT_ROW_NAME"
#define PAT_ROW_KNAME @"PAT_ROW_KNAME"

#define ACTIVITY_ROW_REMOVE @"ACTIVITY_ROW_REMOVE"

@interface RecentActivityViewController ()

@end

@implementation RecentActivityViewController {
    
    __weak IBOutlet UITableView *activityTableview;
    NSMutableArray* rowData;
    NSMutableArray* headers;
    PatInfoDto* patInfo;
}

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
    // Do any additional setup after loading the view from its nib.
    
    activityTableview.dataSource = self;
    activityTableview.delegate = self;
    
    self.navigationItem.title = _recentActivityDto.actionName;
    
    NSMutableArray* dataRow = [@[DATA_ROW_SCOPE] mutableCopy];
    
    // とりあえず１件
    patInfo = nil;
    for (ActivityFieldDto* dto in _recentActivityDto.activityFields) {
        [dataRow addObject:dto];
        patInfo = dto.patientData;
    }
    [dataRow addObject:DATA_ROW_DATE];
    
    
    rowData = [@[] mutableCopy];
    [rowData addObject: @[STAFF_ROW_ID, STAFF_ROW_NAME, STAFF_ROW_SEC]];
    [rowData addObject: dataRow];
    if (patInfo) {
        [rowData addObject: @[PAT_ROW_NAME, PAT_ROW_KNAME]];
    }
    [rowData addObject: @[ACTIVITY_ROW_REMOVE]];
    
    
    headers = [@[] mutableCopy];
    [headers addObject:@"担当者"];
    [headers addObject:@"保存情報"];
    if (patInfo) {
        [headers addObject:@"患者情報"];
    }
    [headers addObject:@""];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - セクション毎の行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rowData[section] count];
}

#pragma mark - ヘッダー文言
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return headers[section];
}

#pragma mark - 行選択イベント
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *rowName = rowData[indexPath.section][indexPath.row];
    if ([rowName isEqualToString:ACTIVITY_ROW_REMOVE]) {
        NSString* title = [NSString stringWithFormat:@"取り消し"];
        NSString* message = [NSString stringWithFormat:@"「%@」を取り消しますか？", _recentActivityDto.actionName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        [alert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // 取り消さない
            LOG(@"取り消さない");
            break;
        case 1:
            
            // 取り消し
            LOG(@"取り消し");
            [self activityRemove];
            break;
        default:
            break;
    }
}

#pragma mark - 削除
- (void) activityRemove {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    ActivityDeleteInfo *delete = [ActivityDeleteInfo new];
    delete.delegate = self;
    [delete activityDelete:_recentActivityDto.id_];
}


-(void) activityDeleteResult:(BOOL)result dadeleteIfnota:(NSDictionary *)deleteIfno errorMessage:(NSString *)errorMessage {
    if (errorMessage) {
        [SVProgressHUD dismiss];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"取り消し失敗" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"取り消し完了"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - セクション数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [rowData count];
}

#pragma mark - 行作成
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%d_%d", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        NSObject* rowObject = rowData[indexPath.section][indexPath.row];
        
        if ([rowObject class] == [ActivityFieldDto class]) {
            
            ActivityFieldDto* dto = (ActivityFieldDto*)rowObject;
            cell.textLabel.text = dto.actionFieldName;
            cell.detailTextLabel.text = dto.value;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        } else {
            
            NSString* rowName = (NSString*)rowObject;
            if ([rowName isEqualToString:STAFF_ROW_ID]) {
                
                cell.textLabel.text = @"担当者ID";
                cell.detailTextLabel.text = _recentActivityDto.staffmShId;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            } else if ([rowName isEqualToString:STAFF_ROW_NAME]) {
                cell.textLabel.text = @"氏名";
                cell.detailTextLabel.text = _recentActivityDto.staffmShName;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if ([rowName isEqualToString:STAFF_ROW_SEC]) {
                cell.textLabel.text = @"診療科・所属";
                cell.detailTextLabel.text = _recentActivityDto.staffmKaName;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            } else if ([rowName isEqualToString:DATA_ROW_SCOPE]) {
                cell.textLabel.text = @"スコープID";
                cell.detailTextLabel.text = _recentActivityDto.scopeId;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            } else if ([rowName isEqualToString:DATA_ROW_DATE]) {
                
                cell.textLabel.text = @"実施日時";
                cell.detailTextLabel.text = _recentActivityDto.actionCompletedAt;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
                
                
            } else if ([rowName isEqualToString:PAT_ROW_NAME]) {
                
                cell.textLabel.text = @"氏名";
                cell.detailTextLabel.text = patInfo.ptKjName;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            } else if ([rowName isEqualToString:PAT_ROW_KNAME]) {
                
                cell.textLabel.text = @"カナ";
                cell.detailTextLabel.text = patInfo.ptKnName;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            } else if ([rowName isEqualToString:ACTIVITY_ROW_REMOVE]) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                cell.textLabel.text = @"取り消し";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor lightRedColor];
            }
        }
        
        cell.textLabel.font = [Constants getFont];
        cell.detailTextLabel.font = [Constants getFont];
        
    }
    return cell;
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Constants getiPhoneValue:tableView.rowHeight iPadCoeffcient:IPAD_COEFFCIENT];
    
}

@end
