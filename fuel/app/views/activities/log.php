<div class="col-sm-12">
  <p>実施記録の編集履歴一覧です。</p>

<?php if ($activity_histories): ?>

  <div>
    全 <?php echo count($activity_histories); ?>件
  </div>

  <table class="table table-striped editable">
    <thead>
      <tr>
        <th class="col-sm-2">変更日時</th>
        <th>操作担当者ID</th>
        <th>操作</th>
        <th>変更内容</th>
	    <th>操作デバイス</th>
      </tr>
    </thead>
    <tbody>
<?php foreach ($activity_histories as $activity_history): ?>
      <tr>
        <td><?php echo $activity_history->timestamp; ?></td>
        <td>
<?php if ($activity_history->staffm_ka_name): ?>
          <?php echo e($activity_history->staffm_ka_name); ?><br />
<?php endif ?>
<?php if ($activity_history->staffm_sh_name): ?>
          <?php echo e(trim(mb_convert_kana($activity_history->staffm_sh_name, 's'))); ?><br />
<?php endif ?>
          <?php echo e($activity_history->staffm_sh_id); ?>
        </td>
        <td><?php echo $activity_history->get_method(); ?></td>
        <td>
          <?php echo $activity_history->extractFieldValuesWithScope(); ?>
        </td>
        <td><?php echo $activity_history->device; ?></td>
      </tr>
<?php endforeach; ?>
    </tbody>
  </table>
<?php else: ?>
  <div>登録されていません</div>
<?php endif; ?>

<div class="form-actions">
<a href="javascript:window.history.go(-1)" class="btn btn-sm btn-info">戻る</a>
</div>

</div>

