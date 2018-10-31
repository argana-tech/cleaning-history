  <?php $fields = Fieldset::instance('mailto'); ?>
  <?php $field = $fields->field('address'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">メールアドレス *</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => 'メールアドレス')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <?php $field = $fields->field('note'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">備考</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => '備考')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

