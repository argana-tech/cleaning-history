//
//  ActionDeleteInfo.h
//  CleanManageSystem
//
//  Created by akifumin on 2014/03/06.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActivityDeleteInfoDelegate;



@interface ActivityDeleteInfo : NSObject

// delegete
@property (weak) id<ActivityDeleteInfoDelegate> delegate;

- (void) activityDelete: (NSString*) activityId;

@end


#pragma mark - delegate
@protocol ActivityDeleteInfoDelegate <NSObject>

- (void) activityDeleteResult :(BOOL)result dadeleteIfnota:(NSDictionary*) deleteIfno errorMessage:(NSString*) errorMessage;

@end
