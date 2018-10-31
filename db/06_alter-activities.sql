ALTER TABLE `activities`
  ADD `action_completed_at` DATETIME NOT NULL COMMENT '実施日時' AFTER `device`
;

UPDATE `activities`
  SET `action_completed_at` = `created_at`
;