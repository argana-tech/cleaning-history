//
//  SearchScopeInfo.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/09.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScopeInfoDto;

@protocol  SearchScopeInfoDelegate;

@interface SearchScopeInfo : NSObject


@property (nonatomic, weak) id<SearchScopeInfoDelegate> delegate;

-(void) searchScopeId: (NSString*)scopeId actionId : (int)actionId tag:(NSInteger)_tag ;

@end


@protocol SearchScopeInfoDelegate <NSObject>

-(void) searchScopeInfoResult : (ScopeInfoDto*) patInfoDto errorMessage:(NSString*)errorMessage ;

@end