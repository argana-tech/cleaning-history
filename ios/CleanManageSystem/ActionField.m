//
//  ActionField.m
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/10/09.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import "ActionField.h"
#import "Constants.h"

@implementation ActionField

+(ActionField*)create:(NSDictionary*)field {
    
    ActionField *actionField = [ActionField new];
    
    actionField.fieldId = [[ActionField getValue:field objectForKey:FIELDS_ID] intValue];
    actionField.require = [[ActionField getValue:field objectForKey:FIELDS_IS_REQUIRE] boolValue];
    actionField.name = [ActionField getValue:field objectForKey:FIELDS_NAME];
    actionField.maxLength = (NSNumber*)[ActionField getValue:field objectForKey:FIELDS_MAX_LENGTH];
    actionField.minLength = (NSNumber*)[ActionField getValue:field objectForKey:FIELDS_MIN_LENGTH];
    actionField.regexp = [ActionField getValue:field objectForKey:FIELDS_REGEXP] ;
    actionField.type = [ActionField getValue:field objectForKey:FIELDS_TYPE];
    actionField.isPatientId = [[ActionField getValue:field objectForKey:FIELDS_IS_PATIENT_ID_FIELD] boolValue];
    actionField.isScope = NO;
    actionField.isWasherId = [[ActionField getValue:field objectForKey:FIELDS_IS_WASHER_ID_FIELD] boolValue];

    
    return actionField;
}

+(id) getValue:(NSDictionary*)field  objectForKey:(NSString*)objectForKey {
    NSObject* value = [field objectForKey:objectForKey];
    
    if (value == [NSNull null]) {
        return nil;
    } else {
        return value;
    }
    
}

+(ActionField*) scopeField {
    
    ActionField *actionField = [ActionField new];
    
    actionField.fieldId = -1;
    actionField.require = 1;
    actionField.name = @"スコープID";
    actionField.maxLength = nil;
    actionField.minLength = nil;
    actionField.regexp = nil ;
    actionField.type = FIELDS_TYPE_BARCODE;
    actionField.isScope = YES;
    return actionField;
}

@end
