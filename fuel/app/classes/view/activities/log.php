<?php

class View_Activities_Log extends ViewModel
{
	public function view()
	{
		$this->_view->set_safe(
			'activity',
			Model_Activity::find($this->id)
		);

		$this->_view->set_safe(
			'activity_histories',
			Model_Activity_History::find('all', array(
				'where' => array(array('activity_id', '=', $this->id)),
				'order_by' => array('timestamp' => 'desc'),
			))
		);

	}
}
