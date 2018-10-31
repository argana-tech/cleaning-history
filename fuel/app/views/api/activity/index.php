<?php echo Form::open(array('action' => 'api/activity/validate.json', 'class' => 'form well well-sm')); ?>
  <h4>validate</h4>

  <div class="form-group">
    <label class="control-label">担当者ID</label>
    <input type="text" value="111111111" name="cis_id" class="form-control">
  </div>

  <div class="form-group">
    <label class="control-label">アクションID</label>
    <input type="text" value="38" name="action_id" class="form-control">
  </div>

  <div class="form-group">
    <label class="control-label">スコープID</label>
    <input type="text" value="123456789A" name="scope_id" class="form-control">
  </div>

  <div class="form-group">
    <label class="control-label">入力項目(1) - action_field id = 1</label>
    <input type="text" value="33344411122A" name="fields[1]" class="form-control">
  </div>

  <?php echo Form::submit('submit', 'validate', array('class' => 'btn btn-default')); ?>

<?php echo Form::close(); ?>

<?php echo Form::open(array('action' => 'api/activity/validate.json', 'class' => 'form well well-sm')); ?>
  <h4>validate</h4>

  <div class="form-group">
    <label class="control-label">担当者ID</label>
    <input type="text" value="111111111" name="cis_id" class="form-control">
  </div>

  <div class="form-group">
    <label class="control-label">アクションID</label>
    <input type="text" value="2" name="action_id" class="form-control">
  </div>

  <div class="form-group">
    <label class="control-label">スコープID</label>
    <input type="text" value="123456789A" name="scope_id" class="form-control">
  </div>

  <div class="form-group">
	   <label class="control-label">入力項目(1) - action_field id = 2(洗浄機器)</label>
    <input type="text" value="33344411122A" name="fields[2]" class="form-control">
  </div>

  <div class="form-group">
	   <label class="control-label">入力項目(2) - action_field id = 3(洗浄種別)</label>
    <input type="text" value="33344411122A" name="fields[3]" class="form-control">
  </div>

  <?php echo Form::submit('submit', 'validate', array('class' => 'btn btn-default')); ?>

<?php echo Form::close(); ?>

<?php echo Form::open(array('action' => 'api/activity/save.json', 'class' => 'form well well-sm')); ?>
  <h4>save</h4>

  <div class="form-group">
    <label class="control-label">アクティビティID</label>
    <input type="text" value="" name="activity_id" class="form-control">
  </div>

  <div class="form-group">
    <label class="control-label">担当者ID</label>
    <input type="text" value="111111111" name="staffm_sh_id" class="form-control">
  </div>

  <div class="form-group">
    <label class="control-label">アクションID</label>
    <input type="text" value="38" name="action_id" class="form-control">
  </div>

  <div class="form-group">
    <label class="control-label">スコープID</label>
    <input type="text" value="123456789A" name="scope_id" class="form-control">
  </div>

  <div class="form-group">
    <label class="control-label">入力項目(1) - action_field id = 1</label>
    <input type="text" value="33344411122A" name="fields[1]" class="form-control">
  </div>

  <?php echo Form::submit('submit', 'save', array('class' => 'btn btn-default')); ?>

<?php echo Form::close(); ?>



