<?php

class Model_Action_Field extends \Orm\Model_Soft
{
	protected static $_properties = array(
		'id',
		'action_id',
		'name',
		'is_required',
		'type',
		'string_length_min',
		'string_length_max',
		'string_regexp',
		'priority',
		'created_account_id',
		'updated_account_id',
		'removed_at',
		'removed_account_id',
		'created_at',
		'updated_at',
		'tmp_id',
		'is_patient_id_field',
		'is_washer_id_field',
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
	protected static $_table_name = 'action_fields';
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
		foreach(array('string_length_min', 'string_length_max', 'string_regexp') as $col) {
			if ($this->{$col} === '') {
				$this->{$col} = null;
			}
		}
	}

}
