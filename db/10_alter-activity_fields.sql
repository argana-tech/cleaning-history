ALTER TABLE `activity_fields`
  ADD `patient_data` TEXT NULL DEFAULT NULL AFTER `value`
 ,ADD `is_patient_id_field` BOOLEAN DEFAULT 0 AFTER `value`
;
