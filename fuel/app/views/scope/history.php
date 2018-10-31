<?php
$sess = Session::instance();
$user = Model_Staffm::findByStaffmShId($sess->get('cis_id'));
?>
<div class="col-sm-12">
  <p>スコープに対する実施履歴の一覧です。</p>
  <h4>対象スコープID: <?php echo $id ;?></h4>

<?php if ($activities): ?>

  <div>
    <?php echo $start_item; ?>件目 ～ <?php echo $end_item; ?>件目 /
    全 <?php echo $total_items; ?>件
  </div>

  <table class="table table-striped editable">
    <thead>
      <tr>
        <th class="col-sm-2">実施日時</th>
	    <th>実施者</th>
        <th>アクション</th>
        <th>備考</th>
        <th class="col-sm-1">編集履歴</th>
<?php if ($user->is_admin()): ?>
        <th class="col-sm-1">編集</th>
        <th class="col-sm-1">削除</th>
<?php endif ?>
      </tr>
    </thead>
    <tbody>
<?php foreach ($activities as $activity): ?>
      <tr id="activity_<?php echo $activity->id; ?>">
	    <td><?php echo $activity->get_action_completed_at(); ?></td>
        <td>
<?php if ($activity->staffm_ka_name): ?>
          <?php echo e($activity->staffm_ka_name); ?><br />
<?php endif ?>
          <?php echo e(trim(mb_convert_kana($activity->staffm_sh_name, 's'))); ?><br />
          <?php echo e($activity->staffm_sh_id); ?>
<?php if ($activity->staffm_sh_id != $activity->created_staffm_sh_id): ?>
<br />登録者:<br />
<?php if ($activity->created_staffm_ka_name): ?>
          <?php echo e($activity->created_staffm_ka_name); ?><br />
<?php endif ?>
          <?php echo e(trim(mb_convert_kana($activity->created_staffm_sh_name, 's'))); ?><br />
          <?php echo $activity->created_staffm_sh_id; ?>
<?php endif ?>
<?php if ($activity->staffm_sh_id != $activity->updated_staffm_sh_id): ?>
<br />変更者:<br />
<?php if ($activity->updated_staffm_ka_name): ?>
          <?php echo e($activity->updated_staffm_ka_name); ?><br />
<?php endif ?>
          <?php echo e(trim(mb_convert_kana($activity->updated_staffm_sh_name, 's'))); ?><br />
          <?php echo $activity->updated_staffm_sh_id; ?>
<?php endif ?>
          (<?php echo $activity->device; ?>)
        </td>
        <td><?php echo e($activity->action_name); ?><?php if ($activity->has_eve_check_error): ?><br />(直前チェックエラーあり)<?php endif ?></td>
        <td>
<?php foreach ($activity->activity_fields as $activity_field): ?>
<?php if ($activity_field->action_field !== NULL): ?>
<?php echo $activity_field->action_field->name; ?>:
<?php else: ?>action_field_id(<?php echo $activity_field->action_field_id; ?>):
<?php endif ?>
<?php echo $activity_field->value; ?>
<?php if ($activity_field->is_patient_id_field and
is_object($activity_field->patient_data)): ?>
(<?php echo e(trim(mb_convert_kana($activity_field->patient_data->PT_KJ_NAME, 's'))); ?>)
<?php endif ?>
<?php if ($activity_field->is_washer_id_field and
is_object($activity_field->washer_data)): ?>
(<?php echo e(trim($activity_field->washer_data->type)); ?>
<?php if ($activity_field->washer_data->solution): ?>
:<?php echo e(trim($activity_field->washer_data->solution)); ?>
<?php endif ?>
<?php if ($activity_field->washer_data->location): ?>
:<?php echo e(trim($activity_field->washer_data->location)); ?>
<?php endif ?>
)
<?php endif ?>
<br />
<?php endforeach; ?>
        </td>
        <td><a href="<?php echo Uri::create('/activities/log/' . $activity->id); ?>" class="btn btn-sm btn-info">編集履歴</a></td>
<?php if ($user->is_admin()): ?>
        <td><a href="<?php echo Uri::create('/activities/edit/' . $activity->id); ?>" class="openEditModal btn btn-sm btn-success">編集</a></td>
        <td><a href="<?php echo Uri::create('/activities/remove/' . $activity->id); ?>" onclick="return confirmRemove(this, '\'<?php echo e($activity->get_action_completed_at()); ?>\' の実施記録を削除してもよろしいですか？')" class="btn btn-sm btn-danger">削除</a></td>
<?php endif ?>
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

<div id="editModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span></button>
        <h4 class="modal-title">実施記録修正</h4>
      </div><!-- /.modal-header -->
      <div class="modal-body">
      </div><!-- /.modal-body -->
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">
          <span class="glyphicon glyphicon-remove"></span>
          閉じる
        </button>
        <button type="button" class="btn btn-success" onclick="saveActivity()">
          <span class="glyphicon glyphicon-plus"></span>
          保存する
        </button>
      </div><!-- /.model-footer -->
    </div>
  </div>
</div><!-- /.modal -->
