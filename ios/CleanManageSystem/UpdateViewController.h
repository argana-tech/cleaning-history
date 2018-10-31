//
//  UpdateViewController.h
//  CleanManageSystem
//
//  Created by akifumin on 2014/01/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic)  NSError *updateError;
@end
