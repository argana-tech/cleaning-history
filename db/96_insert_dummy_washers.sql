START TRANSACTION;
INSERT INTO `washers` (`code`, `type`, `solution`, `location`, `alert_message`, `created_at`, `created_account_id`, `updated_at`, `updated_account_id`) VALUES
('0789', '浸漬消毒', 'グルタラール', '泌尿器科', '消毒薬の期限を確認して下さい。', NOW(), 1, NOW(), 1),
('0123', '浸漬消毒', 'グルタラール', '女性診療科病棟', '消毒薬の期限を確認して下さい。', NOW(), 1, NOW(), 1),
('1456', '浸漬消毒', 'フタラール', '女性診療科外来', '消毒薬の期限を確認して下さい。', NOW(), 1, NOW(), 1),
('9875', 'EOG滅菌', NULL, '口腔外科', NULL, NOW(), 1, NOW(), 1),
('9345', 'EOG滅菌', NULL, 'NICU', NULL, NOW(), 1, NOW(), 1),
('9012', 'EOG滅菌', NULL, '手術部', NULL, NOW(), 1, NOW(), 1)
;
COMMIT;

