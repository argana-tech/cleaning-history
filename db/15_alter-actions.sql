ALTER TABLE `actions`
  ADD COLUMN `invalid_last_action_notice_mail_body` TEXT NULL DEFAULT NULL COMMENT '直前アクションがエラーのまま保存したときの通知メールの本文' AFTER `validate_last_action_error_message_on_completed`
 ,ADD COLUMN `invalid_last_action_notice_mail_subject` VARCHAR(255) NULL DEFAULT NULL  COMMENT '直前アクションがエラーのまま保存したときの通知メールの件名' AFTER `validate_last_action_error_message_on_completed`
 ,ADD COLUMN `send_notice_mail_on_invalid_last_action` BOOLEAN NOT NULL DEFAULT 0  COMMENT '直前アクションがエラーのまま保存したときに通知メールを送るかどうか' AFTER `validate_last_action_error_message_on_completed`
;
