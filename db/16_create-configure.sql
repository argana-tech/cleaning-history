-- Table `configure_mailto`
DROP TABLE IF EXISTS `configure_mailto`;

CREATE TABLE IF NOT EXISTS `configure_mailto` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(255) NOT NULL,
  `note` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL,
  `created_account_id` INT UNSIGNED NOT NULL,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON  UPDATE CURRENT_TIMESTAMP,
  `updated_account_id` INT UNSIGNED NOT NULL,
  `removed_at` DATETIME NULL,
  `removed_account_id` INT UNSIGNED NULL,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;
