//
//  RecentActivityDto.h
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentActivityDto : NSObject
+ (NSMutableArray*) createArrayDto:(NSDictionary*)dictionay;

@property (nonatomic) NSString* id_;
@property (nonatomic) NSString* scopeId;
@property (nonatomic) NSString* actionId;
@property (nonatomic) NSString* actionName;


@property (nonatomic) NSString* device;
@property (nonatomic) NSString* hasEveCheckError;

@property (nonatomic) NSString* staffmByotoName;
@property (nonatomic) NSString* staffmKaName;
@property (nonatomic) NSString* staffmShId;
@property (nonatomic) NSString* staffmShName;

@property (nonatomic) NSString* actionCompletedAt;
@property (nonatomic) NSString* updatedAt;
@property (nonatomic) NSString* createdAt;

@property (nonatomic) NSArray* activityFields;
@end
