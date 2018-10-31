//
//  BarcodeViewController.m
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/21.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import "BarcodeViewController.h"
#import "SVProgressHUD.h"

@interface BarcodeViewController ()

@end

@implementation BarcodeViewController

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
    
    self.navigationController.title = self.title;
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    
    
}

-(void) viewDidLayoutSubviews {
    [SVProgressHUD dismiss];
}

-(void) viewDidDisappear:(BOOL)animated {
    
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
