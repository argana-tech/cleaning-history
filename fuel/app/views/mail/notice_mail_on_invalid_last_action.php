<?php echo $action->invalid_last_action_notice_mail_body . "\n"; ?>

---実施記録詳細---
担当者情報
  担当者ID: <?php echo $activity->staffm_sh_id . "\n"; ?>
  氏名: <?php echo $activity->staffm_sh_name . "\n"; ?>
  診療科・部署: <?php echo $activity->staffm_ka_name . "\n"; ?>

保存情報
  スコープID: <?php echo $activity->scope_id . "\n"; ?>

<?php foreach ($activity->activity_fields as $activity_field): ?>
  <?php if ($activity_field->action_field !== NULL): ?><?php echo $activity_field->action_field->name; ?><?php else: ?>action_field_id(<?php echo $activity_field->action_field_id; ?>)<?php endif ?>: <?php echo $activity_field->value . "\n"; ?>
<?php if ($activity_field->is_patient_id_field and is_object($activity_field->patient_data)): ?>
    患者氏名: <?php echo e(trim(mb_convert_kana($activity_field->patient_data->PT_KJ_NAME, 's'))) . "\n"; ?>
<?php endif ?>
<?php if ($activity_field->is_washer_id_field and is_object($activity_field->washer_data)): ?>
    洗浄・消毒種別:<?php echo e(trim($activity_field->washer_data->type)) . "\n"; ?>
<?php if ($activity_field->washer_data->solution): ?>    薬剤: <?php echo e(trim($activity_field->washer_data->solution)) . "\n"; ?><?php endif ?>
<?php if ($activity_field->washer_data->location): ?>    設置場所: <?php echo e(trim($activity_field->washer_data->location)) . "\n"; ?><?php endif ?>
<?php endif ?>
<?php endforeach; ?>

  登録時間: <?php echo $activity->action_completed_at->format('%Y-%m-%d %H:%M') . "\n"; ?>
