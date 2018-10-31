<?php

class Model_Configure_Mailto extends \Orm\Model_Soft
{
	protected static $_properties = array(
		'id',
		'address' => array(
			'datatype' => 'varchar',
			'label' => 'メールアドレス',
			'validation' => array(
				'required',
				'max_length' => array(255),
				'valid_email',
				'unique_code' => array('address', 'self_id'),
			),
		),
		'note' => array(
			'datatype' => 'varchar',
			'label' => '備考',
			'validation' => array(
				'max_length' => array(255),
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
		'Orm\Observer_CreatedAt' => array(
			'events' => array('before_insert'),
			'mysql_timestamp' => true,
		),
		'Orm\Observer_UpdatedAt' => array(
			'events' => array('before_update'),
			'mysql_timestamp' => true,
		),
	);
	protected static $_table_name = 'configure_mailto';
	protected static $_soft_delete = array(
		'deleted_field' => 'removed_at',
		'mysql_timestamp' => true,
	);

	public static function get_enable_addresses()
	{
		$mailto = array();
		foreach (self::find('all') as $row)
		{
			$mailto[] = $row->address;
		}

		return $mailto;
	}

	public static function _validation_unique($val, $option = null)
	{
		$active = Validation::active();
		$active->set_message('unique', '既に登録されている値です。');

		$active_field = Validation::active_field();

		$column = $active_field->name;
		if (!empty($option))
		{
			$column = $option;
		}

		$query = self::query()->where($column, $val);
		return $query->count() == 0;
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
