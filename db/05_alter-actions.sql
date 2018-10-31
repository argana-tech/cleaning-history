ALTER TABLE `actions`
  ADD `saved_message` VARCHAR(255) NULL COMMENT '保存後に表示するメッセージ' AFTER `validate_last_action_error_message`
;