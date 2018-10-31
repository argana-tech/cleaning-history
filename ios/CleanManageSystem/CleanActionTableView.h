//
//  CleanActionTableViewDelegate.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/19.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CleanActionTableView : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *claenActionTableView;

-(void)setData;

@end
