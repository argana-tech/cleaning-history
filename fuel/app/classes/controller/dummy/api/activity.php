<?php

class Controller_Dummy_Api_Activity extends Controller_Dummy_Api
{

	public function post_validate()
	{
		return $this->response(array(
			'auth_key' => Session::key('session_id'),
			'errors' => array(),
			'post_data' => Input::post(),
		));
	}

	public function post_save()
	{
		return $this->response(array(
			'auth_key' => Session::key('session_id'),
			'activity' => array(
				'id' => 1,
				'action_name' => '利用開始',
				'scope_id' => '123456789',
				'fields' => array(
					array(
						'name' => '対象患者ID',
						'value' => '987654321',
					),
				),
			),
			'post_data' => Input::post(),
		));
	}

	/**
	 * 実際には POST のみ
	 */
	public function get_validate()
	{
		return $this->response(array(
			'auth_key' => Session::key('session_id'),
			'errors' => array(),
			'post_data' => Input::get(),
		));
	}

	public function get_save()
	{
		return $this->response(array(
			'auth_key' => Session::key('session_id'),
			'activity' => array(
				'id' => 1,
				'action_name' => '利用開始',
				'scope_id' => '123456789',
				'fields' => array(
					array(
						'name' => '対象患者ID',
						'value' => '987654321',
					),
				),
			),
			'post_data' => Input::get(),
		));
	}

}
