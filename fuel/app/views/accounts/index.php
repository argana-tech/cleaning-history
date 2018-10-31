<div class="col-sm-12">
  <p>管理画面上での管理者権限を有する職員を指定します。</p>

  <form class="form-inline well well-sm clearfix" action="<?php echo Uri::current(); ?>" method="get">
    <div class="form-group">
      <label>職員IDで絞り込み</label>
      <?php echo Form::Input('q[staffm_sh_id]', $q['staffm_sh_id'], array('class' => 'form-control', 'placeholder' => '職員IDで絞り込み')); ?>
    </div>
    <div class="form-group"><br />
      <?php echo Form::submit('submit', '絞り込み', array('class' => 'btn btn-primary')); ?>
      <?php echo Form::button('button', 'クリア', array('type' => 'button', 'class' => 'btn btn-default', 'onclick' => 'window.location=\'' . Uri::current() . '\'')); ?>
    </div>
  </form>
<?php if ($accounts): ?>

  <div class="row">
    <div class="col-sm-10">
      <?php echo $start_item; ?>件目 ～ <?php echo $end_item; ?>件目 /
      全 <?php echo $total_items; ?>件
    </div>
    <div class="col-sm-2 text-right">
      <a href="<?php echo Uri::create('/accounts/new'); ?>" class="btn btn-sm btn-success">新規追加</a>
    </div>
  </div>

  <table class="table table-striped">
    <thead>
      <tr>
        <th class="">職員ID</th>
        <th class="col-sm-4">最終接続日時</th>
        <th class="col-sm-4">最終接続元</th>
        <th class="col-sm-1">削除</th>
      </tr>
    </thead>
    <tbody>
<?php foreach ($accounts as $account): ?>
      <tr>
        <td><?php echo e($account->staffm_sh_id); ?></td>
		<td><?php echo $account->last_session_at; ?></td>
        <td><?php echo $account->last_session_remote_addr; ?></td>
        <td><a href="<?php echo Uri::create('/accounts/remove/' . $account->id); ?>" onclick="return confirmRemove(this, '\'<?php echo e($account->staffm_sh_id); ?>\' を削除してもよろしいですか？')" class="btn btn-sm btn-danger">削除</a></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
  <?php echo $pager; ?>
<?php else: ?>
  <div>登録されていません</div>
<?php endif; ?>

</div>
