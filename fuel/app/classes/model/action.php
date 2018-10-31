<?php

class Model_Action extends \Orm\Model_Soft
{
	protected static $_properties = array(
		'id',
		'name' => array(
			'data_type' => 'varchar',
			'label' => 'アクション名',
			'validation' => array(
				'required',
				'max_length' => array(64),
			),
		),
		'validate_last_action' => array(
			'data_type' => 'int',
			'label' => '直前アクション制限回避',
			'validation' => array(
				'check_validate_last_action_select',
			),
		),
		'validate_last_action_id' => array(
			'data_type' => 'int',
			'label' => '直前アクション名',
			'validation' => array(
				'check_validate_last_action_select',
			),
		),
		'validate_last_action_error_message' => array(
			'data_type' => 'varchar',
			'label' => '直前アクションエラーメッセージ',
			'validation' => array(
				'check_validate_last_action_input',
				'max_length' => array(128),
			),
		),
		'validate_last_action_error_message_on_completed' => array(
			'data_type' => 'varchar',
			'label' => '直前アクションエラーがあった場合の保存後に表示するメッセージ',
			'validation' => array(
				'check_validate_last_action_input',
				'max_length' => array(128),
			),
		),

		'send_notice_mail_on_invalid_last_action' => array(
			'data_type' => 'int',
			'label' => '直前アクションエラーがあった場合にそのまま保存した時にメール通知をおこなうか',
			'validation' => array(
				'check_validate_last_action_select',
			),
		),
		'invalid_last_action_notice_mail_subject' => array(
			'data_type' => 'varchar',
			'label' => '直前アクションエラーの通知メールの件名',
			'validation' => array(
				'max_length' => array(128),
				'check_send_notice_mail',
			),
		),
		'invalid_last_action_notice_mail_body' => array(
			'data_type' => 'varchar',
			'label' => '直前アクションエラーの通知メールの本文',
			'validation' => array(
				'check_send_notice_mail',
			),
		),

		'saved_message' => array(
			'data_type' => 'varchar',
			'label' => '保存後に表示するメッセージ',
			'validation' => array(
				'max_length' => array(128),
			),
		),
		'return_elapsed_last_action' => array(
			'data_type' => 'int',
			'label' => '前回アクションからの経過時間を保存時に表示するか',
			'validation' => array(
				'required',
			),
		),
		'return_elapsed_last_action_id' => array(
			'data_type' => 'int',
			'label' => '経過時間を計算する対象のアクション',
			'validation' => array(
				'check_return_elapsed_last_action_select',
			),
		),
		'validate_duplicate_action' => array(
			'data_type' => 'int',
			'label' => '直前アクションが同一アクションかどうかチェックするか',
			'validation' => array(
			),
		),
		'validate_duplicate_action_message' => array(
			'data_type' => 'varchar',
			'label' => '直前アクションが同一アクションだった場合のメッセージ',
			'validation' => array(
				'check_validate_duplicate_action_input',
				'max_length' => array(128),
			),
		),
		'created_account_id',
		'updated_account_id',
		'removed_at',
		'removed_account_id',
		'created_at',
		'updated_at',
	);

	protected static $_observers = array(
		'Orm\Observer_Self' => array(
			'events' => array('before_save'),
		),
		'Orm\Observer_Typing',
		'Orm\Observer_CreatedAt' => array(
			'events' => array('before_insert'),
			'mysql_timestamp' => true,
		),
		'Orm\Observer_UpdatedAt' => array(
			'events' => array('before_update'),
			'mysql_timestamp' => true,
		),
	);
	protected static $_table_name = 'actions';
	protected static $_soft_delete = array(
		'deleted_field' => 'removed_at',
		'mysql_timestamp' => true,
	);

	protected static $_has_many = array(
		'action_fields' => array(
			'cascade_delete' => true,
		),
		'activity_histories' => array(
			'cascade_delete' => false,
		),
	);

	protected static $_to_array_exclude = array(
		'created_account_id',
		'updated_account_id',
		'removed_at',
		'removed_account_id',
	);

	public function _event_before_save()
	{
		foreach(array('validate_last_action_error_message', 'validate_last_action_id') as $col) {
			if ($this->{$col} === '') {
				$this->{$col} = null;
			}
		}

		if ($this->validate_last_action == null)
		{
			$this->validate_last_action = 0;
		}

		if (! $this->validate_last_action)
		{
			$this->validate_last_action_id = null;
			$this->validate_last_action_error_message = null;
		}

		if ($this->validate_duplicate_action == null)
		{
			$this->validate_duplicate_action = 0;
		}

		if (! $this->validate_duplicate_action)
		{
			$this->validate_duplicate_action_message = null;
		}
	}

	public static function _validation_check_validate_last_action_select($val)
	{
		$active = Validation::active();
		$validate_last_action_enable = $active->fieldset()->field('validate_last_action_enable');

		// 直前アクション制限をしない
		if (! $validate_last_action_enable->input())
		{
			return true;
		}

		// 直前アクション制限をする
		if ($val == '')
		{
			$active->set_message(
				'check_validate_last_action_select',
				'":label" を選択してください。'
			);
			return false;
		}

		return true;
	}

	public static function _validation_check_validate_last_action_input($val)
	{
		$active = Validation::active();
		$validate_last_action_enable = $active->fieldset()->field('validate_last_action_enable');

		// 直前アクション制限をしない
		if (! $validate_last_action_enable->input())
		{
			return true;
		}

		// 直前アクション制限をする
		if ($val == '')
		{
			$active->set_message(
				'check_validate_last_action_input',
				'":label" を入力してください。'
			);
			return false;
		}

		return true;
	}

	public static function _validation_check_return_elapsed_last_action_select($val)
	{
		$active = Validation::active();
		$return_elapsed_last_action = $active->fieldset()->field('return_elapsed_last_action');

		// 経過時間を保存時に表示しない
		if (! $return_elapsed_last_action->input())
		{
			return true;
		}

		// 経過時間を保存時に表示する
		if ($val == '')
		{
			$active->set_message(
				'check_return_elapsed_last_action_select',
				'":label" を選択してください。'
			);
			return false;
		}

		return true;
	}

	public static function _validation_check_validate_duplicate_action_input($val)
	{
		$active = Validation::active();
		$validate_duplicate_action = $active->fieldset()->field('validate_duplicate_action');

		// 直前アクションが同一かどうかチェックしない
		if (! $validate_duplicate_action->input())
		{
			return true;
		}

		// 直前アクションをチェックする
		if ($val == '')
		{
			$active->set_message(
				'check_validate_duplicate_action_input',
				'":label" を入力してください。'
			);
			return false;
		}

		return true;
	}

	public static function _validation_check_send_notice_mail($val)
	{
		$active = Validation::active();
		$send_notice_mail = $active->fieldset()->field('send_notice_mail_on_invalid_last_action');

		// 直前アクションが同一かどうかチェックしない
		if (! $send_notice_mail->input())
		{
			return true;
		}

		// 直前アクションをチェックする
		if ($val == '')
		{
			$active->set_message(
				'check_send_notice_mail',
				'":label" を入力してください。'
			);
			return false;
		}

		return true;
	}
}
