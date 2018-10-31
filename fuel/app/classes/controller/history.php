<?php

class Controller_History extends Controller_Index
{
	public function action_index()
	{
		$this->template->title = '操作ログ';
		$this->template->content = Response::forge(ViewModel::forge('history/index'));
	}

	public function action_view($id)
	{
		$this->template->title = '操作ログ詳細';
		$viewmodel = ViewModel::forge('history/view');
		$viewmodel->set('id', $id);
		$this->template->content = Response::forge($viewmodel);
	}
}
