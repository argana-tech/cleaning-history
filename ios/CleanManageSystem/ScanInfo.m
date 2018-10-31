//
//  ScanInfo.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/19.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "ScanInfo.h"
#define SCAN_INFO_KEY @"SCAN_INFO_KEY"

@implementation ScanInfo
@synthesize scopeId, patientId, cleanType;


+(ScanInfo*) getScanInfo {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    ScanInfo *scanInfo  =[NSKeyedUnarchiver unarchiveObjectWithData: [userDefault objectForKey:SCAN_INFO_KEY]];
    return scanInfo;
}



//
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        scopeId = [decoder decodeObjectForKey:@"scopeId"];
        patientId = [decoder decodeObjectForKey:@"patientId"];
        cleanType = [decoder decodeObjectForKey:@"cleanType"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:scopeId forKey:@"scopeId"];
    [encoder encodeObject:patientId forKey:@"patientId"];
    [encoder encodeObject:cleanType forKey:@"cleanType"];
    
}

// 

@end
