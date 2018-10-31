//
//  User.m
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/10/09.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import "User.h"

#define ACTIVE_FLG @"active_flg"
#define BYOTO_CD @"byoto_cd"
#define BYOTO_NAME @"byoto_name"
#define IDM_NO @"idm_no"
#define KA_CD @"ka_cd"
#define KA_NAME @"ka_name"
#define LAST_DATE @"last_date"
#define LAST_OP_ID @"last_op_id"
#define LAST_TIME @"last_time"
#define PASSWORD @"password"
#define PW_UPDATE_DATE @"pw_update_date"
#define SH_ED_DATE @"sh_ed_date"
#define SH_ID @"sh_id"
#define SH_KANA_NAME @"sh_kana_name"
#define SH_NAME @"sh_name"
#define SH_ST_DATE @"sh_st_date"
#define SH_TYPE @"sh_type"
#define SH_TYPE_NM @"sh_type_nm"
#define TEL1 @"tel1"
#define TEL2 @"tel2"
#define USER_ID @"user_id"

enum LOGIN_TYPE {
    LOGIN_TYPE_UNKNOWN,
    LOGIN_TYPE_NORMAL,
    LOGIN_TYPE_URL_SCHEM
};
@implementation User {
    
    
    enum LOGIN_TYPE loginType;
    
}

static User *user = nil;

+ (User*) getInstance {
    static User* user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[User alloc] initSharedInstance];
    });
    return user;
}

- (id)initSharedInstance {
    self = [super init];
    if (self) {
        // 初期化処理
    }
    return self;
}

//- (id)initSharedInstance : (NSString)*userId userName:(NSString*)userName password:(NSString*)password authKey:(NSString*)authKey {
//    self = [super init];
//    if (self) {
//        self.userId = userId;
//    }
//    return self;
//}

- (BOOL) isloginTypeURLSchem {
    return loginType == LOGIN_TYPE_URL_SCHEM;
}

-(void) logout {
    self.isLogin = NO;
    self.userId = nil;
    self.userName = nil;
    self.passWord = nil;
    self.authKey = nil;
    self.lastActionDate = nil;
    
    self.activeFlg = nil;
    self.byotoCd = nil;
    self.byotoName = nil;
    self.idmNo = nil;
    self.kaCd = nil;
    self.kaName = nil;
    self.lastDate = nil;
    self.lastOpId = nil;
    self.lastTime = nil;
    self.password = nil;
    self.pwUpdateDate = nil;
    self.shEdDate = nil;
    self.shId = nil;
    self.shKanaName = nil;
    self.shName = nil;
    self.shStDate = nil;
    self.shType = nil;
    self.shTypeNm = nil;
    self.tel1 = nil;
    self.tel2 = nil;
    self.userId = nil;
}

-(void) loginURLSchem :  (NSString*)userId userName:(NSString*)userName authKey:(NSString*)authKey staffInfo : (NSDictionary*)staffInfo {
    [self commonLogin:userId userName:userName authKey:authKey staffInfo:staffInfo loginType:LOGIN_TYPE_URL_SCHEM];
}

-(void) login :  (NSString*)userId userName:(NSString*)userName authKey:(NSString*)authKey staffInfo : (NSDictionary*)staffInfo {
    [self commonLogin:userId userName:userName authKey:authKey staffInfo:staffInfo loginType:LOGIN_TYPE_NORMAL];
}


- (void) commonLogin :  (NSString*)userId userName:(NSString*)userName authKey:(NSString*)authKey staffInfo : (NSDictionary*)staffInfo loginType:(enum LOGIN_TYPE) _loginType {
    
    loginType = _loginType;
    
    self.isLogin = YES;
    
    self.userId = userId;
    self.userName = userName;
    self.authKey = authKey;
    
    self.lastActionDate = [NSDate date];
    
    self.activeFlg = staffInfo[ACTIVE_FLG];
    self.byotoCd = staffInfo[BYOTO_CD];
    self.byotoName = staffInfo[BYOTO_NAME];
    self.idmNo = staffInfo[IDM_NO];
    self.kaCd = staffInfo[KA_CD];
    self.kaName = staffInfo[KA_NAME];
    self.lastDate = staffInfo[LAST_DATE];
    self.lastOpId = staffInfo[LAST_OP_ID];
    self.lastTime = staffInfo[LAST_TIME];
    self.password = staffInfo[PASSWORD];
    self.pwUpdateDate = staffInfo[PW_UPDATE_DATE];
    self.shEdDate = staffInfo[SH_ED_DATE];
    self.shId = staffInfo[SH_ID];
    self.shKanaName = staffInfo[SH_KANA_NAME];
    self.shName = staffInfo[SH_NAME];
    self.shStDate = staffInfo[SH_ST_DATE];
    self.shType = staffInfo[SH_TYPE];
    self.shTypeNm = staffInfo[SH_TYPE_NM];
    self.tel1 = staffInfo[TEL1];
    self.tel2 = staffInfo[TEL2];
    
//    self.userId = staffInfo[USER_ID];
    
    
}


- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}



@end
