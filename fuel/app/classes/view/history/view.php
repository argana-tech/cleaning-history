<?php

class View_History_View extends ViewModel
{
	public function view()
	{
		$access_log = Model_Access_Log::find($this->id);
		$this->_view->set_safe('access_log', $access_log);
	}
}
