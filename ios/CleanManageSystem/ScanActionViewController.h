//
//  ActionViewController.h
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/16.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "SaveResultViewController.h"
#import "BarcodeViewController.h"
#import "BarcodeOverlay.h"
#import "CustomAlertViewController.h"
#import "SearchPatInfo.h"
#import "PatInfoDto.h"
#import "SearchScopeInfo.h"
#import "SearchWasherInfo.h"

@interface ScanActionViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
ZBarReaderDelegate,
UITextFieldDelegate,
UIGestureRecognizerDelegate,
CustomAlertViewControllerDelegate,
SearchPatInfoDelegate,
SearchScopeInfoDelegate,
SearchWasherInfoDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *actionTableView;
@property (nonatomic) NSMutableArray *headers;
@property (nonatomic) int actionId;
@property (nonatomic) NSString* actionName;

@property (nonatomic) NSString *activityId;

//
@property (nonatomic) UITextField *targetTextField;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;

@end
