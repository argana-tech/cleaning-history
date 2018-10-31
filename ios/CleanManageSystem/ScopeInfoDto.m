//
//  ScopeInfoDto.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/09.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "ScopeInfoDto.h"
#import "UIColor+FlatUI.h"

#define ACTION_ID @"action_id"
#define STAFFM_SH_ID @"staffm_sh_id"
#define STAFFM_SH_NAME @"staffm_sh_name"
#define STAFFM_KA_NAME @"staffm_ka_name"
#define STAFFM_BYOTO_NAME @"staffm_byoto_name"
#define SCOPE_ID @"scope_id"
#define ACTION_COMPLETED_AT @"action_completed_at"
#define ID @"id"
#define ACTION_NAME @"action_name"
#define DEVICE @"device"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"
#define ELAPSED @"elapsed"

#define CLEAN_ACTION_NAME @"洗浄・消毒終了"

@implementation ScopeInfoDto


+ (ScopeInfoDto*) create : (NSDictionary*) scopeInfoDictionary {
    ScopeInfoDto* scopeInfoDto = [ScopeInfoDto new];
    
    scopeInfoDto.actionId = scopeInfoDictionary[ACTION_ID];
    scopeInfoDto.staffmShId = scopeInfoDictionary[STAFFM_SH_ID];
    scopeInfoDto.staffmShName = scopeInfoDictionary[STAFFM_SH_NAME];
    scopeInfoDto.staffmKaName = scopeInfoDictionary[STAFFM_KA_NAME];
    scopeInfoDto.staffmByotoName = scopeInfoDictionary[STAFFM_BYOTO_NAME];
    scopeInfoDto.scopeId = scopeInfoDictionary[SCOPE_ID];
    scopeInfoDto.actionCompletedAt = scopeInfoDictionary[ACTION_COMPLETED_AT];
    scopeInfoDto.scopeInfoId = scopeInfoDictionary[ID];
    scopeInfoDto.actionName = scopeInfoDictionary[ACTION_NAME];
    scopeInfoDto.device = scopeInfoDictionary[DEVICE];
    scopeInfoDto.createdAt = scopeInfoDictionary[CREATED_AT];
    scopeInfoDto.updatedAt = scopeInfoDictionary[UPDATED_AT];
    scopeInfoDto.elapsed = scopeInfoDictionary[ELAPSED];
    
    
    return scopeInfoDto;
    
}

-(UITableViewCell*) getScopeInfoCell: (int)dispScopeInfoCount cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSString* text;
    
    if (self.scopeId) {
        text = [NSString stringWithFormat:@"「%@」の履歴から%@", self.actionName, self.elapsed ];
    } else {
        text = self.errorMessage;
        cell.textLabel.textColor = [UIColor colorFromHexCode:@"#ff7f7f"];
    }
    
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BOOL) isCleaned {
    if (0 < [self.elapsed length]) {
        return YES;
    } else {
        return NO;
    }
}

- (int) rowCount {
    
    if ([self isCleaned]) {
        return 1;
    } else {
        return 1;
    }
    
}
@end
