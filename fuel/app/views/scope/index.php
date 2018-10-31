<?php
$sess = Session::instance();
$user = Model_Staffm::findByStaffmShId($sess->get('cis_id'));
?>
<div class="col-sm-12">
  <p>システムに登録されている実施記録の一覧です。</p>

  <form class="form-inline well well-sm clearfix" action="<?php echo Uri::current(); ?>" method="get">
    <div class="form-group" style="width: 108px;">
      <label>実施日</label>
	  <?php echo Form::Input('q[date]', isset($q['date']) ? $q['date'] : '', array('class' => 'form-control enable_datepicker', 'placeholder' => '実施日', 'style' => 'width: 108px;')); ?>
    </div>
    <div class="form-group" style="width: 128px;">
      <label>実施診療科・部署</label>
      <?php echo Form::Input('q[staffm_ka_name]', isset($q['staffm_ka_name']) ? $q['staffm_ka_name'] : '', array('class' => 'form-control', 'placeholder' => '実施診療科・部署', 'style' => 'width: 108px;')); ?>
    </div>
    <div class="form-group" style="width: 108px;">
      <label>実施担当者ID</label>
      <?php echo Form::Input('q[staffm_sh_id]', isset($q['staffm_sh_id']) ? $q['staffm_sh_id'] : '', array('class' => 'form-control', 'placeholder' => '実施担当者', 'style' => 'width: 108px;')); ?>
    </div>
    <div class="form-group" style="width: 144px;">
      <label>アクション</label>
      <?php echo Form::select('q[action_id]', isset($q['action_id']) ? $q['action_id'] : '', $actions, array('class' => 'form-control')); ?>
    </div>
    <div class="form-group" style="width: 144px;">
      <label>直前チェックエラー</label>
      <?php echo Form::select('q[has_eve_check_error]', isset($q['has_eve_check_error']) ? $q['has_eve_check_error'] : '', array('' => 'すべて', '0' => 'なし', '1' => 'あり'), array('class' => 'form-control', 'placeholder' => '直前チェックエラー', 'style' => 'width: 108px;', )); ?>
    </div>
    <div class="form-group" style="width: 108px;">
      <label>スコープID</label>
      <?php echo Form::Input('q[scope_id]', isset($q['scope_id']) ? $q['scope_id'] : '', array('class' => 'form-control', 'placeholder' => 'スコープID', 'style' => 'width: 108px;')); ?>
    </div>
    <br clear="all" />
<?php foreach ($action_fields as $action_field): ?>
<?php $key = 'action_field_' . $action_field->id; ?>
    <div class="form-group" style="width: 128px;">
      <label><?php echo e($action_field->name); ?></label>
      <?php echo Form::Input('q[action_field][' . $action_field->id . ']', isset($q['action_field']) ? $q['action_field'][$action_field->id] : '', array('class' => 'form-control', 'placeholder' => $action_field->name, 'style' => 'width: 108px;')); ?>
    </div>
<?php endforeach ?>
    <div class="form-group pull-right">
      <br />
      <?php echo Form::submit('submit', '絞り込み', array('class' => 'btn btn-primary')); ?>
      <?php echo Form::button('button', 'クリア', array('type' => 'button', 'class' => 'btn btn-default', 'onclick' => 'window.location=\'' . Uri::current() . '\'')); ?>
	 <a href="<?php echo Uri::create('/activities/download', array(), array('q' => $q, 'sort' => $sort_by)); ?>" class="btn btn-info">CSVダウンロード</a>
     <a href="<?php echo Uri::create('/activities/new'); ?>" class="btn btn-success">実施記録登録</a>
    </div>
  </form>

<?php if ($activities): ?>

  <div class="row" style="margin-bottom: 16px;">
    <div class="col-sm-10">
      <?php echo $start_item; ?>件目 ～ <?php echo $end_item; ?>件目 /
      全 <?php echo $total_items; ?>件
    </div>
  </div>

<?php
$action_field_count = count($action_fields);
if (isset($q['action_id']) && !empty($q['action_id'])) {
  foreach ($action_fields as $action_field) {
    if ($action_field->action_id != $q['action_id']) {
      $action_field_count--;
    }
  }
}
$table_width = (736 + (144 * $action_field_count));
?>

  <table class="table table-striped" style="min-width: <?php echo $table_width; ?>px">
    <thead>
      <tr>
        <th style="min-width: 112px;">
          <?php if ($sort_by == 'created_asc'): ?>▲<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'created_asc')); ?>">▲</a><?php endif ?>
          実施日時
          <?php if ($sort_by == 'created_desc'): ?>▼<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'created_desc')); ?>">▼</a><?php endif ?>
        </th>
        <th style="min-width: 128px;">
          <?php if ($sort_by == 'ka_asc'): ?>▲<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'ka_asc')); ?>">▲</a><?php endif ?>
          実施診療科・部署
          <?php if ($sort_by == 'ka_desc'): ?>▼<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'ka_desc')); ?>">▼</a><?php endif ?>
        </th>
        <th style="min-width: 128px;">
          <?php if ($sort_by == 'staff_asc'): ?>▲<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'staff_asc')); ?>">▲</a><?php endif ?>
          実施者
          <?php if ($sort_by == 'staff_desc'): ?>▼<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'staff_desc')); ?>">▼</a><?php endif ?>
        </th>
        <th style="min-width: 128px;">
          <?php if ($sort_by == 'action_asc'): ?>▲<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'action_asc')); ?>">▲</a><?php endif ?>
          アクション
          <?php if ($sort_by == 'action_desc'): ?>▼<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'action_desc')); ?>">▼</a><?php endif ?>
        </th>
        <th style="min-width: 128px;">
          <?php if ($sort_by == 'eve_check_asc'): ?>▲<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'eve_check_asc')); ?>">▲</a><?php endif ?>
          直前チェックエラー
          <?php if ($sort_by == 'eve_check_desc'): ?>▼<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'eve_check_desc')); ?>">▼</a><?php endif ?>
        </th>
        <th style="min-width: 96px;">
          <?php if ($sort_by == 'scope_asc'): ?>▲<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'scope_asc')); ?>">▲</a><?php endif ?>
          スコープID
          <?php if ($sort_by == 'scope_desc'): ?>▼<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => 'scope_desc')); ?>">▼</a><?php endif ?>
        </th>
