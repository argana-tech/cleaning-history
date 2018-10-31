ALTER TABLE `actions`
  ADD `return_elapsed_last_action_id` INT NULL COMMENT '経過時間を計算する対象のアクションID' AFTER `saved_message`
 ,ADD `return_elapsed_last_action` TINYINT NOT NULL DEFAULT 0 COMMENT '前回アクションからの経過時間を保存時に表示するか(0:表示しない、1: 表示する)' AFTER `saved_message`
;
