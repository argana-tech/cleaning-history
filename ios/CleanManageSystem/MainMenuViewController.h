//
//  MainMenuViewController.h
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/12.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanActionViewController.h"
#import "RecentActivity.h"
#import "RecentActivityViewController.h"

@interface MainMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ZBarReaderDelegate, RecentActivityDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainMenuTableview;

@property (nonatomic) NSMutableArray *userInfoRowData;
@property (nonatomic) NSMutableArray *actionMenuRowData;
@property (nonatomic) NSMutableArray *logoutRowData;

@property (nonatomic) NSMutableArray *headers;

@property (nonatomic) int selectActionId;
@property (nonatomic) NSString* selectActionName;

- (void) searchRecentActivity;

- (IBAction)fromScanActionSaveResult:(UIStoryboardSegue *)segue;

@end
