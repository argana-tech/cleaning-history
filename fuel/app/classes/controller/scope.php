<?php

class Controller_Scope extends Controller_Index
{
	public function action_history($id)
	{
		$this->template->title = 'スコープアクション履歴';
		$viewmodel = ViewModel::forge('scope/history');
		$viewmodel->set('id', $id);
		$this->template->content = Response::forge($viewmodel);
	}
}
