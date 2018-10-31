<?php

class Controller_Index extends Controller_Hybrid
{
	public function before()
	{
		parent::before();

		$request_action = Request::active()->action;
		$request_controller = Request::active()->controller;
		if ($request_action != 'login' and
			$request_action != 'logout' and
			$request_action != '404')
		{
			$sess = Session::instance();
			$sess->set_config('expiration_time', (60 * 60));
			if (! $sess->get('cis_id'))
			{
				Session::set_flash('ログインして下さい。');
				Response::redirect('index/login');
				exit;
			}

			$user = Model_Staffm::findByStaffmShId($sess->get('cis_id'));
			if ($request_controller == 'Controller_Accounts' or
				$request_controller == 'Controller_History' or
				($request_controller == 'Controller_Actions' and
					(
						$request_action == 'new' or
						$request_action == 'create' or
						$request_action == 'edit' or
						$request_action == 'update' or
						$request_action == 'remove'
					)
				)
			)
			{
				if ($user->is_admin())
				{

				}
				else
				{
					Session::set_flash('error', '権限がありません。管理者として設定されていないユーザーIDです。');
					Response::redirect('/');
					exit;
				}
			}

			if (is_object($this->template))
			{
				$this->template->current_user_name = $sess->get('cis_name');
				$this->template->current_user = $user;
			}
		}
	}

	public function after($response)
	{
		$response = parent::after($response);

		if (Request::active()->controller == 'Controller_History')
		{
			return $response;
		}

		$body = is_object($response->body) ? $response->body->render() : $response->body;

		$access_log = array(
			'uri' => Input::uri() ?: '/',
			'method' => Input::method(),
			'request_values' => Input::all(),
			'response_values' => $body,
			'device' => Input::get_device_name(),
			'remote_addr' => Input::real_ip(),
		);

		if ($sess = Session::instance())
		{
			$access_log['staffm_sh_id'] = $sess->get('cis_id');
		}

		if ($record = Model_Access_Log::forge($access_log))
		{
			$record->save();
		}

		return $response;
	}

	public function action_index()
	{
		$this->template->title = 'トップページ';
		$this->template->content = Response::forge(ViewModel::forge('index/index'));
	}

	public function action_404()
	{
		$this->template->title = '404 Not Found';
		$this->template->content = Response::forge(ViewModel::forge('index/404'), 404);
	}

	public function action_login()
	{
		if (Input::method() == 'POST')
		{
			$user = null;
			if ($crypted_cis_id = Input::post('crypted_cis_id'))
			{
				$crypted_cis_id = trim($crypted_cis_id, ':');
				$crypted_cis_id_array = explode(':', $crypted_cis_id);
				$cis_id = '';
				$salt = Input::post('salt') || 0;
				foreach ($crypted_cis_id_array as $s)
				{
					$ascii_code = $s - $salt;
					$cis_id .= chr($ascii_code);
				}
				$user = Model_Staffm::findByStaffmShId($cis_id);
			}
			else
			{
				$user = Model_Staffm::login(Input::post('cis_id'), Input::post('cis_pw'));
			}

			if ($user)
			{
				if ($user->is_admin())
				{
					$account = Model_Account::findByStaffmShId($user->sh_id);
					$account->update_last_session();
				}
				$sess = Session::instance();
				$sess->set('cis_id', $user->getId());
				$sess->set('cis_name', $user->getName());
				$sess->set('cis_ka_name', $user->getBusyoName());
				$sess->set('cis_byoto_name', $user->getByotoName());
				return Response::redirect('index/index');
			}
			else
			{
				Session::set_flash('error', 'ログインできませんでした。ユーザー名かパスワードに誤りがあります。');
			}
		}
		return Response::forge(ViewModel::forge('index/login'));
	}

	public function get_logout()
	{
		Session::destroy();
		Session::set_flash('ログアウトしました。');
		Response::redirect('index/login');
	}

}
