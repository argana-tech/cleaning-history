<?php

class Model_Account extends \Orm\Model_Soft
{
	protected static $_properties = array(
		'id',
		'staffm_sh_id' => array(
			'data_type' => 'varchar',
			'label' => '職員ID',
			'validation' => array(
				'required',
				'max_length' => array(8),
				'exists_staffm',
				'unique' => array('staffm_sh_id'),
			),
		),
		'last_session_at',
		'last_session_remote_addr',
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
	protected static $_table_name = 'accounts';
	protected static $_soft_delete = array(
		'deleted_field' => 'removed_at',
		'mysql_timestamp' => true,
	);

	public static function findByStaffmShId($staffm_sh_id)
	{
		return self::find('first', array('where' => array(
			'staffm_sh_id' => $staffm_sh_id,
		)));
	}

	public function update_last_session()
	{
		$this->last_session_at = DB::expr('CURRENT_TIMESTAMP');
		$this->last_session_remote_addr = Input::real_ip();
		$this->save();
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

	public static function _validation_exists_staffm($val)
	{
		$active = Validation::active();
		$active->set_message('exists_staffm', '有効な職員IDではありません。');

		$active_field = Validation::active_field();

		$staffm_record = Model_Staffm::findByStaffmShId($val);
		if ($staffm_record) {
			return true;
		}

		return false;
	}

}
