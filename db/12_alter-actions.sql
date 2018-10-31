ALTER TABLE `actions`
  ADD COLUMN `validate_duplicate_action_message` VARCHAR(255) NULL DEFAULT NULL AFTER `return_elapsed_last_action_id`
 ,ADD COLUMN `validate_duplicate_action` BOOLEAN NOT NULL DEFAULT 0 AFTER `return_elapsed_last_action_id`
;