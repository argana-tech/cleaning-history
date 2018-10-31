ALTER TABLE `actions`
  ADD COLUMN `validate_last_action_error_message_on_completed` VARCHAR(255) NULL DEFAULT NULL AFTER `validate_last_action_error_message`
;