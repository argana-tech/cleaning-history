//
//  RecentActivityDto.m
//  CleanManageSystem
//
//  Created by akifumin on 2014/09/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import "RecentActivityDto.h"
#import "ActivityFieldDto.h"

#define ACTION_ID @"action_id"
#define ACTION_NAME @"action_name"
#define ACTIVITY_FIELDS @"activity_fields"

#define DEVICE @"device"
#define HAS_EVE_CHECK_ERROR @"has_eve_check_error"
#define ID_ @"id"
#define SCOPE_ID @"scope_id"
#define STAFFM_BYOTO_NAME @"staffm_byoto_name"
#define STAFFM_KA_NAME @"staffm_ka_name"
#define STAFFM_SH_ID @"staffm_sh_id"
#define STAFFM_SH_NAME @"staffm_sh_name"
#define ACTION_COMPLATED_AT @"action_completed_at"
#define UPDATED_AT @"updated_at"
#define CREATED_AT @"created_at"

@implementation RecentActivityDto

+ (NSMutableArray*) createArrayDto:(NSDictionary*)dictionay {
    
    NSMutableArray* result = [@[] mutableCopy];
    for (NSDictionary* activity in dictionay) {
        [result addObject:[RecentActivityDto createDto:activity]];
    }
    
    return result;
}


+ (RecentActivityDto*) createDto : (NSDictionary*) activity {
    RecentActivityDto* dto = [RecentActivityDto new];
    
    dto.actionId = activity[ACTION_ID];
    dto.actionName = activity[ACTION_NAME];

    
    dto.device = activity[DEVICE];
    dto.hasEveCheckError = activity[HAS_EVE_CHECK_ERROR];
    dto.id_ = activity[ID_];
    dto.scopeId = activity[SCOPE_ID];
    dto.staffmByotoName = activity[STAFFM_BYOTO_NAME];
    dto.staffmKaName = activity[STAFFM_KA_NAME];
    dto.staffmShId = activity[STAFFM_SH_ID];
    dto.staffmShName = activity[STAFFM_SH_NAME];
    dto.actionCompletedAt = activity[ACTION_COMPLATED_AT];
    dto.updatedAt = activity[UPDATED_AT];
    dto.createdAt = activity[CREATED_AT];
    
    dto.activityFields = [ActivityFieldDto createArray:activity[ACTIVITY_FIELDS]];
    
    return dto;
}
@end
