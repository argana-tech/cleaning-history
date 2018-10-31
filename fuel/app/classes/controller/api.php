<?php

class Controller_Api extends Controller_Hybrid
{
	protected $format = 'json';

	public function before()
	{
		parent::before();

		$request_action = Request::active()->action;
		if ($request_action != 'login' and
			$request_action != 'logout')
		{
			$sess = Session::instance();
			if (! $sess->get('cis_id'))
			{
				$res = Response::forge();
				$res->set_header('Content-Type', 'application/json');
				$res->set_status(401);
				$res->body(Format::forge(array(
					'error' => 'require autholize.',
					'auth_key' => Crypt::encode($sess->key('session_id')),
				))->to_json());
				$res->send();
				$this->write_access_log($res);
				exit;
			}
		}
	}

	public function after($response)
	{
		$response = parent::after($response);

		$this->write_access_log($response);

		return $response;
	}

	public function post_login()
	{
		// パスワードは cis_pw で受け付けてチェックが必要
		if ($user = Model_Staffm::login(Input::post('cis_id'), Input::post('cis_pw')))
		{
			$sess = Session::instance();
			$sess->set('cis_id', $user->getId());
			$sess->set('cis_name', $user->getName());
			$sess->set('cis_ka_name', $user->getBusyoName());
			$sess->set('cis_byoto_name', $user->getByotoName());
			return $this->response(array(
				'auth_key' => Crypt::encode($sess->key('session_id')),
				'cis_id' => $sess->get('cis_id'),
				'cis_name' => $sess->get('cis_name'),
				'staffm' => $user->to_array(),
			));
		}

		return $this->response(array(
			'error' => 'unkown cis user',
			'post_data' => Input::post(),
		));
	}

	public function get_list_actions()
	{
		$actions = array();
		foreach (Model_Action::find('all') as $action)
		{
			$actions[] = $action->to_array();
		}

		return $this->response(array(
			'auth_key' => Crypt::encode(Session::key('session_id')),
			'actions' => $actions,
		));
	}

	public function get_action($id)
	{
		$action = Model_Action::find($id, array(
			'related' => array(
				'action_fields' => array(
					'order_by' => array('priority' => 'asc'),
				),
			),
		));

		if ($action)
		{
			$arr = $action->to_array();
			foreach ($action->action_fields as $action_field)
			{
				$arr['fields'][] = $action_field->to_array();
			}
		}
		else
		{
			$arr = false;
		}

		return $this->response(array(
			'auth_key' => Crypt::encode(Session::key('session_id')),
			'action' => $arr,
		));
	}

	public function get_recent_activity()
	{
		$action_id = 1;			/* 利用開始のアクションID */

		$activities = array();
		if ($sess = Session::instance())
		{
			$query = Model_Activity::get_search_query(
				array(
					'date' => \Date::forge()->format('%Y-%m-%d'),
					'action_id' => $action_id,
				),
				'created_desc'
			);

			$staffm_sh_id = $sess->get('cis_id');

			foreach ($query->execute() as $row)
			{
				$activity = Model_Activity::forge($row);
				$activity_array = $activity->to_array();
				$activity_array['activity_fields'] = array();
				foreach ($activity->activity_fields as $activity_field_id => $activity_field)
				{
					$activity_field_array = $activity_field->to_array();
					$activity_field_array['action_field_name'] = $activity_field->get_action_field_name();
					$activity_array['activity_fields'][$activity_field_id] = $activity_field_array;
				}
				$activities[] = $activity_array;
			}
		}
		return $this->response(array(
			'auth_key' => Crypt::encode(Session::key('session_id')),
			'activities' => $activities,
		));
	}

	public function get_logout()
	{
		Session::destroy();
		return $this->response(array(
			'errors' => array(),
		));
	}

	public function get_patient($id)
	{
		$patient = Model_Patient::findByPatientId($id);

		$result = false;
		if ($patient)
		{
			$arr = $patient->to_array();
			$result = true;
		}
		else
		{
			$arr = array();
		}

		return $this->response(array(
			'auth_key' => Crypt::encode(Session::key('session_id')),
			'result' => $result,
			'patient' => $arr,
		));
	}

	public function get_scope()
	{
		$scope_id = Input::get('scope_id');
		$action_id = Input::get('action_id');

		$format_result = false;

		// MEセンターのフォーマットと一致するか
		$mecenter_scope_code_format = Config::get('scope.mecenter_format');
		if ($mecenter_scope_code_format and
			preg_match($mecenter_scope_code_format, $scope_id))
		{
			$format_result = true;
		}

		$last_activity_query = Model_Activity::query();
		$last_activity_query
			->where(
				'scope_id', '=', $scope_id
			)
			->order_by('created_at', 'desc')
		;
		$last_activity = $last_activity_query->get_one();

		$last_activity_result = false;
		if ($last_activity)
		{
			$last_activity_result = true;
			$arr = $last_activity->to_array();
			$arr['action_completed_at'] = $last_activity->get_action_completed_at();
			// 対象の実施記録の実施日時から経過時間を計算する
			$elapsed = Date::time_ago(
				$last_activity->get_action_completed_at('%s'),
				Date::time()->format('%s')
			);

			$arr['elapsed'] = $elapsed;

			$arr['duplicate_action'] = false;
			if ($action = Model_Action::find($action_id))
			{
				if ($action->validate_duplicate_action and
					$last_activity->action_id == $action->id)
				{
					$arr['duplicate_action'] = true;
					$arr['duplicate_action_message'] = $action->validate_duplicate_action_message;
				}
			}

		}
		else
		{
			$arr = array();
		}

		return $this->response(array(
			'auth_key' => Crypt::encode(Session::key('session_id')),
			'result' => $last_activity_result,
			'last_activity' => $arr,
			'format_result' => $format_result,
		));
	}

	public function get_washer($id)
	{
		$washer = Model_Washer::find('first', array(
			'where' => array(
				array('code', '=', $id),
			)
		));

		$result = false;
		$arr = array();
		if ($washer)
		{
			$result = true;
			$arr = $washer->to_array();
		}
		else
		{
			// MEセンターのフォーマットと一致するか
			$mecenter_washer_code_format = Config::get('washer.mecenter_format');
			if ($mecenter_washer_code_format and
				preg_match($mecenter_washer_code_format, $id))
			{
				$result = true;
				$arr = array(
					'code' => $id,
					'type' => '洗浄機洗浄(MEセンター管理)',
				);
			}
		}

		return $this->response(array(
			'auth_key' => Crypt::encode(Session::key('session_id')),
			'result' => $result,
			'washer_data' => $arr,
		));
	}

	protected function write_access_log($response)
	{
		$body = is_object($response->body) ? $response->body->render() : $response->body;

		$access_log = array(
			'uri' => Input::uri(),
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

		return;
	}

}
