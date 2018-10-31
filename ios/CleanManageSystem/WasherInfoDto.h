//
//  WasherInfoDto.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/13.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WasherInfoDto : NSObject

@property (nonatomic) NSString* code;
@property (nonatomic) NSString* type;
@property (nonatomic) NSString* solution;
@property (nonatomic) NSString* location;
@property (nonatomic) NSString* alertMessage;
@property (nonatomic) NSString* washerId;
@property (nonatomic) NSString* createdAt;
@property (nonatomic) NSString* updatedAt;

@property (nonatomic) NSInteger tag;
@property (nonatomic) BOOL isEnable;

+ (WasherInfoDto*) create : (NSDictionary*) washerInfoDictionary;
-(UITableViewCell*) getWasherInfoCell: (int)dispWasherInfoCount cellIdentifier:(NSString*)cellIdentifier;
- (int) rowCount;

@end
