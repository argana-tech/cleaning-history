//
//  SaveResultViewController.h
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/16.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatInfoDto.h"
#import "ActivityDeleteInfo.h"

@interface SaveResultViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
ActivityDeleteInfoDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *savResultTableView;

@property (nonatomic) int actionId;
@property (nonatomic) NSString* actionName;
@property (nonatomic) NSMutableArray* actionFields;

// 患者情報
@property (nonatomic) PatInfoDto* patInfoDto;
// 保存日時
@property (nonatomic) NSString* createdAt;
// 保存メッセージ
@property (nonatomic) NSString* savedMessage;
// 直前チェックエラー
@property (nonatomic) int invalidLastAction;
// 経過日数
@property (nonatomic) NSString* elapsedMessage;
// アクティビティID
@property (nonatomic) NSString *activityId;
// 登録日
@property (nonatomic) NSString* actionCompletedAt;


@end
