<?php

class Model_Washer extends \Orm\Model_Soft
{
	protected static $_properties = array(
		'id',
		'code' => array(
			'data_type' => 'varchar',
			'label' => '機器ID',
			'validation' => array(
				'required',
				'max_length' => array(64),
				'unique_code' => array('code', 'self_id'),
			),
		),
		'type' => array(
			'data_type' => 'varchar',
			'label' => '洗浄種別',
			'validation' => array(
				'required',
				'max_length' => array(64),
			),
		),
		'solution' => array(
			'data_type' => 'varchar',
			'label' => '薬液',
			'validation' => array(
				'max_length' => array(128),
			),
		),
		'location' => array(
			'data_type' => 'varchar',
			'label' => '設置場所',
			'validation' => array(
				'max_length' => array(128),
			),
		),
		'alert_message' => array(
			'data_type' => 'varchar',
			'label' => 'アプリに表示するメッセージ',
			'validation' => array(
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
	protected static $_table_name = 'washers';
	protected static $_soft_delete = array(
		'deleted_field' => 'removed_at',
		'mysql_timestamp' => true,
	);

	protected static $_to_array_exclude = array(
		'created_account_id',
		'updated_account_id',
		'removed_at',
		'removed_account_id',
	);

	public function _event_before_save()
	{
		foreach(array('solution', 'location', 'alert_message') as $col) {
			if ($this->{$col} === '') {
				$this->{$col} = null;
			}
		}
	}

	public static function find_by_code($code = null)
	{
		return self::find('first', array(
			'where' => array(
				array('code', '=', $code),
			),
		));
	}


	public static function _validation_unique_code($val, $option = null, $exclude_column = null)
	{
		$active = Validation::active();
		$active->set_message('unique_code', '既に登録されている値です。');

		$active_field = Validation::active_field();

		$column = $active_field->name;
		if (!empty($option))
		{
			$column = $option;
		}

		$where = array(
			array($column, '=', $val),
		);

		$id_field = $active->fieldset()->field($exclude_column);
		if ($id_field->input())
		{
			$where[] = array('id', '!=', $id_field->input());
		}

		$query = self::query()->where($where);
		return $query->count() == 0;
	}

}
