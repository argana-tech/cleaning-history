<?php

class Model_Patient extends \Orm\Model
{
	protected static $_connection = 'patient-record';

	protected static $_properties = array(
		'PT_ID',
		'PT_KN_NAME',
		'PT_KJ_NAME',
		'PT_FST_NAME',
		'PT_MDL_NAME',
		'PT_LST_NAME',
		'PT_HN_NAME',
		'PT_KN_LGNAME',
		'PT_KJ_LGNAME',
		'PT_SEX',
		'PT_BIRTH',
		'COL_CD',
		'PT_CONTRY',
		'PT_ZIP',
		'PT_ADDR',
		'PT_ADDR_CD',
		'PT_LADDR',
		'PT_LADDR_CD',
		'PT_BADDR',
		'PT_BADDR_CD',
		'PT_TEL',
		'PT_RNRK_KBN',
		'PT_RNRK_TEL',
		'PT_STATUS',
		'PT_FI_DT',
		'NYUIN_NUM',
		'S_HOKEN',
		'PAST_NAME',
		'PAST_KN_NAME',
		'PAST_KJ_LGNAME',
		'PAST_KN_LGNAME',
		'SAME_NAME_FLG',
		'PT_FLG1',
		'PT_FLG2',
		'PT_FLG3',
		'PT_FLG4',
		'PT_FLG5',
		'LAST_DATE',
		'LAST_TIME',
		'LAST_OP_ID',
	);

	protected static $_primary_key = array('PT_ID');

	protected static $_id_col = 'PT_ID';     /* ID のカラム名 */
	protected static $_name_col = 'PT_KJ_NAME'; /* 氏名のカラム名 */

	protected static $_table_name = 'TKANJA';

	public static function findByPatientId($patient_id)
	{

		$sql = "SELECT * FROM " . self::$_table_name . " WHERE " . self::$_id_col . " = " . DB::quote($patient_id);
		$query = DB::query($sql);

		$rows = $query->execute('patient-record')->as_array();

		if (empty($rows))
		{
			return false;
		}

		foreach ($rows as $id => $row)
		{
			foreach ($row as $col => $val)
			{
				$row[$col] = mb_convert_encoding($val, 'UTF-8', 'EUCJP-Win');
			}
			$rows[$id] = $row;
		}

		return self::forge($rows[0]);
	}

	public function getName()
	{
		return $this->{self::$_name_col};
	}
}
