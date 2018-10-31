  <?php $fields = Fieldset::instance('action'); ?>
  <?php $field = $fields->field('name'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">アクション名 *</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => 'アクション名')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <div class="form-group">
    <label class="control-label">入力項目</label>
    <a class="btn btn-success btn-sm" href="#newField" data-toggle="modal">新規追加</a>

    <table id="fields" class="table table-striped">
      <thead>
        <tr>
          <th>並び順</th>
          <th>項目名</th>
          <th>入力規則</th>
          <th>編集</th>
          <th>削除</th>
        </tr>
      </thead>
      <tbody>
      </tbody>
    </table>
  </div>

  <div class="form-group">
    <?php $field = $fields->field('validate_last_action_enable'); ?>
    <label class="control-label">直前アクション制限</label>
    <div class="checkbox">
      <label><?php echo Form::checkbox($field->name, 1, $field->validated() ?: $field->value, array('id' => 'validateLastActionEnable')); ?>制限する</label>
    </div>

    <div id="enableValidateLastActionFields">
      <?php $field = $fields->field('validate_last_action_id'); ?>
      <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
        <label class="control-label">アクション名</label>
        <?php echo Form::select($field->name, $field->validated() ?: $field->value, $actions, array('class' => 'form-control')); ?>
        <p class="help-block"><?php echo e($field->error()); ?></p>
      </div>

      <?php $field = $fields->field('validate_last_action'); ?>
      <?php $validate_last_action_value = $field->validated() ?: $field->value; ?>
      <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
        <label class="control-label">直前アクション制限回避</label>
        <div class="radio">
          <label>
            <?php echo Form::radio($field->name, 1, $validate_last_action_value == 1, array()); ?>
            直前アクションが異なっていたら登録しない
          </label>
        </div>
        <div class="radio">
          <label>
            <?php echo Form::radio($field->name, 2, $validate_last_action_value == 2, array()); ?>
            入力者に確認する
          </label>
        </div>
        <p class="help-block"><?php echo e($field->error()); ?></p>
      </div>

      <?php $field = $fields->field('validate_last_action_error_message'); ?>
      <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
        <label class="control-label">エラー時のメッセージ</label>
        <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control')); ?>
        <p class="help-block"><?php echo e($field->error()); ?></p>
      </div>

      <?php $field = $fields->field('validate_last_action_error_message_on_completed'); ?>
      <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
        <label class="control-label">エラー時に保存後に表示するメッセージ</label>
        <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control')); ?>
        <p class="help-block"><?php echo e($field->error()); ?></p>
      </div>

      <?php $field = $fields->field('send_notice_mail_on_invalid_last_action'); ?>
      <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
        <label class="control-label">エラー時に保存した時にメール通知をおこなうか</label>
        <div class="radio">
          <label><?php echo Form::radio($field->name, 0, $field->validated() ?: $field->value, array('class' => 'sendNoticeMailOnInvalidLastAction')); ?>送信しない</label>
        </div>
        <div class="radio">
          <label><?php echo Form::radio($field->name, 1, $field->validated() ?: $field->value, array('class' => 'sendNoticeMailOnInvalidLastAction')); ?>送信する</label>
        </div>
        <p class="help-block"><?php echo e($field->error()); ?></p>
      </div>
      <div id="enableSendNoticeMailOnInvalidLastActionFields">
        <?php $field = $fields->field('invalid_last_action_notice_mail_subject'); ?>
        <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
          <label class="control-label">通知メールの件名</label>
          <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => '通知メールの件名')); ?>
          <p class="help-block">
            <?php echo e($field->error()); ?>
          </p>
        </div>
        <?php $field = $fields->field('invalid_last_action_notice_mail_body'); ?>
        <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
          <label class="control-label">通知メールの本文(ここで入力した本文の後ろに実施記録の詳細が自動的に挿入されます)</label>
          <?php echo Form::textarea($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => '通知メールの本文', 'rows' => 5,)); ?>
          <p class="help-block">
            <?php echo e($field->error()); ?>
          </p>
        </div>
      </div>
    </div>
  </div>

  <?php $field = $fields->field('saved_message'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">保存後に表示するメッセージ</label>
    <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => '保存後に表示するメッセージ')); ?>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>
  </div>

  <?php $field = $fields->field('return_elapsed_last_action'); ?>
  <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
    <label class="control-label">実施記録保存時に特定のアクションからの経過時間を表示する</label>
    <div class="radio">
      <label><?php echo Form::radio($field->name, 0, $field->validated() ?: $field->value, array('class' => 'returnElapsedLastAction')); ?>表示しない</label>
    </div>
    <div class="radio">
      <label><?php echo Form::radio($field->name, 1, $field->validated() ?: $field->value, array('class' => 'returnElapsedLastAction')); ?>表示する</label>
    </div>
    <p class="help-block">
      <?php echo e($field->error()); ?>
    </p>

    <div id="enableReturnElapsedLastActionFields">
      <?php $field = $fields->field('return_elapsed_last_action_id'); ?>
      <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
        <label class="control-label">経過時間を計算する対象アクション名</label>
        <?php echo Form::select($field->name, $field->validated() ?: $field->value, $actions, array('class' => 'form-control')); ?>
        <p class="help-block"><?php echo e($field->error()); ?></p>
      </div>
    </div>
  </div>

  <div class="form-group">
    <?php $field = $fields->field('validate_duplicate_action'); ?>
    <label class="control-label"><?php echo e($field->label); ?></label>
    <div class="checkbox">
      <label><?php echo Form::checkbox($field->name, 1, $field->validated() ?: $field->value, array('id' => 'validateDuplicateAction')); ?>チェックする</label>
    </div>

    <div id="enableValidateDuplicateActionFields">
      <?php $field = $fields->field('validate_duplicate_action_message'); ?>
      <div class="form-group<?php if ($field->error()): ?> has-error<?php endif ?>">
        <label class="control-label"><?php echo e($field->label); ?></label>
        <?php echo Form::input($field->name, $field->validated() ?: $field->value, array('class' => 'form-control', 'placeholder' => '直前アクションが同一だった場合に表示するメッセージ')); ?>
        <p class="help-block">
          <?php echo e($field->error()); ?>
        </p>
      </div>
    </div>
  </div>
