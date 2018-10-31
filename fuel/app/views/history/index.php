<div class="col-sm-12">
  <p>システムに対する操作履歴の一覧です。</p>

  <form class="form-inline well well-sm clearfix" action="<?php echo Uri::current(); ?>" method="get">
    <div class="form-group">
      <label>URI(前方一致)</label>
      <?php echo Form::Input('q[uri]', $q['uri'], array('class' => 'form-control', 'placeholder' => 'URIで絞り込み')); ?>
    </div>
    <div class="form-group">
      <label>担当者ID</label>
      <?php echo Form::Input('q[cis_id]', $q['cis_id'], array('class' => 'form-control', 'placeholder' => '担当者IDで絞り込み')); ?>
    </div>
    <div class="form-group">
      <labek>日付</label>
      <?php echo Form::Input('q[date]', $q['date'], array('class' => 'form-control', 'placeholder' => '日付で絞り込み')); ?>
    </div>
    <div class="form-group"><br />
      <?php echo Form::submit('submit', '絞り込み', array('class' => 'btn btn-primary')); ?>
      <?php echo Form::button('button', 'クリア', array('type' => 'button', 'class' => 'btn btn-default', 'onclick' => 'window.location=\'' . Uri::current() . '\'')); ?>
    </div>
  </form>
<?php if ($histories): ?>

  <div>
    <?php echo $start_item; ?>件目 ～ <?php echo $end_item; ?>件目 /
    全 <?php echo $total_items; ?>件
  </div>

  <table class="table table-striped">
    <thead>
      <tr>
        <th class="col-sm-4">URI</th>
        <th>担当者ID</th>
        <th>時間</th>
        <th>リモートIPアドレス</th>
        <th>PC / iPodTouch</th>
        <th class="col-sm-1">詳細</th>
      </tr>
    </thead>
    <tbody>
<?php foreach ($histories as $history): ?>
      <tr>
        <td><?php echo e($history->method . ' ' . $history->uri); ?></td>
        <td><?php echo e($history->staffm_sh_id); ?></td>
        <td><?php echo $history->timestamp; ?></td>
        <td><?php echo $history->remote_addr; ?></td>
        <td><?php echo e($history->device); ?></td>
        <td><a href="<?php echo Uri::create('/history/view/' . $history->id); ?>" class="btn btn-sm btn-info">詳細</a></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
  <?php echo $pager; ?>
<?php else: ?>
  <div>登録されていません</div>
<?php endif; ?>

</div>
