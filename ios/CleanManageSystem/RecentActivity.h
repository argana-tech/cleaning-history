//
//  RecentActivity.h
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RecentActivityDelegate;


@interface RecentActivity : NSObject

// delegete
@property (weak) id<RecentActivityDelegate> delegate;

- (void) search;

@end



#pragma mark - delegate
@protocol RecentActivityDelegate <NSObject>

- (void) recentActivityResult :(NSMutableArray*)recentActivities errorMessage:(NSString*) errorMessage;

@end
