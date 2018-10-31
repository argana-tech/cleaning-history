  <p>記録済みの実施記録を変更します。</p>

<?php $fields = Fieldset::instance('action'); ?>
<?php echo Form::open(array('action' => '/activities/update_activity/' . $activity->id, 'class' => 'form well well-sm')); ?>

  <?php $field = $fields->field('staffm_sh_id'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">実施担当者ID *</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => '実施担当者ID')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <?php $field1 = $fields->field('action_completed_date'); ?>
  <?php $field2 = $fields->field('action_completed_time'); ?>
  <div class="form-group<?php if ($field1->error() || $field2->error()): ?> has-error<?php endif ?>">
    <label class="control-label">実施日時 *</label>
    <?php echo Form::input($field1->name, $field1->validated() ?: $field1->value, array('class' => 'form-control enable_datepicker', 'placeholder' => '実施日')); ?>
    <?php echo Form::input($field2->name, $field2->validated() ?: $field2->value, array('class' => 'form-control enable_timepicker', 'placeholder' => '実施時刻')); ?>
    <p class="help-block">
      <?php echo e($field1->error()); ?>
      <?php echo e($field2->error()); ?>
    </p>
  </div>

  <?php $field = $fields->field('scope_id'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">スコープID *</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => 'スコープID')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <div class="control-group">
    <label class="control-label">アクション名</label>
    <p><?php echo e($activity->action_name); ?></p>
  </div>

<?php foreach ($fields->field() as $field):
if (strpos($field->name, 'fields[') !== FALSE): ?>
  <div class="control-group<?php if ($field->error()): ?> has-error<?php endif; ?>">
    <label class="control-label"><?php echo e($field->label); ?></label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => $field->label)); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>
<?php endif; endforeach; ?>

<?php echo Form::hidden('action_id', $activity->action_id); ?>
<?php echo Form::close(); ?>

