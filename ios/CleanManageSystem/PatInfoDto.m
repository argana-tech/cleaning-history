//
//  PatInfoDto.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/11/26.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "PatInfoDto.h"
#import "Constants.h"

// 【TKANJA】
#define COL_CD @"COL_CD"
#define LAST_DATE @"LAST_DATE"
#define LAST_OP_ID @"LAST_OP_ID"
#define LAST_TIME @"LAST_TIME"
#define NYUIN_NUM @"NYUIN_NUM"
#define PAST_KJ_LGNAME @"PAST_KJ_LGNAME"
#define PAST_KN_LGNAME @"PAST_KN_LGNAME"
#define PAST_KN_NAME @"PAST_KN_NAME"
#define PAST_NAME @"PAST_NAME"
#define PT_ADDR @"PT_ADDR"
#define PT_ADDR_CD @"PT_ADDR_CD"
#define PT_BADDR @"PT_BADDR"
#define PT_BADDR_CD @"PT_BADDR_CD"
#define PT_BIRTH @"PT_BIRTH"
#define PT_CONTRY @"PT_CONTRY"
#define PT_FI_DT @"PT_FI_DT"
#define PT_FLG1 @"PT_FLG1"
#define PT_FLG2 @"PT_FLG2"
#define PT_FLG3 @"PT_FLG3"
#define PT_FLG4 @"PT_FLG4"
#define PT_FLG5 @"PT_FLG5"
#define PT_FST_NAME @"PT_FST_NAME"
#define PT_HN_NAME @"PT_HN_NAME"
#define PT_ID @"PT_ID"
#define PT_KJ_LGNAME @"PT_KJ_LGNAME"
#define PT_KJ_NAME @"PT_KJ_NAME"
#define PT_KN_LGNAME @"PT_KN_LGNAME"
#define PT_KN_NAME @"PT_KN_NAME"
#define PT_LADDR @"PT_LADDR"
#define PT_LADDR_CD @"PT_LADDR_CD"
#define PT_LST_NAME @"PT_LST_NAME"
#define PT_MDL_NAME @"PT_MDL_NAME"
#define PT_RNRK_KBN @"PT_RNRK_KBN"
#define PT_RNRK_TEL @"PT_RNRK_TEL"
#define PT_SEX @"PT_SEX"
#define PT_STATUS @"PT_STATUS"
#define PT_TEL @"PT_TEL"
#define PT_ZIP @"PT_ZIP"
#define SAME_NAME_FLG @"SAME_NAME_FLG"
#define S_HOKEN @"S_HOKEN"


/*
【VE05NLST】
#define BED_CD @"BED_CD"
#define BED_NM @"BED_NM"
#define BYOTO_CD @"BYOTO_CD"
#define CHG_DATE @"CHG_DATE"
#define ENT_DATE @"ENT_DATE"
#define FZI_FLG @"FZI_FLG"
#define GHK_ED_DT @"GHK_ED_DT"
#define GHK_ED_TM @"GHK_ED_TM"
#define GHK_KBN @"GHK_KBN"
#define GHK_ST_DT @"GHK_ST_DT"
#define GHK_ST_TM @"GHK_ST_TM"
#define KA_CD @"KA_CD"
#define KA_NAME_R @"KA_NAME_R"
#define KYUGO_KBN @"KYUGO_KBN"
#define LVE_PLN_DT @"LVE_PLN_DT"
#define LVE_PLN_KBN @"LVE_PLN_KBN"
#define NS_TEAM @"NS_TEAM"
#define NYUIN_DATE @"NYUIN_DATE"
#define NYUIN_TIME @"NYUIN_TIME"
#define OUT_DATE @"OUT_DATE"
#define PT_BIRTH @"PT_BIRTH"
#define PT_FLG5 @"PT_FLG5"
#define PT_ID @"PT_ID"
#define PT_KJ_NAME @"PT_KJ_NAME"
#define PT_KN_NAME @"PT_KN_NAME"
#define PT_SEX @"PT_SEX"
#define P_NS_ID @"P_NS_ID"
#define ROOM_CD @"ROOM_CD"
#define SR_KBN @"SR_KBN"
#define S_DR_ID @"S_DR_ID"
#define TUKI_FLG @"TUKI_FLG"
*/

