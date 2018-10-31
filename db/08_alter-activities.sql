ALTER TABLE `activities`
  ADD `staffm_byoto_name` VARCHAR(64) NULL AFTER `cis_name`
 ,ADD `staffm_ka_name` VARCHAR(64) NULL AFTER `cis_name`
 ,ADD `updated_staffm_byoto_name` VARCHAR(64) NULL AFTER `updated_staffm_sh_id`
 ,ADD `updated_staffm_ka_name` VARCHAR(64) NULL AFTER `updated_staffm_sh_id`
 ,ADD `updated_staffm_sh_name` VARCHAR(255) NULL AFTER `updated_staffm_sh_id`
 ,ADD `created_staffm_byoto_name` VARCHAR(64) NULL AFTER `created_staffm_sh_id`
 ,ADD `created_staffm_ka_name` VARCHAR(64) NULL AFTER `created_staffm_sh_id`
 ,ADD `created_staffm_sh_name` VARCHAR(255) NULL AFTER `created_staffm_sh_id`
;

ALTER TABLE `activities`
  CHANGE `cis_name` `staffm_sh_name` VARCHAR(255) NOT NULL
;

ALTER TABLE `activity_histories`
  ADD `staffm_byoto_name` VARCHAR(64) NULL AFTER `staffm_sh_id`
 ,ADD `staffm_ka_name` VARCHAR(64) NULL AFTER `staffm_sh_id`
 ,ADD `staffm_sh_name` VARCHAR(255) NULL AFTER `staffm_sh_id`
;