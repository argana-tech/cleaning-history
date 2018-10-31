-- Table `accounts`
DROP TABLE IF EXISTS `accounts` ;

CREATE  TABLE IF NOT EXISTS `accounts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `staffm_sh_id` VARCHAR(255) NOT NULL COMMENT '電子カルテ連携ID' ,
  `last_session_at` DATETIME NULL ,
  `last_session_remote_addr` VARCHAR(255) NULL ,
  `created_at` DATETIME NOT NULL ,
  `created_account_id` INT UNSIGNED NOT NULL ,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON  UPDATE CURRENT_TIMESTAMP ,
  `updated_account_id` INT UNSIGNED NOT NULL ,
  `removed_at` DATETIME NULL ,
  `removed_account_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE INDEX `i_accounts_staffm_sh_id` ON `accounts` (`staffm_sh_id` ASC) ;


-- Table `actions`
DROP TABLE IF EXISTS `actions` ;

CREATE  TABLE IF NOT EXISTS `actions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `validate_last_action` TINYINT NOT NULL DEFAULT 0 COMMENT '直前アクション制限回避(0:チェックしない、1: エラーにする、2: ユーザーに確認する)' ,
  `validate_last_action_id` INT NULL COMMENT '直前アクション制限のアクションID' ,
  `validate_last_action_error_message` VARCHAR(255) NULL COMMENT '直前アクションが異なっていた時のメッセージ' ,
  `created_at` DATETIME NOT NULL ,
  `created_account_id` INT UNSIGNED NOT NULL ,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `updated_account_id` INT UNSIGNED NOT NULL ,
  `removed_at` DATETIME NULL ,
  `removed_account_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- Table `action_fields`
DROP TABLE IF EXISTS `action_fields` ;

CREATE  TABLE IF NOT EXISTS `action_fields` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `action_id` INT UNSIGNED NOT NULL COMMENT '親となるアクションID' ,
  `name` VARCHAR(255) NOT NULL COMMENT '入力項目名' ,
  `is_required` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '必須項目(0: 任意、1: 必須)' ,
  `type` VARCHAR(255) NOT NULL COMMENT '入力方法(barcode: バーコード読み取り、string: 手入力、boolean: はい／いいえ)' ,
  `string_length_min` INT NULL COMMENT '最小文字数(タイプがバーコードか文字列の場合)' ,
  `string_length_max` INT NULL COMMENT '最大文字数(タイプがバーコードか文字列の場合)' ,
  `string_regexp` VARCHAR(255) NULL COMMENT '正規表現(タイプがバーコードか文字列の場合)' ,
  `priority` INT NOT NULL COMMENT 'アクション内での並び順' ,
  `tmp_id` VARCHAR(64) NULL COMMENT '管理画面でのランダムキー',
  `created_at` DATETIME NOT NULL ,
  `created_account_id` INT UNSIGNED NOT NULL ,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `updated_account_id` INT UNSIGNED NOT NULL ,
  `removed_at` DATETIME NULL ,
  `removed_account_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE INDEX `fk_action_fields_action_id` ON `action_fields` (`action_id` ASC) ;


-- Table `activities`
DROP TABLE IF EXISTS `activities` ;

CREATE  TABLE IF NOT EXISTS `activities` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `action_id` INT UNSIGNED NOT NULL ,
  `action_name` VARCHAR(255) NOT NULL COMMENT '実施した時のアクション名' ,
  `staffm_sh_id` VARCHAR(255) NOT NULL COMMENT '実施した担当者ID(電子カルテ連携担当者ID)' ,
  `cis_name` VARCHAR(255) NOT NULL COMMENT '担当者氏名' ,
  `scope_id` VARCHAR(255) NOT NULL ,
  `created_at` DATETIME NOT NULL ,
  `created_staffm_sh_id` VARCHAR(255) NOT NULL ,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `updated_staffm_sh_id` VARCHAR(255) NOT NULL ,
  `removed_at` DATETIME NULL ,
  `removed_staffm_sh_id` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE INDEX `i_activities_staffm_sh_id` ON `activities` (`staffm_sh_id` ASC) ;

CREATE INDEX `fk_activities_action_id` ON `activities` (`action_id` ASC) ;

CREATE INDEX `i_activities_scope_id` ON `activities` (`scope_id` ASC) ;


-- Table `activity_histories`
DROP TABLE IF EXISTS `activity_histories` ;

CREATE  TABLE IF NOT EXISTS `activity_histories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `staffm_sh_id` VARCHAR(255) NOT NULL COMMENT '変更した担当者ID(電子カルテ連携担当者ID)' ,
  `action_id` INT UNSIGNED NOT NULL COMMENT '実施記録のアクション',
  `activity_id` INT UNSIGNED NOT NULL COMMENT '変更した実施記録' ,
  `method` VARCHAR(255) NOT NULL COMMENT 'おこなった操作(登録、更新、削除)' ,
  `field_values` VARCHAR(255) NOT NULL COMMENT '入力した値をシリアライズ' ,
  `scope_id` VARCHAR(255) NOT NULL COMMENT '対象のスコープID' ,
  `device` VARCHAR(255) NOT NULL COMMENT '入力を行ったデバイス(iPodTouch/PC)' ,
  `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE INDEX `fk_activity_histories_action_id` ON `activity_histories` (`action_id` ASC) ;

CREATE INDEX `fk_activity_histories_activity_id` ON `activity_histories` (`activity_id` ASC) ;

CREATE INDEX `i_activity_histories_scope_id` ON `activity_histories` (`scope_id` ASC) ;


-- Table `access_logs`
DROP TABLE IF EXISTS `access_logs` ;

CREATE  TABLE IF NOT EXISTS `access_logs` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `staffm_sh_id` VARCHAR(255) NULL COMMENT '担当者ID(電子カルテ連携担当者ID)' ,
  `uri` VARCHAR(255) NOT NULL ,
  `method` VARCHAR(255) NOT NULL COMMENT 'GET/POST' ,
  `request_values` TEXT NOT NULL COMMENT 'request パラメータ',
  `response_values` TEXT NOT NULL COMMENT 'response データ',
  `device` VARCHAR(255) NOT NULL COMMENT 'iPodTouch/PC' ,
  `remote_addr` VARCHAR(255) NOT NULL ,
  `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE INDEX `i_access_logs_staffm_sh_id` ON `access_logs` (`staffm_sh_id` ASC) ;


-- Table `activity_fields`
DROP TABLE IF EXISTS `activity_fields` ;

CREATE  TABLE IF NOT EXISTS `activity_fields` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `activity_id` INT UNSIGNED NOT NULL ,
  `action_field_id` INT UNSIGNED NOT NULL ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE INDEX `fk_activity_fields_activity_id` ON `activity_fields` (`activity_id` ASC) ;

CREATE INDEX `fk_activity_fields_action_field_id` ON `activity_fields` (`action_field_id` ASC) ;


-- Data for table `accounts`
START TRANSACTION;
INSERT INTO `accounts` (`id`, `staffm_sh_id`, `last_session_at`, `last_session_remote_addr`, `created_at`, `created_account_id`, `updated_at`, `updated_account_id`, `removed_at`, `removed_account_id`) VALUES (NULL, '0123456789', NULL, NULL, NOW(), 1, NOW(), 1, NULL, NULL);
COMMIT;

