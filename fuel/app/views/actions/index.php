<div class="col-sm-12">
  <p>システムに登録されているアクションの一覧。</p>

  <form class="form-inline well well-sm clearfix" action="<?php echo Uri::current(); ?>" method="get">
    <div class="form-group">
      <label>アクション名で絞り込み</label>
      <?php echo Form::Input('q[name]', $q['name'], array('class' => 'form-control', 'placeholder' => 'アクション名で絞り込み')); ?>
    </div>
    <div class="form-group"><br />
      <?php echo Form::submit('submit', '絞り込み', array('class' => 'btn btn-primary')); ?>
      <?php echo Form::button('button', 'クリア', array('type' => 'button', 'class' => 'btn btn-default', 'onclick' => 'window.location=\'' . Uri::current() . '\'')); ?>
      <a href="<?php echo Uri::create('/actions/new'); ?>" class="btn btn-sm btn-success">新規追加</a>
    </div>
  </form>
<?php if ($actions): ?>

  <div class="row">
    <div class="col-sm-10">
      <?php echo $start_item; ?>件目 ～ <?php echo $end_item; ?>件目 /
      全 <?php echo $total_items; ?>件
    </div>
  </div>

  <table class="table table-striped">
    <thead>
      <tr>
        <th class="col-sm-4">アクション名</th>
        <th>入力項目</th>
        <th class="col-sm-1">実施履歴</th>
        <th class="col-sm-1">編集</th>
        <th class="col-sm-1">削除</th>
      </tr>
    </thead>
    <tbody>
<?php foreach ($actions as $action): ?>
      <tr>
        <td><?php echo e($action->name); ?></td>
        <td><?php foreach ($action->action_fields as $action_field): ?>
          <?php echo e($action_field->name); ?> /
        <?php endforeach; ?></td>
        <td><a href="<?php echo Uri::create('/activities/index', array(), array('q[action_id]' => $action->id)); ?>" class="btn btn-sm btn-info">実施履歴</a></td>
        <td><a href="<?php echo Uri::create('/actions/edit/' . $action->id); ?>" class="btn btn-sm btn-success">編集</a></td>
        <td><a href="<?php echo Uri::create('/actions/remove/' . $action->id); ?>" onclick="return confirmRemove(this, '\'<?php echo e($action->name); ?>\' を削除してもよろしいですか？')" class="btn btn-sm btn-danger">削除</a></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
  <?php echo $pager; ?>
<?php else: ?>
  <div>登録されていません</div>
<?php endif; ?>

</div>
