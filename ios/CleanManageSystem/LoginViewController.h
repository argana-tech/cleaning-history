//
//  LoginViewController.h
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/12.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "BarcodeOverlay.h"
#import "BarcodeViewController.h"




@interface LoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ZBarReaderDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *loginTableview;


@property (nonatomic) NSArray *rowData;
@property (nonatomic) NSMutableArray *loginButtonData;
@property (nonatomic) NSArray *headers;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic) UITextField *userIdTexField;
@property (nonatomic) UITextField *passwordTextField;

@end
