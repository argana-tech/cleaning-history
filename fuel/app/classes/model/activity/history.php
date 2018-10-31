<?php

class Model_Activity_History extends \Orm\Model
{
	protected static $_properties = array(
		'id',
		'staffm_sh_id',
		'staffm_sh_name',
		'staffm_ka_name',
		'staffm_byoto_name',
		'action_id',
		'action_staffm_sh_id',
		'action_completed_at' => array(
			'data_type' => 'time_mysql',
		),
		'activity_id',
		'method',
		'field_values',
		'scope_id',
		'device',
		'timestamp',
	);

	protected static $_observers = array(
		'Orm\Observer_Typing',
		'Orm\Observer_CreatedAt' => array(
			'events' => array('before_insert'),
			'property' => 'timestamp',
			'mysql_timestamp' => true,
		),
	);
	protected static $_table_name = 'activity_histories';

	protected static $_belongs_to = array(
		'activity' => array(
		),
		'action' => array(
		),
	);

	public function extractFieldValuesWithScope()
	{
		$extract_values = $this->_extractFieldValues();
		array_unshift($extract_values,
			'実施担当者ID = ' . $this->action_staffm_sh_id,
			'実施日時 = ' . $this->get_action_completed_at(),
			'スコープID = ' . $this->scope_id
		);

		return implode(', ', $extract_values);
	}

	public function extractFieldValues()
	{
		return implode(', ', $this->_extractFieldValues());
	}

	protected function _extractFieldValues()
	{
		$field_values = @unserialize($this->field_values);
		$extract_values = array();

		foreach ((array)$field_values as $field_value)
		{
			$action_field = Model_Action_Field::find($field_value['action_field_id']);
			if ($action_field)
			{
				$extract_values[] = sprintf('%s = %s',
					$action_field->name,
					$field_value['value']
				);
			}
			else
			{
				$extract_values[] = sprintf('action_field_id:%s = %s',
					$field_value['action_field_id'],
					$field_value['value']
				);
			}
		}

		return $extract_values;
	}

	public function get_action_completed_at($format = '%Y-%m-%d %H:%M')
	{
		if (is_object($this->action_completed_at) and
			get_class($this->action_completed_at) == 'Fuel\Core\Date')
		{
			return $this->action_completed_at->format($format);
		}

		try
		{
			return Date::create_from_string(
				$this->action_completed_at,
				'mysql'
			)->format($format);
		}
		catch (UnexpectedValueException $e)
		{
			return $this->action_completed_at;
		}

		return $this->action_completed_at;
	}

	public function get_method()
	{
		switch ($this->method)
		{
			case 'create':
				return '登録';
				break;
			case 'update':
				return '変更';
				break;
			default:
				return $this->method;
		}
	}
}
