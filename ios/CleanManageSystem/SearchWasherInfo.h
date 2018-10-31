//
//  SearchWasherInfo.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/13.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WasherInfoDto;

@protocol SearchWasherInfoDelegate;

@interface SearchWasherInfo : NSObject

@property (weak) id<SearchWasherInfoDelegate> delegate;

- (void) searchWahser: (NSString*) washerId tag:(NSInteger)_tag;

@end

@protocol SearchWasherInfoDelegate <NSObject>

- (void) searchWasherResult : (WasherInfoDto*) washerInfoDto errorMessage:(NSString*) errorMessage;

@end
