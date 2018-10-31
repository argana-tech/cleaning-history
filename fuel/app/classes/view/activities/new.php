<?php

class View_Activities_New extends ViewModel
{

	public function view()
	{
		$fields = Fieldset::instance('action');
		$fields
			->field('action_completed_date')
			->set_value(Date::time()->format('%Y-%m-%d'))
		;

		$this->actions = array(
			'' => '(選択してください)',
		);
		foreach (Model_Action::find('all') as $action)
		{
			$this->actions[$action->id] = $action->name;
		}

		Asset::js(
			array(
				'bootstrap-datepicker-ja.js',
				'bootstrap-timepicker-v3.js',
				'activities/new.js',
			),
			array(),
			'add_js'
		);
		Asset::css(
			array(
				'datepicker.css',
				'bootstrap-timepicker.css',
			),
			array(),
			'add_css'
		);
	}

}
