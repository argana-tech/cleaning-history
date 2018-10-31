DROP TABLE IF EXISTS `washers`;

CREATE TABLE IF NOT EXISTS `washers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `code` VARCHAR(255) NOT NULL,
  `type` VARCHAR(255) NOT NULL,
  `solution` VARCHAR(255) NULL DEFAULT NULL,
  `location` VARCHAR(255) NULL DEFAULT NULL,
  `alert_message` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL ,
  `created_account_id` INT UNSIGNED NOT NULL ,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON  UPDATE CURRENT_TIMESTAMP ,
  `updated_account_id` INT UNSIGNED NOT NULL ,
  `removed_at` DATETIME NULL ,
  `removed_account_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`)
)Engine=InnoDB;

CREATE INDEX `i_washers_code` ON `washers` (`code` ASC) ;
