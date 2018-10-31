//
//  Constants.h
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/10/09.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>



#define API_URL @"http://192.168.8.99/cleaning-history.git"

#define API_LOGIN_URL @"/api/login.json"
#define API_LOGOUT_URL @"/api/logout.json"
#define API_LIST_ACTIONS_URL @"/api/list_actions.json"
#define API_PATIENT @"/api/patient/"
#define API_SCOPE @"/api/scope/"
#define API_WASHER @"/api/washer/"
#define API_ACTIVITY_REMOVE @"/api/activity/remove.json"
#define API_RECENT_ACTIVITY @"/api/recent_activity"

// アプリバージョンチェックテキスト
#define API_VERSION_TXT @"/version.txt"


#define PRM_SCOPE_ID @"scope_id"
#define PRM_CIS_NAME @"cis_name"
#define PRM_CIS_ID @"cis_id"
#define PRM_STAFFM_SH_ID @"staffm_sh_id"
#define PRM_STAFFM @"staffm"


#define PRM_CIS_PW @"cis_pw"
#define PRM_ACTION_ID @"action_id"
#define PRM_ACTIVITY_ID @"activity_id"
#define PRM_AUTH_KEY @"auth_key"

// login error
#define LOGIN_ERROR_UNKOWN_CIS_USER @"unkown cis user"
#define ERROR_REQUIRE_AUTHOLOIZE @"require autholize."

#define ACTION @"action"

// fields
#define FIELDS @"fields"
#define FIELDS_ID @"id"
#define FIELDS_IS_REQUIRE @"is_required"
#define FIELDS_NAME @"name"
#define FIELDS_MAX_LENGTH @"string_length_max"
#define FIELDS_MIN_LENGTH @"string_length_min"
#define FIELDS_REGEXP @"string_regexp"
#define FIELDS_TYPE @"type"
#define FIELDS_TYPE_BARCODE @"barcode"
#define FIELDS_TYPE_INPUT @"input"
#define FIELDS_TYPE_BOOLEAN @"boolean"
#define FIELDS_IS_PATIENT_ID_FIELD @"is_patient_id_field"
#define FIELDS_IS_WASHER_ID_FIELD @"is_washer_id_field"
#define FIELDS_PATIENT_DATA @"patient_data"
//patient
#define PATIENT @"patient"
#define PATIENT_RESULT @"result"

// save
// 保存完了メッセージ
#define SAVED_MESSAGE @"saved_message"
// 経過日数を計算した結果
#define SAVED_ELAPSED_MESSAGE @"elapsed_message"
#define SAVED_INVALID_LAST_ACTION @"invalid_last_action"

#define ERROR @"error"
#define ERRORS @"errors"
#define ERRORS_VALIDATE_LAST_ACTION @"validate_last_action"

// 1ならエラー、2なら確認
#define VALIDATE_LAST_ACTION_ERROR 1
#define VALIDATE_LAST_ACTION_CONFIRM 2

#define ACTIVITY @"activity"
#define ACTIVITY_ID @"id"
#define ACTIVITY_SCOPE_ID @"scope_id"
#define ACTIVITY_ACTION_NAME @"action_name"

#define ACTIVITY_CREATED_AT @"created_at"
// 登録日時
#define ACTIVITY_ACTION_COMPLETED_AT @"action_completed_at"
#define ACTIVITY_FIELDS @"fields"
#define ACTIVITY_FIELDS_NAME @"name"
#define ACTIVITY_FIELDS_VALE @"value"
#define ACTIVITY_ACTIVITY_FIELDS @"activity_fields"



#define ACTIONS @"actions"
#define ACTIONS_ID @"id"
#define ACTIONS_NAME @"name"

#define CIS_DATA @"cis_data"
#define CIS_DATA_ID @"id"
#define CIS_DATA_NAME @"name"

//
#define POST_DATA @"post_data"
#define POST_DATA_USER_ID @"userId"
#define POST_DATA_USER_NAME @"userName"
#define POST_DATA_PASSWORD @"password"[

// iPad
#define TABLE_CELL_WIDTH 320
#define IPAD_COEFFCIENT 1.5
#define IPHONE_DEFAULT_FONT_SIZE 17
#define IPAD_DEFAULT_FONT_SIZE 32

@interface Constants : NSObject
+ (SystemSoundID) getScanSoundID;
+ (BOOL) isDeviceiPad;
+ (CGFloat) getiPadOffset;


#pragma mark - ipad size
+ (float) getiPhoneValue:(float)iPhoneValue iPadCoeffcient: (float)iPadCoeffcient;
+ (float) getiPhoneValue : (float) value iPadValue:(float)iPadValue;
+ (UIFont*) getFont;
@end
