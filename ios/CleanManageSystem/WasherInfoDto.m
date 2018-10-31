//
//  WasherInfoDto.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/13.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "WasherInfoDto.h"


#define CODE @"code"
#define TYPE @"type"
#define SOLUTION @"solution"
#define LOCATION @"location"
#define ALERT_MESSAGE @"alert_message"
#define WASHER_ID @"id"
#define CREATED_AT @"created_at"
#define UPDATED_AT @"updated_at"


@implementation WasherInfoDto

+ (WasherInfoDto*) create : (NSDictionary*) washerInfoDictionary {
    
    WasherInfoDto *washerInfoDto = [WasherInfoDto new];
    washerInfoDto.code = washerInfoDictionary[CODE];
    washerInfoDto.type = washerInfoDictionary[TYPE];
    washerInfoDto.solution = washerInfoDictionary[SOLUTION];
    washerInfoDto.code = washerInfoDictionary[LOCATION];
    washerInfoDto.alertMessage = washerInfoDictionary[ALERT_MESSAGE];
    washerInfoDto.washerId = washerInfoDictionary[WASHER_ID];
    washerInfoDto.createdAt = washerInfoDictionary[CREATED_AT];
    washerInfoDto.updatedAt = washerInfoDictionary[UPDATED_AT];
    return washerInfoDto;
    
    
}

-(UITableViewCell*) getWasherInfoCell: (int)dispWasherInfoCount cellIdentifier:(NSString*)cellIdentifier {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"洗浄種別:「%@」", self.type];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (int) rowCount {
    return 1;
}


@end
