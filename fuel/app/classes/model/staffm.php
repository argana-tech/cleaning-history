<?php

class Model_Staffm extends \Orm\Model
{
	protected static $_properties = array(
		'sh_id',
		'sh_st_date',
		'sh_ed_date',
		'active_flg',
		'sh_name',
		'sh_kana_name',
		'sh_type',
		'sh_type_nm',
		'ka_cd',
		'ka_name',
		'byoto_cd',
		'byoto_name',
		'user_id',
		'password',
		'pw_update_date',
		'idm_no',
		'tel1',
		'tel2',
		'last_op_id',
		'last_date',
		'last_time',
	);

	protected static $_primary_key = array('sh_id', 'sh_st_date');

	protected $_id_col = 'sh_id';     /* ID のカラム名 */
	protected $_name_col = 'sh_name'; /* 氏名のカラム名 */
	protected $_busyo_col = 'ka_name'; /* 部署名のカラム名 */
	protected $_byoto_col = 'byoto_name'; /* 病棟名のカラム名 */

	protected static $_table_name = 'staffm';

	public static function findByStaffmShId($staffm_sh_id)
	{
		return self::find('first', array('where' => array(
			'sh_id' => $staffm_sh_id,
			'active_flg' => 1,
			'sh_ed_date' => '99991231',
		)));
	}

	public function getId()
	{
		return $this->{$this->_id_col};
	}

	public function getName()
	{
		return $this->{$this->_name_col};
	}

	public function getBusyoName()
	{
		return $this->{$this->_busyo_col};
	}

	public function getByotoName()
	{
		return $this->{$this->_byoto_col};
	}

	public static function login($staffm_id, $staffm_pw)
	{
		if (empty($staffm_id) or empty($staffm_pw))
		{
			return false;
		}

		$record = self::find('first', array('where' => array(
			'sh_id' => $staffm_id,
			'active_flg' => 1,
			'sh_ed_date' => '99991231',
		)));

		if ($record and
			$record->password == $staffm_pw)
		{
			return $record;
		}

		return false;
	}

	public function is_admin()
	{
		if (Model_Account::find('first', array('where' => array('staffm_sh_id' => $this->sh_id))))
		{
			return true;
		}

		return false;
	}

	public static function is_include($sh_id)
	{
		return self::query()->where(array(
			'sh_id' => $sh_id,
			'active_flg' => 1,
		))->count();
	}

}
