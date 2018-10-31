ALTER TABLE `action_fields`
  ADD `is_patient_id_field` BOOLEAN DEFAULT 0 AFTER `priority`
;

UPDATE `action_fields`
  SET `is_patient_id_field` = 1
  WHERE `name` = '患者番号'
;