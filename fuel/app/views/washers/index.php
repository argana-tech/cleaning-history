<div class="col-sm-12">
  <p>システムに登録されている洗浄・消毒機器情報の一覧。</p>

  <form class="form-inline well well-sm clearfix" action="<?php echo Uri::current(); ?>" method="get">
    <div class="form-group">
      <label>洗浄・消毒機器IDで絞り込み</label>
      <?php echo Form::Input('q[code]', $q['code'], array('class' => 'form-control', 'placeholder' => '洗浄・消毒機器IDで絞り込み')); ?>
    </div>
    <div class="form-group"><br />
      <?php echo Form::submit('submit', '絞り込み', array('class' => 'btn btn-primary')); ?>
      <?php echo Form::button('button', 'クリア', array('type' => 'button', 'class' => 'btn btn-default', 'onclick' => 'window.location=\'' . Uri::current() . '\'')); ?>
      <a href="<?php echo Uri::create('/washers/new'); ?>" class="btn btn-sm btn-success">新規追加</a>
    </div>
  </form>
<?php if ($washers): ?>

  <div class="row">
    <div class="col-sm-10">
      <?php echo $start_item; ?>件目 ～ <?php echo $end_item; ?>件目 /
      全 <?php echo $total_items; ?>件
    </div>
  </div>

  <table class="table table-striped">
    <thead>
      <tr>
        <th>洗浄・消毒機器ID</th>
        <th class="col-sm-2">洗浄・消毒種別</th>
        <th class="col-sm-2">薬剤</th>
        <th class="col-sm-2">設置場所</th>
        <th class="col-sm-1">編集</th>
        <th class="col-sm-1">削除</th>
      </tr>
    </thead>
    <tbody>
<?php foreach ($washers as $washer): ?>
      <tr>
        <td><?php echo e($washer->code); ?></td>
        <td><?php echo e($washer->type); ?></td>
        <td><?php echo e($washer->solution); ?></td>
        <td><?php echo e($washer->location); ?></td>
        <td><a href="<?php echo Uri::create('/washers/edit/' . $washer->id); ?>" class="btn btn-sm btn-success">編集</a></td>
        <td><a href="<?php echo Uri::create('/washers/remove/' . $washer->id); ?>" onclick="return confirmRemove(this, '\'<?php echo e($washer->code); ?>\' を削除してもよろしいですか？')" class="btn btn-sm btn-danger">削除</a></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
  <?php echo $pager; ?>
<?php else: ?>
  <div>登録されていません</div>
<?php endif; ?>

</div>
