<div class="col-sm-12">
  <p>アクション: <?php echo e($action->name); ?> の実施履歴</p>

<?php if ($activities): ?>

  <div>
    <?php echo $start_item; ?>件目 ～ <?php echo $end_item; ?>件目 /
    全 <?php echo $total_items; ?>件
  </div>

  <table class="table table-striped editable">
    <thead>
      <tr>
        <th class="col-sm-4">実施日時</th>
        <th>スコープID</th>
<?php foreach ($action->action_fields as $action_field): ?>
        <th><?php echo e($action_field->name); ?></th>
<?php endforeach; ?>
        <th class="col-sm-1">編集履歴</th>
        <th class="col-sm-1">削除</th>
      </tr>
    </thead>
    <tbody>
<?php foreach ($activities as $activity): ?>
      <tr id="activity_<?php echo $activity->id; ?>">
        <td><?php echo $activity->get_action_completed_at(); ?></td>
        <td><a href="<?php echo Uri::create('/scope/history/' . $activity->scope_id); ?>"><?php echo $activity->scope_id; ?></a></td>
<?php foreach ($action->action_fields as $action_field): ?>
        <td class="editable" id="action_field_<?php echo $action_field->id; ?>"><?php if ($activity_field = $activity->getActivityFieldByActionFieldId($action_field->id)): echo e($activity_field->value); endif; ?></td>
<?php endforeach; ?>
        <td><a href="<?php echo Uri::create('/activities/log/' . $activity->id); ?>" class="btn btn-sm btn-info">編集履歴</a></td>
        <td><a href="<?php echo Uri::create('/activities/remove/' . $activity->id); ?>" onclick="return confirmRemove(this, '\'<?php echo e($activity->get_action_completed_at()); ?>\' の実施記録を削除してもよろしいですか？')" class="btn btn-sm btn-danger">削除</a></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
  <?php echo $pager; ?>
<?php else: ?>
  <div>登録されていません</div>
<?php endif; ?>

<div class="form-actions">
<a href="javascript:window.history.go(-1)" class="btn btn-sm btn-info">戻る</a>
</div>

</div>

<script>
function save(elm){
	//保存する処理をここに書く
	var val = $(elm).val();

	var $parent_tr = $(elm).parents('tr');
	var $parent_td = $(elm).parents('td');
	var activity_id = $parent_tr.attr('id').replace('activity_', '');
	var action_field_id = $parent_td.attr('id').replace('action_field_', '');

	var origin = $parent_td.find('input:hidden[name^=\'origin\']').val();
	if (val == origin) {
		return;
	}

	$.ajax({
		url: '<?php echo Uri::create('/activities/update'); ?>',
		type: 'post',
		dataType: 'json',
		data: {
			'activity_id': activity_id,
			'action_field_id': action_field_id,
			value: val
		},
		success: function(data, status) {
			if ($(data.errors).length > 0) {
				var error_msg = '';
				$(data.errors).each(function(i) {
					error_msg += data.errors[i] + "\n";
				});
				alert(error_msg);
				return false;
			}
			alert("保存しました。\n画面を再読込します。");
			window.location.reload();
		}
	});
}
</script>
