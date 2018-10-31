-- Table `cis`
DROP TABLE IF EXISTS `cis` ;

CREATE  TABLE IF NOT EXISTS `cis` (
  `id` VARCHAR(255) NOT NULL  ,
  `name` VARCHAR(255) NOT NULL ,
  `password` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

INSERT INTO `cis` VALUES
  ('0000000000', '管理者', 'admin')
 ,('0123123123', '鳥取 太郎', 'taro')
 ,('0456456456', '米子 次郎', 'jiro')
 ,('0789789789', '西町 花子', 'hanako')
;

