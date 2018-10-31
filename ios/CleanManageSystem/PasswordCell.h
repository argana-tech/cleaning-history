//
//  PasswordCell.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/12.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *passwordTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dispLabel;
@end
