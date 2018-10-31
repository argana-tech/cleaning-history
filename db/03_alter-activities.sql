ALTER TABLE `activities`
  ADD `device` VARCHAR(255) NOT NULL COMMENT '入力を行ったデバイス(iPodTouch/PC)' AFTER `scope_id`
;

UPDATE `activities` SET `device` = 'iPodTouch';
