//
//  ScanInfo.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/19.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanInfo : NSObject<NSCoding>

@property (nonatomic) NSString* scopeId;
@property (nonatomic) NSString* patientId;
@property (nonatomic) NSString* cleanType;


+(ScanInfo*) getScanInfo;

@end
