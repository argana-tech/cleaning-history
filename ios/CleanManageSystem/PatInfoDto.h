//
//  PatInfoDto.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/11/26.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DISP_PAT_INFO_ROW_COUNT 2

@interface PatInfoDto : NSObject

/*
 
【VE05NLST】
 カナ氏名: PT_KN_NAME
 氏名: PT_KJ_NAME
 診療科コード: KA_CD
 略称診療科名: KA_NAME_R
 病棟コード: BYOTO_CD
 病室コード: ROOM_CD
 病床コード: BED_CD
 病床名称: BED_NM
 
// 病床コード
@property (nonatomic) NSString* bedCd;
// 病床名称
@property (nonatomic) NSString* bedNm;
// 病棟コード
@property (nonatomic) NSString* byotoCd;
@property (nonatomic) NSString* chgDate;
@property (nonatomic) NSString* entDate;
@property (nonatomic) NSString* fziFlg;
@property (nonatomic) NSString* ghkEdDt;
@property (nonatomic) NSString* ghkEdTm;
@property (nonatomic) NSString* ghkKbn;
@property (nonatomic) NSString* ghkStDt;
@property (nonatomic) NSString* ghkStTm;
// 診療科コード
@property (nonatomic) NSString* kaCd;
// 略称診療科名
@property (nonatomic) NSString* kaNameR;
@property (nonatomic) NSString* kyugoKbn;
@property (nonatomic) NSString* lvePlnDt;
@property (nonatomic) NSString* lvePlnKbn;
@property (nonatomic) NSString* nsTeam;
@property (nonatomic) NSString* nyuinDate;
@property (nonatomic) NSString* nyuinTime;
@property (nonatomic) NSString* outDate;
@property (nonatomic) NSString* ptBirth;
@property (nonatomic) NSString* ptFlg5;
@property (nonatomic) NSString* ptId;
// 氏名
@property (nonatomic) NSString* ptKjName;
// カナ氏名
@property (nonatomic) NSString* ptKnName;
@property (nonatomic) NSString* ptSex;
@property (nonatomic) NSString* pNsId;
// 病室コード
@property (nonatomic) NSString* roomCd;
@property (nonatomic) NSString* srKbn;
@property (nonatomic) NSString* sDrId;
@property (nonatomic) NSString* tukiFlg;
*/

// 【TKANJA】
@property (nonatomic) NSString* colCd;
@property (nonatomic) NSString* lastDate;
@property (nonatomic) NSString* lastOpId;
@property (nonatomic) NSString* lastTime;
@property (nonatomic) NSString* nyuinNum;
@property (nonatomic) NSString* pastKjLgname;
@property (nonatomic) NSString* pastKnLgname;
@property (nonatomic) NSString* pastKnName;
@property (nonatomic) NSString* pastName;
@property (nonatomic) NSString* ptAddr;
@property (nonatomic) NSString* ptAddrCd;
@property (nonatomic) NSString* ptBaddr;
@property (nonatomic) NSString* ptBaddrCd;
@property (nonatomic) NSString* ptBirth;
@property (nonatomic) NSString* ptContry;
@property (nonatomic) NSString* ptFiDt;
@property (nonatomic) NSString* ptFlg1;
@property (nonatomic) NSString* ptFlg2;
@property (nonatomic) NSString* ptFlg3;
@property (nonatomic) NSString* ptFlg4;
@property (nonatomic) NSString* ptFlg5;
@property (nonatomic) NSString* ptFstName;
@property (nonatomic) NSString* ptHnName;
@property (nonatomic) NSString* ptId;
@property (nonatomic) NSString* ptKjLgname;
@property (nonatomic) NSString* ptKjName;
@property (nonatomic) NSString* ptKnLgname;
@property (nonatomic) NSString* ptKnName;
@property (nonatomic) NSString* ptLaddr;
@property (nonatomic) NSString* ptLaddrCd;
@property (nonatomic) NSString* ptLstName;
@property (nonatomic) NSString* ptMdlName;
@property (nonatomic) NSString* ptRnrkKbn;
@property (nonatomic) NSString* ptRnrkTel;
@property (nonatomic) NSString* ptSex;
@property (nonatomic) NSString* ptStatus;
@property (nonatomic) NSString* ptTel;
@property (nonatomic) NSString* ptZip;
@property (nonatomic) NSString* sameNameFlg;
@property (nonatomic) NSString* sHoken;

//  判定
@property (nonatomic) NSInteger tag;
@property (nonatomic) BOOL isEnable;

+ (PatInfoDto*) create : (NSDictionary*)patInfoDictionary;
-(UITableViewCell*) getPatInfoCell: (int)dispPatInfoCount cellIdentifier:(NSString*)cellIdentifier addHeadString:(NSString*)addHeadString;
-(UITableViewCell*) getPatInfoCell: (int)dispPatInfoCount cellIdentifier:(NSString*)cellIdentifier;
- (int) rowCount;
@end
