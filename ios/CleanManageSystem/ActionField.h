//
//  ActionField.h
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/10/09.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionField : NSObject

@property (nonatomic) int fieldId;
@property (nonatomic) BOOL require;
@property (nonatomic) NSString* name;
@property (nonatomic) NSNumber *maxLength;
@property (nonatomic) NSNumber *minLength;
@property (nonatomic) NSString* regexp;
@property (nonatomic) NSString* type;
@property (nonatomic) BOOL isPatientId;
@property (nonatomic) BOOL isScope;
@property (nonatomic) BOOL isWasherId;
@property (nonatomic) UITextField *textField;
@property (nonatomic) UISwitch *actionSwitch;

+(ActionField*)create:(NSDictionary*)field;
+(ActionField*) scopeField;

@end
