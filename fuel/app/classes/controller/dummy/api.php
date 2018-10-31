<?php

class Controller_Dummy_Api extends Controller_Rest
{

	public function post_login()
	{
		return $this->response(array(
			'auth_key' => Session::key('session_id'),
			'cis_data' => array(
				'id' => '0123456789',
				'name' => '鳥取 太郎',
			),
			'post_data' => Input::post(),
		));
	}

	public function get_list_actions()
	{
		return $this->response(array(
			'auth_key' => Session::key('session_id'),
			'actions' => array(
				array(
					'id' => 1,
					'name' => '利用開始',
				),
				array(
					'id' => 2,
					'name' => '洗浄・消毒終了',
				),
			),
			'post_data' => Input::get(),
		));
	}

	public function get_action($id)
	{
		return $this->response(array(
			'auth_key' => Session::key('session_id'),
			'action' => array(
				'id' => $id,
				'name' => '利用開始',
				'fields' => array(
					array(
						'id' => 1,
						'name' => '対象患者ID',
						'is_require' => true,
						'type' => 'barcode',
						'string_length_min' => 10,
						'string_length_max' => 10,
						'string_regexp' => '',
					),
					array(
						'id' => 2,
						'name' => '手入力',
						'is_require' => false,
						'type' => 'input',
						'string_length_min' => 10,
						'string_length_max' => 10,
						'string_regexp' => '^[0-9]{9}[A-F]$',
					),
					array(
						'id' => 3,
						'name' => '第3者確認を行いましたか？',
						'is_require' => true,
						'type' => 'boolean',
						'string_length_min' => null,
						'string_length_max' => null,
						'string_regexp' => null,
					),
				),
			),
			'post_data' => Input::get(),
		));
	}

	public function get_logout()
	{
		Session::rotate();
		return $this->response(array(
			'auth_key' => Session::key('session_id'),
			'errors' => array(),
			'post_data' => Input::get(),
		));
	}

	/**
	 * ダミーAPI
	 * 実際には POST のみ
	 */
	public function get_login()
	{
		return $this->response(array(
			'auth_key' => Session::key('session_id'),
			'cis_data' => array(
				'id' => '0123456789',
				'name' => '鳥取 太郎',
			),
			'post_data' => Input::get(),
		));
	}

}
