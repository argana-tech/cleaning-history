//
//  ActivityField.m
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import "ActivityFieldDto.h"

#define ACTION_FIELD_ID @"action_field_id"
#define ACTION_FIELD_NAME @"action_field_name"
#define ACTIVITY_ID @"activity_id"
#define ID_ @"id"
#define IS_PATIENT_ID_FIELD @"is_patient_id_field"
#define IS_WASHER_ID_FIELD @"is_washer_id_field"
#define PATIENT_DATA @"patient_data"
#define VALUE @"value"
#define WASHER_DATA @"washer_data"


@implementation ActivityFieldDto



+ (NSMutableArray*) createArray:(NSDictionary*) dic {
    NSMutableArray* result = [@[] mutableCopy];
    for (NSDictionary* key in dic) {
        NSDictionary* field = dic[key];
        [result addObject:[ActivityFieldDto createDto:field]];
    }
    
    return result;
}

+ (ActivityFieldDto*) createDto:(NSDictionary*)field {
    
    ActivityFieldDto* dto = [ActivityFieldDto new];
    
    dto.actionFieldId = field[ACTION_FIELD_ID];
    dto.actionFieldName = field[ACTION_FIELD_NAME];
    dto.activityId = field[ACTIVITY_ID];
    dto.id_ = field[ID_];
    dto.isPatientIdField = field[IS_PATIENT_ID_FIELD];
    dto.isWasherIdField = field[IS_WASHER_ID_FIELD];
    NSDictionary* patientDic = field[PATIENT_DATA];
    if ([patientDic class] != [NSNull class]) {
        dto.patientData = [PatInfoDto create: patientDic];
    }
    dto.value = field[VALUE];
    dto.washerData = field[WASHER_DATA];
    
    
    return dto;
    
}
@end
