<div class="col-sm-12">
  <p>直前チェックエラーのまま実施登録したときの通知メール送信先を設定します。</p>

  <form class="form-inline well well-sm clearfix" action="<?php echo Uri::current(); ?>" method="get">
    <div class="form-group">
      <label>メールアドレスで絞り込み</label>
      <?php echo Form::Input('q[address]', $q['address'], array('class' => 'form-control', 'placeholder' => 'メールアドレスで絞り込み')); ?>
    </div>
    <div class="form-group"><br />
      <?php echo Form::submit('submit', '絞り込み', array('class' => 'btn btn-primary')); ?>
      <?php echo Form::button('button', 'クリア', array('type' => 'button', 'class' => 'btn btn-default', 'onclick' => 'window.location=\'' . Uri::current() . '\'')); ?>
      <a href="<?php echo Uri::create('/mailto/new'); ?>" class="btn btn-sm btn-success">新規追加</a>
    </div>
  </form>
<?php if ($mailtos): ?>

  <div class="row">
    <div class="col-sm-10">
      <?php echo $start_item; ?>件目 ～ <?php echo $end_item; ?>件目 /
      全 <?php echo $total_items; ?>件
    </div>
  </div>

  <table class="table table-striped">
    <thead>
      <tr>
        <th class="">メールアドレス</th>
        <th class="col-sm-4">備考</th>
        <th class="col-sm-1">編集</th>
        <th class="col-sm-1">削除</th>
      </tr>
    </thead>
    <tbody>
<?php foreach ($mailtos as $mailto): ?>
      <tr>
        <td><?php echo e($mailto->address); ?></td>
        <td><?php echo e($mailto->note); ?></td>
		<td><a href="<?php echo Uri::create('/mailto/edit/' . $mailto->id); ?>" class="btn btn-sm btn-success">編集</a></td>
        <td><a href="<?php echo Uri::create('/mailto/remove/' . $mailto->id); ?>" onclick="return confirmRemove(this, '\'<?php echo e($mailto->address); ?>\' を削除してもよろしいですか？')" class="btn btn-sm btn-danger">削除</a></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
  <?php echo $pager; ?>
<?php else: ?>
  <div>登録されていません</div>
<?php endif; ?>

</div>
