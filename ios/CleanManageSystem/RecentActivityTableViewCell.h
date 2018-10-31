//
//  RecentActivityTableViewCell.h
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UILabel *scopeId;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
