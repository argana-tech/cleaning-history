<div class="col-sm-12">
  <p>システムに対する操作履歴の詳細です。</p>

  <div class="form-group">
    <label class="control-label">担当者ID</label>
    <p class="help-block">
      <?php echo $access_log->staffm_sh_id; ?>
    </p>
  </div>

  <div class="form-group">
    <label class="control-label">URI</label>
    <p class="help-block">
      <?php echo $access_log->method; ?>
      <?php echo $access_log->uri; ?>
    </p>
  </div>

  <div class="form-group">
    <label class="control-label">送信データ</label>
    <textarea readonly="readonly" class="form-control" rows="10"><?php print_r($access_log->request_values); ?></textarea>
  </div>

  <div class="form-group">
    <label class="control-label">レスポンスデータ</label>
    <textarea readonly="readonly" class="form-control" rows="10"><?php echo ($access_log->response_values); ?></textarea>
  </div>

  <div class="form-group">
    <label class="control-label">デバイス</label>
    <p class="help-block">
      <?php echo $access_log->device; ?>
    </p>
  </div>

  <div class="form-group">
    <label class="control-label">リモートIPアドレス</label>
    <p class="help-block">
      <?php echo $access_log->remote_addr; ?>
    </p>
  </div>

  <div class="form-group">
    <label class="control-label">アクセス日時</label>
    <p class="help-block">
      <?php echo $access_log->timestamp; ?>
    </p>
  </div>
</div>

<div class="form-actions">
  <a href="<?php echo Uri::create('/history'); ?>" class="btn btn-sm btn-info">戻る</a>
</div>
