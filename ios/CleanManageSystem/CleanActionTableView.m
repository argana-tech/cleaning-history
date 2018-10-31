//
//  CleanActionTableViewDelegate.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/19.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "CleanActionTableView.h"
#import "MainMenuViewController.h"

#define ROW_ACTION_START @"ROW_ACTION_START"
#define ROW_ACTION_CELANING @"ROW_ACTION_CELANING"

#define ROW_LOG_OUT @"ROW_LOG_OUT"

@implementation CleanActionTableView
{
    
    NSArray *rowData;
    NSArray *headers;
    int selectActionType;
}
@synthesize claenActionTableView;

-(void) setData {
    //
    //    actionTableView.delegate = self;//[CleanActionTableDelegate new];
    //    actionTableView.dataSource = self;
    //
    
    
    rowData = [NSArray arrayWithObjects:
               [NSArray arrayWithObjects:ROW_ACTION_START, ROW_ACTION_CELANING, nil],
               [NSArray arrayWithObjects:ROW_LOG_OUT, nil],
               nil];
    headers = [NSArray arrayWithObjects:@"アクション", @"", nil];
}




// テーブル行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getRowData:section].count;
}


// ヘッダー
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [headers objectAtIndex:section];
}


// セクション数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return rowData.count;
    
}

// 行選択イベント
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *rowItem = [[self getRowData:indexPath.section] objectAtIndex:indexPath.row];
    
}

// 呼び出し
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *view = [segue destinationViewController];
    
    if ([view class] == [ScanActionViewController class]) {
//        ScanActionViewController *savc = (ScanActionViewController*) view;
//        savc.actionType = selectActionType;
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"t");
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"tc");
}




// 行作成(カスタムせる)
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    
    //
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        
        NSString *rowItem = [[self getRowData:indexPath.section] objectAtIndex:indexPath.row];
        
        if ([rowItem isEqualToString:ROW_ACTION_START]) {
            // 利用開始
            UIViewController *vc = [[UIViewController alloc] initWithNibName:@"ButtonCell" bundle:nil];
            cell = (ButtonCell*)vc.view;
            ButtonCell *buttonCell = (ButtonCell*)cell;
            
            buttonCell.buttonLabel.text = @"利用開始";
            buttonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            
        } else if ([rowItem isEqualToString:ROW_ACTION_CELANING]) {
            // 洗浄開始
            UIViewController *vc = [[UIViewController alloc] initWithNibName:@"ButtonCell" bundle:nil];
            cell = (ButtonCell*)vc.view;
            ButtonCell *buttonCell = (ButtonCell*)cell;
            
            buttonCell.buttonLabel.text = @"洗浄開始";
            buttonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if ([rowItem isEqualToString:ROW_LOG_OUT]) {
            // ログアウト
            //            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
            //            cell.textLabel.text = @"logout";
            //            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            UIViewController *vc = [[UIViewController alloc] initWithNibName:@"ButtonCell" bundle:nil];
            cell = (ButtonCell*)vc.view;
            ButtonCell *buttonCell = (ButtonCell*)cell;
            
            buttonCell.buttonLabel.text = @"ログアウト";
            [buttonCell.buttonLabel setTextColor:[UIColor redColor]];
        }
        
    }
    //    actionTableView.allowsSelection = YES;
    return cell;
    
}


-(NSArray*) getRowData : (int)section {
    return [rowData objectAtIndex:section];
}



@end
