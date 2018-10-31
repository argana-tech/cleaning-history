<div class="col-sm-12">
  <div class="list-group">
    <a class="list-group-item" href="<?php echo Uri::create('/actions'); ?>">
      <h4 class="list-group-item-heading">アクション管理</h4>
      <p class="list-group-item-text">入力アプリで行えるアクションを管理します。</p>
    </a>
    <a class="list-group-item" href="<?php echo Uri::create('/activities'); ?>">
      <h4 class="list-group-item-heading">洗浄履歴</h4>
      <p class="list-group-item-text">各スコープの履歴を確認できます。</p>
    </a>
    <a class="list-group-item" href="<?php echo Uri::create('/washers'); ?>">
      <h4 class="list-group-item-heading">洗浄・消毒機器情報</h4>
      <p class="list-group-item-text">システムに登録されている洗浄・消毒機器の情報を確認できます。</p>
    </a>
    <a class="list-group-item" href="<?php echo Uri::create('/history'); ?>">
      <h4 class="list-group-item-heading">操作ログ</h4>
      <p class="list-group-item-text">全担当者の操作履歴を確認できます。(要管理者権限)</p>
    </a>
    <a class="list-group-item" href="<?php echo Uri::create('/accounts'); ?>">
      <h4 class="list-group-item-heading">管理者一覧</h4>
      <p class="list-group-item-text">システム内で管理者権限を許可する職員ID一覧。(要管理者権限)</p>
    </a>
  </div>
</div><!-- /.col-sm-12 -->
