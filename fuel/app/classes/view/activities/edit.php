<?php

class View_Activities_Edit extends ViewModel
{

	public function view()
	{
		$activity = Model_Activity::find($this->id, array(
			'related' => array(
				'activity_fields',
			),
		));
		$this->_view->set_safe('activity', $activity);

		$fields = Fieldset::instance('action');
		$fields->populate($activity)->repopulate();

		$activity_fields = array();
		foreach ($activity->activity_fields as $activity_field) {
			$field_name = 'fields[' . $activity_field->action_field_id . ']';
			$fields->field($field_name)->set_value($activity_field->value);
		}

	}

}
