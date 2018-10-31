//
//  ScopeScanCell.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/12.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScopeScanCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dispLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *scanTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *scanButton;
@end
