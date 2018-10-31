  <?php $fields = Fieldset::instance('washer'); ?>

  <?php $field = $fields->field('code'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
	<label class="control-label"><?php echo e($field->label); ?> *</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => $field->label)); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <?php $field = $fields->field('type'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
	<label class="control-label"><?php echo e($field->label); ?> *</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => $field->label)); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <?php $field = $fields->field('solution'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
	<label class="control-label"><?php echo e($field->label); ?></label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => $field->label)); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <?php $field = $fields->field('location'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
	<label class="control-label"><?php echo e($field->label); ?></label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => $field->label)); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <?php $field = $fields->field('alert_message'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
	<label class="control-label"><?php echo e($field->label); ?></label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => $field->label)); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