<?php foreach ($action_fields as $action_field): ?>
<?php $asc_key = 'action_field_' . $action_field->id . '_asc'; ?>
<?php $desc_key = 'action_field_' . $action_field->id . '_desc'; ?>
<?php if (isset($q['action_id']) && !empty($q['action_id'])): ?>
    <?php if ($action_field->action_id != $q['action_id']): continue; endif; ?>
<?php endif ?>
        <th style="min-width: 144px;">
          <?php if ($sort_by == $asc_key): ?>▲<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => $asc_key)); ?>">▲</a><?php endif ?>
          <?php echo e($action_field->name); ?>
          <?php if ($sort_by == $desc_key): ?>▼<?php else: ?><a href="<?php echo Uri::create('/activities/index', array(), array('q' => $q, 'sort' => $desc_key)); ?>">▼</a><?php endif ?>
        </th>
<?php endforeach; ?>
        <th style="min-width: 72px;">編集履歴</th>
<?php if ($user->is_admin()): ?>
        <th style="min-width: 36px;">編集</th>
        <th style="min-width: 36px;">削除</th>
<?php endif ?>
      </tr>
    </thead>
    <tbody>
<?php foreach ($activities as $activity): ?>
      <tr id="activity_<?php echo $activity->id; ?>">
        <td><?php echo $activity->get_action_completed_at('%Y-%m-%d %H:%M'); ?></td>
        <td>
<?php if ($activity->staffm_ka_name): ?>
          <?php echo e($activity->staffm_ka_name); ?><br />
<?php endif ?>
        </td>
        <td>
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
          <br />(<?php echo $activity->device; ?>)
        </td>
        <td><?php echo e($activity->action_name); ?></td>
        <td><?php echo $activity->has_eve_check_error ? 'あり' : 'なし' ?></a></td>
        <td><a href="<?php echo Uri::create('/scope/history/' . $activity->scope_id); ?>"><?php echo $activity->scope_id; ?></a></td>
<?php foreach ($action_fields as $action_field): ?>
<?php if (isset($q['action_id']) && !empty($q['action_id'])): ?>
    <?php if ($action_field->action_id != $q['action_id']): continue; endif; ?>
<?php endif ?>

        <td>
<?php foreach ($activity->activity_fields as $activity_field): ?>
<?php if ($action_field->id == $activity_field->action_field_id): ?>
<?php echo $activity_field->value; ?>
<?php if ($activity_field->is_patient_id_field and
is_object($activity_field->patient_data)): ?>
<br /><?php echo e(trim(mb_convert_kana($activity_field->patient_data->PT_KJ_NAME, 's'))); ?>
<br /><?php echo e(trim(mb_convert_kana($activity_field->patient_data->PT_KN_NAME, 's'))); ?>
<?php endif ?>
<?php if ($activity_field->is_washer_id_field and
is_object($activity_field->washer_data)): ?>
<br /><?php echo e(trim($activity_field->washer_data->type)); ?>
<?php if ($activity_field->washer_data->solution): ?>
<br /><?php echo e(trim($activity_field->washer_data->solution)); ?>
<?php endif ?>
<?php if ($activity_field->washer_data->location): ?>
<br /><?php echo e(trim($activity_field->washer_data->location)); ?>
<?php endif ?>
<?php endif ?>
<?php endif; ?>
<?php endforeach; ?>
        </td>
<?php endforeach; ?>
        <td style="text-align: center;"><a href="<?php echo Uri::create('/activities/log/' . $activity->id); ?>" class="btn btn-sm btn-info">編集履歴</a></td>
<?php if ($user->is_admin()): ?>
        <td style="text-align: center;">
          <a href="<?php echo Uri::create('/activities/edit/' . $activity->id); ?>" class="openEditModal btn btn-sm btn-success">編集</a>
        </td>
        <td style="text-align: center;">
          <a href="<?php echo Uri::create('/activities/remove/' . $activity->id, array(), array('from' => 'scope-index')); ?>" onclick="return confirmRemove(this, '\'<?php echo e($activity->get_action_completed_at()); ?>\' の実施記録を削除してもよろしいですか？')" class="btn btn-sm btn-danger">削除</a>
        </td>
<?php endif ?>
     </tr>
<?php endforeach; ?>
    </tbody>
  </table>
  <?php echo $pager; ?>
<?php else: ?>
  <div>登録されていません</div>
<?php endif; ?>

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
