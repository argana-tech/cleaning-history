<div class="col-sm-12">
  <p>実施記録を新規登録します。</p>

<?php $fields = Fieldset::instance('action'); ?>
<?php echo Form::open(array('action' => '/activities/create', 'class' => 'form well well-sm', 'id' => 'activity_new')); ?>

  <?php $field = $fields->field('staffm_sh_id'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">実施担当者ID *</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => '実施担当者ID', 'id' => 'staffm_sh_id')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <?php $field1 = $fields->field('action_completed_date'); ?>
  <?php $field2 = $fields->field('action_completed_time'); ?>
  <div class="form-group<?php if ($field1->error() || $field2->error()): ?> has-error<?php endif ?>">
    <label class="control-label">実施日時 *</label>
	<?php echo Form::input($field1->name, $field1->validated() ?: $field1->value, array('class' => 'form-control enable_datepicker', 'placeholder' => '実施日', 'id' => 'action_completed_date')); ?>
    <?php echo Form::input($field2->name, $field2->validated() ?: $field2->value, array('class' => 'form-control enable_timepicker', 'placeholder' => '実施時刻', 'id' => 'action_completed_time')); ?>
    <p class="help-block">
      <?php echo e($field1->error()); ?>
      <?php echo e($field2->error()); ?>
    </p>
  </div>

  <?php $field = $fields->field('scope_id'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">スコープID *</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => 'スコープID', 'id' => 'scope_id')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

<?php $field = $fields->field('action_id'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">アクション名 *</label>
    <?php echo Form::select($field->name, $field->validated() ?: $field->value, $actions, array('class' => 'form-control', 'id' => 'action_id')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <div id="action_fields">
  </div>

  <?php $sess = Session::instance(); ?>

  <div class="form-actions">
    <?php echo Form::submit('submit', '保存する', array('class' => 'btn btn-success')); ?>
    <a href="<?php echo Uri::create('/activities/index'); ?>" class="btn btn-sm btn-info">戻る</a>
  </div>

<?php echo Form::close(); ?>
</div>
<script type="text/javascript">
//<![CDATA[
var get_fields_url = '<?php echo Uri::create('/activities/list_fields'); ?>';
var check_scope_url = '<?php echo Uri::create('/api/scope'); ?>';
var check_patient_url = '<?php echo Uri::create('/api/patient'); ?>';
var check_washer_url = '<?php echo Uri::create('/api/washer'); ?>';
var validate_url = '<?php echo Uri::create('/api/activity/validate'); ?>';
<?php
$fields_error = array();
foreach ($fields->field() as $field) {
  if (preg_match('/^fields\[(\d+)\]$/', $field->name, $m)) {
    $fields_error['field_' . $m[1]] = array(
      'value' => $field->validated() ?: $field->value,
      'error' => (string)$field->error(),
    );
  }
}
?>
var fields_error = <?php echo json_encode($fields_error); ?>;
//]]>
</script>
