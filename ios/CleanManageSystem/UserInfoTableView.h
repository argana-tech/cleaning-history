//
//  UserInfoTableView.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/16.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "LabelCell.h"



@interface UserInfoTableView : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *userInfoView;

-(void)setData;


@end
