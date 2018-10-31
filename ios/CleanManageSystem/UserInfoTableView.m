//
//  UserInfoTableView.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/16.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "UserInfoTableView.h"
#define ROW_USER_ID @"ROW_USER_ID"
#define ROW_USER_NAME @"ROW_USER_NAME"

@implementation UserInfoTableView
{
    NSArray *rowData;
    NSArray *headers;
}




-(void) setData {
    rowData = [NSArray arrayWithObjects:@"ROW_USER_ID", @"ROW_USER_NAME", nil];
    headers = [NSArray arrayWithObjects:@"担当者情報", nil];
}




// テーブル行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return rowData.count;
}


// ヘッダー
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [headers objectAtIndex:section];
}


// セクション数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}




// 行作成(カスタムせる)
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    
    //
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        // 利用者情報
        UserInfo *userInfo = [UserInfo getUserInfo];
        
        NSString *rowItem = [rowData objectAtIndex:indexPath.row];
        
        if ([rowItem isEqualToString:ROW_USER_ID]) {
            // 利用者ID
            UIViewController *vc = [[UIViewController alloc] initWithNibName:@"LabelCell" bundle:nil];
            cell = (UITableViewCell*)vc.view;
            LabelCell *userIdCell = (LabelCell*)cell;
            
            
            userIdCell.titleLabel.text = @"担当者ID";
            userIdCell.dataLabel.text = [userInfo getUserId];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            
        } else if ([rowItem isEqualToString:ROW_USER_NAME]) {
            // 氏名
            UIViewController *vc = [[UIViewController alloc] initWithNibName:@"LabelCell" bundle:nil];
            cell = (LabelCell*)vc.view;
            LabelCell *nameCell = (LabelCell*)cell;
            
            //
            nameCell.titleLabel.text = @"氏名";
            nameCell.dataLabel.text = [userInfo getUseName];
            cell.selectionStyle = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
