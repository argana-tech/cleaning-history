<div class="col-sm-8">
  <p>直前チェックエラーのまま実施登録したときの通知メール送信先を追加登録します。</p>

  <?php echo Form::open(array('action' => 'mailto/create', 'class' => 'form')); ?>

  <?php echo render('mailto/_form'); ?>

  <div class="form-actions">
    <?php echo Form::submit('submit', '保存する', array('class' => 'btn btn-success')); ?>
    <a href="<?php echo Uri::create('/mailto'); ?>" class="btn btn-sm btn-info">戻る</a>
  </div>

  <?php echo Form::close(); ?>

</div>
