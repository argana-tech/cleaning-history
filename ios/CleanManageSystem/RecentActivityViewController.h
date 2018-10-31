//
//  RecentActivityViewController.h
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/11.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentActivityDto.h"
#import "ActivityDeleteInfo.h"

@interface RecentActivityViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
ActivityDeleteInfoDelegate
>

@property (nonatomic) RecentActivityDto* recentActivityDto;

@end