@implementation PatInfoDto

+ (PatInfoDto*) create : (NSDictionary*)patInfoDictionary {
        PatInfoDto* patInfoDto = [PatInfoDto new];
    /*
    【VE05NLST】
    patInfoDto.bedCd = [patInfoDictionary objectForKey:BED_CD];
    patInfoDto.bedNm = [patInfoDictionary objectForKey:BED_NM];
    patInfoDto.byotoCd = [patInfoDictionary objectForKey:BYOTO_CD];
    patInfoDto.chgDate = [patInfoDictionary objectForKey:CHG_DATE];
    patInfoDto.entDate = [patInfoDictionary objectForKey:ENT_DATE];
    patInfoDto.fziFlg = [patInfoDictionary objectForKey:FZI_FLG];
    patInfoDto.ghkEdDt = [patInfoDictionary objectForKey:GHK_ED_DT];
    patInfoDto.ghkEdTm = [patInfoDictionary objectForKey:GHK_ED_TM];
    patInfoDto.ghkKbn = [patInfoDictionary objectForKey:GHK_KBN];
    patInfoDto.ghkStDt = [patInfoDictionary objectForKey:GHK_ST_DT];
    patInfoDto.ghkStTm = [patInfoDictionary objectForKey:GHK_ST_TM];
    patInfoDto.kaCd = [patInfoDictionary objectForKey:KA_CD];
    patInfoDto.kaNameR = [patInfoDictionary objectForKey:KA_NAME_R];
    patInfoDto.kyugoKbn = [patInfoDictionary objectForKey:KYUGO_KBN];
    patInfoDto.lvePlnDt = [patInfoDictionary objectForKey:LVE_PLN_DT];
    patInfoDto.lvePlnKbn = [patInfoDictionary objectForKey:LVE_PLN_KBN];
    patInfoDto.nsTeam = [patInfoDictionary objectForKey:NS_TEAM];
    patInfoDto.nyuinDate = [patInfoDictionary objectForKey:NYUIN_DATE];
    patInfoDto.nyuinTime = [patInfoDictionary objectForKey:NYUIN_TIME];
    patInfoDto.outDate = [patInfoDictionary objectForKey:OUT_DATE];
    patInfoDto.ptBirth = [patInfoDictionary objectForKey:PT_BIRTH];
    patInfoDto.ptFlg5 = [patInfoDictionary objectForKey:PT_FLG5];
    patInfoDto.ptId = [patInfoDictionary objectForKey:PT_ID];
    patInfoDto.ptKjName = [patInfoDictionary objectForKey:PT_KJ_NAME];
    patInfoDto.ptKnName = [patInfoDictionary objectForKey:PT_KN_NAME];
    patInfoDto.ptSex = [patInfoDictionary objectForKey:PT_SEX];
    patInfoDto.pNsId = [patInfoDictionary objectForKey:P_NS_ID];
    patInfoDto.roomCd = [patInfoDictionary objectForKey:ROOM_CD];
    patInfoDto.srKbn = [patInfoDictionary objectForKey:SR_KBN];
    patInfoDto.sDrId = [patInfoDictionary objectForKey:S_DR_ID];
    patInfoDto.tukiFlg = [patInfoDictionary objectForKey:TUKI_FLG];
    */
    
    //【TKANJA】
    patInfoDto.colCd = patInfoDictionary[COL_CD];
    patInfoDto.lastDate = patInfoDictionary[LAST_DATE];
    patInfoDto.lastOpId = patInfoDictionary[LAST_OP_ID];
    patInfoDto.lastTime = patInfoDictionary[LAST_TIME];
    patInfoDto.nyuinNum = patInfoDictionary[NYUIN_NUM];
    patInfoDto.pastKjLgname = patInfoDictionary[PAST_KJ_LGNAME];
    patInfoDto.pastKnLgname = patInfoDictionary[PAST_KN_LGNAME];
    patInfoDto.pastKnName = patInfoDictionary[PAST_KN_NAME];
    patInfoDto.pastName = patInfoDictionary[PAST_NAME];
    patInfoDto.ptAddr = patInfoDictionary[PT_ADDR];
    patInfoDto.ptAddrCd = patInfoDictionary[PT_ADDR_CD];
    patInfoDto.ptBaddr = patInfoDictionary[PT_BADDR];
    patInfoDto.ptBaddrCd = patInfoDictionary[PT_BADDR_CD];
    patInfoDto.ptBirth = patInfoDictionary[PT_BIRTH];
    patInfoDto.ptContry = patInfoDictionary[PT_CONTRY];
    patInfoDto.ptFiDt = patInfoDictionary[PT_FI_DT];
    patInfoDto.ptFlg1 = patInfoDictionary[PT_FLG1];
    patInfoDto.ptFlg2 = patInfoDictionary[PT_FLG2];
    patInfoDto.ptFlg3 = patInfoDictionary[PT_FLG3];
    patInfoDto.ptFlg4 = patInfoDictionary[PT_FLG4];
    patInfoDto.ptFlg5 = patInfoDictionary[PT_FLG5];
    patInfoDto.ptFstName = patInfoDictionary[PT_FST_NAME];
    patInfoDto.ptHnName = patInfoDictionary[PT_HN_NAME];
    patInfoDto.ptId = patInfoDictionary[PT_ID];
    patInfoDto.ptKjLgname = patInfoDictionary[PT_KJ_LGNAME];
    patInfoDto.ptKjName = patInfoDictionary[PT_KJ_NAME];
    patInfoDto.ptKnLgname = patInfoDictionary[PT_KN_LGNAME];
    patInfoDto.ptKnName = patInfoDictionary[PT_KN_NAME];
    patInfoDto.ptLaddr = patInfoDictionary[PT_LADDR];
    patInfoDto.ptLaddrCd = patInfoDictionary[PT_LADDR_CD];
    patInfoDto.ptLstName = patInfoDictionary[PT_LST_NAME];
    patInfoDto.ptMdlName = patInfoDictionary[PT_MDL_NAME];
    patInfoDto.ptRnrkKbn = patInfoDictionary[PT_RNRK_KBN];
    patInfoDto.ptRnrkTel = patInfoDictionary[PT_RNRK_TEL];
    patInfoDto.ptSex = patInfoDictionary[PT_SEX];
    patInfoDto.ptStatus = patInfoDictionary[PT_STATUS];
    patInfoDto.ptTel = patInfoDictionary[PT_TEL];
    patInfoDto.ptZip = patInfoDictionary[PT_ZIP];
    patInfoDto.sameNameFlg = patInfoDictionary[SAME_NAME_FLG];
    patInfoDto.sHoken = patInfoDictionary[S_HOKEN];
    
    return patInfoDto;
}

-(UITableViewCell*) getPatInfoCell: (int)dispPatInfoCount cellIdentifier:(NSString*)cellIdentifier addHeadString:(NSString*)addHeadString {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    NSString* text;
    NSString* value;
    
    if ([addHeadString length] < 1) {
        addHeadString = @"";
    }
    
    if (dispPatInfoCount == 0) {
        text = [addHeadString stringByAppendingString: @"氏名"];
        value = self.ptKjName;
    } else if (dispPatInfoCount == 1) {
        text = [addHeadString stringByAppendingString: @"カナ"];
        value = self.ptKnName;
    }
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = value;
    cell.textLabel.font = [UIFont systemFontOfSize:[Constants getiPhoneValue:15 iPadValue:30 ]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:[Constants getiPhoneValue:15 iPadValue:30 ]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - 患者情報のセルを作成する
-(UITableViewCell*) getPatInfoCell: (int)dispPatInfoCount cellIdentifier:(NSString*)cellIdentifier {
    return [self getPatInfoCell:dispPatInfoCount cellIdentifier:cellIdentifier addHeadString:@""];
}

- (int) rowCount {
    return 8;
}

@end
