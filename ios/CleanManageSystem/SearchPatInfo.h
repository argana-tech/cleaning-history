//
//  SearchPatInfo.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/11/26.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatInfoDto.h"

@protocol SearchPatInfoDelegate;

@interface SearchPatInfo : NSObject

@property (nonatomic, weak) id<SearchPatInfoDelegate> delegate;

-(void) searchPatId: (NSString*)patId  tag:(NSInteger)_tag ;

@end

@protocol SearchPatInfoDelegate <NSObject>

-(void) searchPatInfoResult : (PatInfoDto*) patInfoDto errorMessage:(NSString*)errorMessage ;

@end

