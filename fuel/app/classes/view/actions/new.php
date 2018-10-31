<?php

class View_Actions_New extends ViewModel
{

	public function view()
	{
		$this->actions = array(
			'' => '(指定しない)',
		);
		foreach (Model_Action::find('all') as $action)
		{
			$this->actions[$action->id] = $action->name;
		}

		Asset::js(array('actions/new.js'), array(), 'add_js');
	}

}
