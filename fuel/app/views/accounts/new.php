<div class="col-sm-8">
  <p>職員IDを指定して管理者権限を設定します。</p>

  <?php echo Form::open(array('action' => 'accounts/create', 'class' => 'form')); ?>

  <?php echo render('accounts/_form'); ?>

  <div class="form-actions">
    <?php echo Form::submit('submit', '保存する', array('class' => 'btn btn-success')); ?>
    <a href="<?php echo Uri::create('/accounts/'); ?>" class="btn btn-sm btn-info">戻る</a>
  </div>

  <?php echo Form::close(); ?>

</div>
