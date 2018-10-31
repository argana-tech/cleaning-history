CREATE TABLE IF NOT EXISTS `staffm` (
  `sh_id` CHAR(8) NOT NULL COMMENT '職員ID',
  `sh_st_date` CHAR(8) NOT NULL COMMENT '有効開始日(YYYYMMDD)',
  `sh_ed_date` CHAR(8) NOT NULL COMMENT '有効終了日(YYYYMMDD)',
  `active_flg` CHAR(1) NOT NULL DEFAULT '1' COMMENT 'アクティブフラグ(0:INACTIVE,1:ACTIVE)',
  `sh_name` CHAR(20) NOT NULL COMMENT '職員名',
  `sh_kana_name` CHAR(20) NOT NULL COMMENT 'カナ氏名',
  `sh_type` CHAR(4) NOT NULL COMMENT '職種コード',
  `sh_type_nm` CHAR(20) NOT NULL COMMENT '職種名',
  `ka_cd` CHAR(3) NULL COMMENT '診療科コード',
  `ka_name` CHAR(20) NULL COMMENT '診療科名称',
  `byoto_cd` CHAR(3) NULL COMMENT '病棟コード',
  `byoto_name` CHAR(20) NULL COMMENT '病棟名',
  `user_id` CHAR(8) NOT NULL COMMENT 'ユーザーID',
  `password` CHAR(14) NOT NULL COMMENT 'パスワード',
  `pw_update_date` CHAR(8) NULL COMMENT 'パスワード更新日(YYYYMMDD)',
  `idm_no` CHAR(20) NULL COMMENT 'ICカードの固有番号',
  `tel1` CHAR(15) NULL COMMENT '内線番号',
  `tel2` CHAR(15) NULL COMMENT 'ポケベル、PHSの番号',
  `last_op_id` CHAR(8) NULL COMMENT '最終更新者',
  `last_date` CHAR(8) NULL COMMENT '最終更新日(YYYYMMDD)',
  `last_time` CHAR(8) NULL COMMENT '最終更新時刻(HHMMSS)',
  UNIQUE INDEX `staffm_sh_id` (`sh_id`, `sh_st_date`)
)Engine=InnoDB DEFAULT CHARACTER SET utf8;
