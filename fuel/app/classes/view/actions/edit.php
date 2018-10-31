<?php

class View_Actions_Edit extends ViewModel
{

	public function view()
	{
		$action = Model_Action::find($this->id, array(
			'related' => array(
				'action_fields' => array(
					'order_by' => array('priority' => 'asc'),
				),
			),
		));

		$fields = Fieldset::instance('action');
		$fields->populate($action)->repopulate();
		$fields->field('validate_last_action_enable')->set_value(
			$fields->field('validate_last_action')->value > 0 ? 1 : 0
		);

		$action_fields = array();
		foreach ($action->action_fields as $action_field) {
			$field_array = $action_field->to_array();
			$field_array['tmp_id'] = $field_array['id'];
			$action_fields[] = $field_array;
		}
		$fields->field('fields')->set_value(json_encode($action_fields));

		$this->actions = array(
			'' => '(指定しない)',
		);
		$where = array(
			array('id', '!=', $this->id),
		);
		foreach (Model_Action::find('all', array('where' => $where)) as $action)
		{
			$this->actions[$action->id] = $action->name;
		}

		Asset::js(array('actions/new.js'), array(), 'add_js');
	}

}
