//
//  ScopeInfoDto.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/09.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScopeInfoDto : NSObject

@property (nonatomic) NSString* actionId;
@property (nonatomic) NSString* staffmShId;
@property (nonatomic) NSString* staffmShName;
@property (nonatomic) NSString* staffmKaName;
@property (nonatomic) NSString* staffmByotoName;
@property (nonatomic) NSString* scopeId;
@property (nonatomic) NSString* actionCompletedAt;
@property (nonatomic) NSString* scopeInfoId;
@property (nonatomic) NSString* actionName;
@property (nonatomic) NSString* device;
@property (nonatomic) NSString* createdAt;
@property (nonatomic) NSString* updatedAt;
@property (nonatomic) NSString* elapsed;

//
@property (nonatomic) NSInteger tag;
@property (nonatomic) BOOL isEnable;

//
@property (nonatomic) NSString* errorMessage;

+ (ScopeInfoDto*) create : (NSDictionary*) scopeInfoDictionary;
-(UITableViewCell*) getScopeInfoCell: (int)dispScopeInfoCount cellIdentifier:(NSString*)cellIdentifier;
- (int) rowCount;

@end
