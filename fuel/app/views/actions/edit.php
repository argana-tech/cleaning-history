<div class="col-sm-12">
  <p>システムに登録されているアクションの設定を変更します。</p>

  <?php echo Form::open(array('action' => 'actions/update', 'class' => 'form', 'id' => 'actionsNew')); ?>

  <?php echo render('actions/_form', array('actions' => $actions)); ?>

  <?php echo Form::hidden('id', $id); ?>
  <div class="form-actions">
    <?php echo Form::submit('submit', '保存する', array('class' => 'btn btn-success')); ?>
    <a href="<?php echo Uri::create('/actions/'); ?>" class="btn btn-sm btn-info">戻る</a>
  </div>

  <?php echo Form::close(); ?>

  <div id="newField" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span></button>
          <h4 class="modal-title">入力項目追加</h4>
        </div><!-- /.modal-header -->
        <div class="modal-body">
          <form class="form" action="#">
            <div class="form-group">
              <label class="control-label">項目名</label>
              <input type="text" class="form-control" name="name">
            </div>
            <div class="form-group">
              <div class="checkbox">
                <input type="hidden" name="is_required" value="0">
                <label><input type="checkbox" name="is_required" value="1">必須項目とする</label>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label">タイプ</label>
              <div class="radio">
                <label><input type="radio" name="type" value="barcode" class="selectType">バーコード読み取り</label>
              </div>
              <div class="radio">
                <label><input type="radio" name="type" value="input" class="selectType">手入力</label>
              </div>
              <div class="radio">
                <label><input type="radio" name="type" value="boolean" class="selectType">はい／いいえ</label>
              </div>
            </div>
            <div class="form-group stringSettings">
              <label class="control-label">文字数制限</label>
              <div class="row">
                <div class="col-sm-4 input-group">
                  <input type="text" name="string_length_min" class="form-control">
                  <span class="input-group-addon">文字以上</span>
                </div>
                <div class="col-sm-4 input-group">
                  <input type="text" name="string_length_max" class="form-control">
                  <span class="input-group-addon">文字以下</span>
                </div>
              </div>
            </div>
            <div class="form-group stringSettings">
              <label class="control-label">正規表現</label>
              <input type="text" name="string_regexp" class="form-control">
            </div>
            <div class="form-group stringSettings">
              <label>その他設定</label>
              <div class="checkbox">
                <label><input type="checkbox" name="is_patient_id_field" value="1">患者番号を記録するフィールドとする</label>
              </div>
              <div class="checkbox">
                <label><input type="checkbox" name="is_washer_id_field" value="1">洗浄・消毒機器IDを記録するフィールドとする</label>
              </div>
            </div>
          </form>
        </div><!-- /.modal-body -->
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">
            <span class="glyphicon glyphicon-remove"></span>
            閉じる
          </button>
          <button type="button" class="btn btn-success" onclick="saveField('newField');">
            <span class="glyphicon glyphicon-plus"></span>
            追加する
          </button>
        </div><!-- /.model-footer -->
      </div>
    </div>
  </div><!-- /.modal -->

  <div id="editField" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span></button>
          <h4 class="modal-title">入力項目変更</h4>
        </div><!-- /.modal-header -->
        <div class="modal-body">
          <form class="form" action="#">
            <div class="form-group">
              <label class="control-label">項目名</label>
              <input type="text" class="form-control" name="name">
            </div>
            <div class="form-group">
              <div class="checkbox">
                <input type="hidden" name="is_required" value="0">
                <label><input type="checkbox" name="is_required" value="1">必須項目とする</label>
              </div>
            </div>
            <div class="form-group">
              <label class="control-label">タイプ</label>
              <div class="radio">
                <label><input type="radio" name="type" value="barcode" class="selectType">バーコード読み取り</label>
              </div>
              <div class="radio">
                <label><input type="radio" name="type" value="input" class="selectType">手入力</label>
              </div>
              <div class="radio">
                <label><input type="radio" name="type" value="boolean" class="selectType">はい／いいえ</label>
              </div>
            </div>
            <div class="form-group stringSettings">
              <label class="control-label">文字数制限</label>
              <div class="row">
                <div class="col-sm-4 input-group">
                  <input type="text" name="string_length_min" class="form-control">
                  <span class="input-group-addon">文字以上</span>
                </div>
                <div class="col-sm-4 input-group">
                  <input type="text" name="string_length_max" class="form-control">
                  <span class="input-group-addon">文字以下</span>
                </div>
              </div>
            </div>
            <div class="form-group stringSettings">
              <label class="control-label">正規表現</label>
              <input type="text" name="string_regexp" class="form-control">
            </div>
            <div class="form-group stringSettings">
              <label>その他設定</label>
              <div class="checkbox">
                <label><input type="checkbox" name="is_patient_id_field" value="1">患者番号を記録するフィールドとする</label>
              </div>
              <div class="checkbox">
                <label><input type="checkbox" name="is_washer_id_field" value="1">洗浄・消毒機器IDを記録するフィールドとする</label>
              </div>
            </div>
            <input type="hidden" name="tmp_id" value="">
            <input type="hidden" name="id" value="">
            <input type="hidden" name="priority" value="">
          </form>
        </div><!-- /.modal-body -->
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">
            <span class="glyphicon glyphicon-remove"></span>
            閉じる
          </button>
          <button type="button" class="btn btn-success" onclick="saveField('editField');">
            <span class="glyphicon glyphicon-plus"></span>
            保存する
          </button>
        </div><!-- /.model-footer -->
      </div>
    </div>
  </div><!-- /.modal -->
</div>

<?php $fields = Fieldset::instance('action'); ?>
<script>
<?php $field = $fields->field('fields'); ?>
<?php if ($field->validated()): ?>
var fields = <?php echo $field->validated(); ?>;
<?php else: ?>
var fields = <?php echo $field->value; ?>;
<?php endif ?>
</script>
