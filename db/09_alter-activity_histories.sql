ALTER TABLE `activity_histories`
  ADD `action_completed_at` DATETIME NULL AFTER `action_id`
 ,ADD `action_staffm_sh_id` VARCHAR(255) NULL AFTER `action_id`
;