<div class="col-sm-8">
  <p>MEセンター管理外の洗浄・消毒機器情報を登録します。</p>

  <?php echo Form::open(array('action' => 'washers/create', 'class' => 'form')); ?>

  <?php echo render('washers/_form'); ?>

  <div class="form-actions">
    <?php echo Form::submit('submit', '保存する', array('class' => 'btn btn-success')); ?>
    <a href="<?php echo Uri::create('/washers/'); ?>" class="btn btn-sm btn-info">戻る</a>
  </div>

  <?php echo Form::close(); ?>

</div>
