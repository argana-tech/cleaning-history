  <?php $fields = Fieldset::instance('account'); ?>
  <?php $field = $fields->field('staffm_sh_id'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">職員ID *</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => '職員ID')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

