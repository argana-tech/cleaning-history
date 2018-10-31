//
//  User.h
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/10/09.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject

-(void) loginURLSchem :  (NSString*)userId userName:(NSString*)userName authKey:(NSString*)authKey staffInfo : (NSDictionary*)staffInfo;
-(void) login :  (NSString*)userId userName:(NSString*)userName authKey:(NSString*)authKey staffInfo : (NSDictionary*)staffInfo;

-(void) logout;

+ (User*) getInstance;
- (BOOL) isloginTypeURLSchem;

@property (nonatomic) BOOL isLogin;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *passWord;
@property (nonatomic) NSString *authKey;
@property (nonatomic) NSDate *lastActionDate;

@property (nonatomic) NSString* activeFlg;
@property (nonatomic) NSString* byotoCd;
@property (nonatomic) NSString* byotoName;
@property (nonatomic) NSString* idmNo;
@property (nonatomic) NSString* kaCd;
@property (nonatomic) NSString* kaName;
@property (nonatomic) NSString* lastDate;
@property (nonatomic) NSString* lastOpId;
@property (nonatomic) NSString* lastTime;
@property (nonatomic) NSString* password;
@property (nonatomic) NSString* pwUpdateDate;
@property (nonatomic) NSString* shEdDate;
@property (nonatomic) NSString* shId;
@property (nonatomic) NSString* shKanaName;
@property (nonatomic) NSString* shName;
@property (nonatomic) NSString* shStDate;
@property (nonatomic) NSString* shType;
@property (nonatomic) NSString* shTypeNm;
@property (nonatomic) NSString* tel1;
@property (nonatomic) NSString* tel2;


@end
