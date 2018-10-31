ALTER TABLE `action_fields`
  ADD `is_washer_id_field` BOOLEAN DEFAULT 0 AFTER `is_patient_id_field`
;

UPDATE `action_fields`
  SET `is_washer_id_field` = 1
  WHERE `name` = '洗浄・消毒機器ID'
;

ALTER TABLE `activity_fields`
  ADD `washer_data` TEXT NULL DEFAULT NULL AFTER `patient_data`
 ,ADD `is_washer_id_field` BOOLEAN DEFAULT 0 AFTER `patient_data`
;
