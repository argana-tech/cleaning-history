//
//  ActivityField.h
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatInfoDto.h"

@interface ActivityFieldDto : NSObject


@property (nonatomic) NSString* actionFieldId;
@property (nonatomic) NSString* actionFieldName;
@property (nonatomic) NSString* activityId;
@property (nonatomic) NSString* id_;
@property (nonatomic) NSString* isPatientIdField;
@property (nonatomic) NSString* isWasherIdField;
@property (nonatomic) PatInfoDto* patientData;
@property (nonatomic) NSString* value;
@property (nonatomic) NSString* washerData;

+ (NSMutableArray*) createArray:(NSDictionary*) dic;

@end
