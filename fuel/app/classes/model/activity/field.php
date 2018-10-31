<?php

class Model_Activity_Field extends \Orm\Model
{
	protected static $_properties = array(
		'id',
		'activity_id',
		'action_field_id',
		'value',
		'is_patient_id_field',
		'patient_data' => array(
			'data_type' => 'json',
		),
		'is_washer_id_field',
		'washer_data' => array(
			'data_type' => 'json',
		),
	);

	protected static $_observers = array(
		'Orm\Observer_Self' => array(
			'events' => array('before_save'),
		),
		'Orm\Observer_Typing',
	);

	protected static $_table_name = 'activity_fields';

	protected static $_belongs_to = array(
		'action_field' => array(
			'key_to' => 'id',
			'model_to' => 'Model_Action_Field',
			'cascade_delete' => false,
		),
	);

	public function _event_before_save()
	{
		$this->patient_data = null;
		if ($this->is_patient_id_field)
		{
			$patient = Model_Patient::findByPatientId($this->value);
			if ($patient)
			{
				$this->patient_data = $patient->to_array();
			}
		}

		$this->washer_data = null;
		if ($this->is_washer_id_field)
		{
			$washer = Model_Washer::find_by_code($this->value);
			if ($washer)
			{
				$this->washer_data = $washer->to_array();
			}
		}
	}

	public function get_action_field_name()
	{
		if ($action_field = Model_Action_Field::find_by_id($this->action_field_id))
		{
			return $action_field->name;
		}

		return '';
	}
}

