//
//  RecentActivityTableViewCell.m
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import "RecentActivityTableViewCell.h"
#import "UIColor+FlatUI.h"
#import "Constants.h"

@implementation RecentActivityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSString* nibName = nil;
         if([Constants isDeviceiPad]) {
             nibName = @"RecentActivityiPadTableViewCell";
         } else {
             nibName = @"RecentActivityTableViewCell";
         }
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName
                                                       owner:self
                                                     options:nil];
        UIView *viewOnContentView = [views objectAtIndex:0];
        viewOnContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.frame = viewOnContentView.bounds;
        
        self.userName.adjustsFontSizeToFitWidth = YES;
        
        self.activityName.adjustsFontSizeToFitWidth = YES;
        self.activityName.textColor = [UIColor lightBlueColor];
        
        self.createdAt.adjustsFontSizeToFitWidth = YES;
        self.scopeId.adjustsFontSizeToFitWidth = YES;
        self.value.adjustsFontSizeToFitWidth = YES;
        

        
        [self.contentView addSubview:viewOnContentView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    
    
}

@end
