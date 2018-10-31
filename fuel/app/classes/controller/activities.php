<?php

class Controller_Activities extends Controller_Index
{
	protected $format = 'json';

	public function action_index()
	{
		$this->template->title = '洗浄履歴';
		$this->template->content = Response::forge(ViewModel::forge('scope/index'));
	}

	public function action_download()
	{
		$action_fields = Model_Action_Field::find('all', array('order' => 'id'));
		$q = Input::get('q');
		$query = Model_Activity::get_search_query(
			$q,
			Input::get('sort')
		);

		$activities = array();
		$header = array(
			'実施日時',
			'担当者ID',
			'担当者所属診療科・部署',
			'担当者所属病棟',
			'アクション名',
			'直前チェックエラー',
			'スコープID',
		);
		foreach ($action_fields as $action_field)
		{
			if (isset($q['action_id']) &&
			    !empty($q['action_id']) &&
			    $action_field->action_id != $q['action_id']) {
				continue;
			}
			$header[] = $action_field->name;
		}
		$activities[] = $header;

		foreach ($query->execute() as $row)
		{
			$activity = Model_Activity::forge($row);
			$line = array_fill(0, 7 + count($action_fields), '');
			$line[0] = $activity->created_at;
			$line[1] = $activity->staffm_sh_id;
			$line[2] = $activity->staffm_ka_name;
			$line[3] = $activity->staffm_byoto_name;
			$line[4] = $activity->action_name;
			$line[5] = $activity->has_eve_check_error ? 'あり' : 'なし';
			$line[6] = $activity->scope_id;

			$i = 0;
			foreach ($action_fields as $action_field)
			{
				if (isset($q['action_id']) &&
				    !empty($q['action_id']) &&
				    $action_field->action_id != $q['action_id']) {
					continue;
				}
				$key = $i + 7;
				foreach ($activity->activity_fields as $activity_field)
				{
					if ($action_field->id == $activity_field->action_field_id)
					{
						$line[$key] = $activity_field->value;
					}
				}
				$i++;
			}
			$activities[] = $line;
		}

		$filename = '洗浄履歴.csv';
		if (strpos(Input::user_agent(), 'MSIE') !== FALSE)
		{
			$filename = mb_convert_encoding($filename, 'SJIS-win', 'UTF-8');
		}

		$response = Response::forge();
		$response->set_header('Content-Type', 'application/csv');
		$response->set_header('Content-Disposition', 'attachment; filename="' . $filename . '"');
		$response->body(Format::forge($activities)->to_csv());
		$response->send_headers();
		$response->send();
		exit;

	}

	public function post_update()
	{
		$id = Input::post('activity_id');

		$fields = $this->_initActivityField(Input::post('action_field_id'));
		$fields->populate(Input::post());
		$validation = $fields->validation();
		if (! $validation->run())
		{
			$errors = array();

			foreach ($validation->error() as $field => $error)
			{
				$errors[] = $error->get_message();
			}
			return $this->response(array(
				'post_data' => Input::post(),
				'errors' => $errors,
			));
		}

		if ($activity = Model_Activity::find($id))
		{
			foreach ($activity->activity_fields as $i => $activity_field)
			{
				if ($activity_field->action_field_id == Input::post('action_field_id'))
				{
					$activity_field->value = $fields->validated('value');
					$activity->activity_fields[$i] = $activity_field;
				}
			}

			$sess = Session::instance();
			$activity->updated_staffm_sh_id = $sess->get('cis_id');
			$activity->updated_at = time();
			if ($activity->save(null, true))
			{
				return $this->response(array(
					'post_data' => Input::post(),
					'errors' => array(),
				));
			}
		}

		return $this->response(array(
			'post_data' => Input::post(),
			'errors' => array(
				'実施記録が見つかりませんでした。',
			),
		));
	}

	public function action_log($id)
	{
		$activity = Model_Activity::find($id);
		if (! $activity)
		{
			Session::set_flash('error', '実施記録が見つかりませんでした。');
			Response::redirect('actions/index');
		}

		$this->template->title = '実施記録変更履歴';
		$viewmodel = ViewModel::forge('activities/log');
		$viewmodel->set('id', $id);
		$this->template->content = Response::forge($viewmodel);
	}

	public function action_remove($id)
	{
		if (Input::method() != 'POST')
		{
			Session::set_flash('error', '不正なアクセスです。もう一度はじめからやり直してください。');
			return Response::redirect('index');
		}

		$activity = Model_Activity::find($id);
		if ($activity and $activity->delete())
		{
			Session::set_flash('success', '実施記録を削除しました。');
			if (Input::get('from') == 'scope-index')
			{
				Response::redirect('activities/index');
			}
			Response::redirect('actions/history/' . $activity->action_id);
		}

		Session::set_flash('error', '実施記録を削除できませんでした。');
		Response::redirect('actions/index');
	}

	public function action_new()
	{
		$this->template->title = '実施記録登録';
		$fields = Fieldset::forge('action')->add_model(new Model_Activity());
		$sess = Session::instance();
		$fields->field('staffm_sh_id')->set_value($sess->get('cis_id'));
		$field = new Fieldset_Field(
			'action_completed_date',
			'実施日',
			array('type' => 'text')
		);
		$field->add_rule(
			'valid_date',
			'Y-m-d'
		);
		$fields->add($field);
		$field = new Fieldset_Field(
			'action_completed_time',
			'実施時刻',
			array('type' => 'text')
		);
		$field->add_rule(
			'valid_date',
			'H:i'
		);
		$fields->add($field);

		$this->template->content = Response::forge(ViewModel::forge('activities/new'));
	}

	public function get_list_fields($id)
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
			'action' => $arr,
		));
	}

	public function action_create()
	{
		$fields = $this->initActivityFields();

		$fields->repopulate();
		$validation = $fields->validation();

		$errors = array();
		if ($validation->run())
		{
			$activity = Model_Activity::forge($fields->validated());
			if (! $activity->action_completed_at)
			{
				try
				{
					$action_completed_at = Date::create_from_string(
						$fields->validated('action_completed_date') .
						' ' .
						$fields->validated('action_completed_time') .
						':' .
						date('s')
						,
						'mysql'
					);
				}
				catch (UnexpectedValueException $e)
				{
					$action_completed_at = Date::time();
				}
				$activity->action_completed_at = $action_completed_at;
			}
			$sess = Session::instance();
			$activity->created_staffm_sh_id = $sess->get('cis_id');
			$activity->updated_staffm_sh_id = $sess->get('cis_id');
			$activity->removed = 0;
			$activity->has_eve_check_error = 0;

			foreach ($fields->validated('fields') as $action_field_id => $value)
			{
				$action_field = Model_Action_Field::find($action_field_id);
				if ($action_field)
				{
					$activity->activity_fields[] = Model_Activity_Field::forge(array(
						'action_field_id' => $action_field_id,
						'value' => $value,
						'is_patient_id_field' => $action_field->is_patient_id_field,
					));
				}
			}

			$activity->save(null, true);

			$action = Model_Action::find($activity->action_id);
			$saved_message = $action ? $action->saved_message : null;
			$invalid_last_action = false;
			// 直前チェックエラーのエラーメッセージを取得
			if ($action && $action->validate_last_action)
			{
				$last_activity_query = Model_Activity::query();
				$last_activity_query
					->where(
						'scope_id', '=', $activity->scope_id
					)
					->order_by('created_at', 'desc')
					;
				if ($activity->id !== '')
				{
					$last_activity_query->where(
						'id', '!=', $activity->id
					);
				}

				$last_action_id = $action->validate_last_action_id;
				$last_activity = $last_activity_query->get_one();

				if ($last_activity and $action->validate_last_action)
				{
					if ($last_activity->action_id != $last_action_id)
					{
						$saved_message = $action->validate_last_action_error_message_on_completed;
						$invalid_last_action = true;
					}
				}
			}

			if ($invalid_last_action)
			{
				// 直前チェックエラーの場合
				$query = \DB::update('activities');
				$query->where('id', '=', $activity->id);
				$query->value('has_eve_check_error', 1);
				$query->execute();
				$activity_array['has_eve_check_error'] = 1;

				if ($action->send_notice_mail_on_invalid_last_action)
				{
					// 通知メール送信先のアドレスを取得
					$mailto = Model_Configure_Mailto::get_enable_addresses();
					if (!empty($mailto))
					{
						// 直前チェックエラーの場合メール通知をおこなう
						$mail_subject = $action->invalid_last_action_notice_mail_subject;
						$view = View::forge('mail/notice_mail_on_invalid_last_action');
						$view->set_safe('activity', $activity);
						$view->set_safe('action', $action);
						$mail_body = $view->render();

						Package::load('email');
						$email = Email::forge('activity_notice');
						$email
							->to($mailto)
							->subject($mail_subject)
							->body(mb_convert_encoding($mail_body, 'ISO-2022-JP', 'UTF-8'))
						;

						try
						{
							$email->send();
						}
						catch (\EmailValidationFailedException $e)
						{
						}
						catch (\EmailSendingFailedException $e)
						{
						}
					}
				}
			}

			if ($saved_message)
			{
				if ($invalid_last_action)
				{
					Session::set_flash('error', '実施記録を登録しました。' . $saved_message);
				}
				else
				{
					Session::set_flash('success', '実施記録を登録しました。' . $saved_message);
				}
			}
			else
			{
				Session::set_flash('success', '実施記録を登録しました。');
			}
			Response::redirect('activities/index');
		}

		foreach ($validation->error() as $field => $error)
		{
			$errors[$field] = $error->get_message();
		}

		Session::set_flash('error', '入力内容を確認して下さい。');
		$fields->populate($fields->validated());
		$this->template->title = '実施記録登録';
		$this->template->content = Response::forge(ViewModel::forge('activities/new'));

	}

	public function get_edit($id)
	{
		$fields = $this->initActionFields($id);

		$viewmodel = ViewModel::forge('activities/edit');
		$viewmodel->set('id', $id);
		return $this->response(array(
			'html' => $viewmodel->render(),
		));
	}

	public function post_update_activity($id)
	{
		$fields = $this->initActionFields($id);

		$activity = Model_Activity::find($id);
		$fields->populate($activity)->repopulate();
		/* $fields->populate(Input::post()); */
		$validation = $fields->validation();
		if ($validation->run())
		{
			$sess = Session::instance();
			$update = array(
				'staffm_sh_id' => $fields->field('staffm_sh_id')->validated(),
				'scope_id' => $fields->field('scope_id')->validated(),
			);
			try
			{
				$action_completed_at = Date::create_from_string(
					$fields->validated('action_completed_date') .
					' ' .
					$fields->validated('action_completed_time') .
					':' .
					date('s')
					,
					'mysql'
				);
			}
			catch (UnexpectedValueException $e)
			{
				$action_completed_at = Date::time();
			}
			$update['action_completed_at'] = $action_completed_at;

			$activity->from_array($update);
			if (! $activity->action_completed_at)
			{
				$activity->action_completed_at = Date::time();
			}
			$activity->updated_staffm_sh_id = $sess->get('cis_id');
			$activity->updated_at = time();
			foreach ($fields->validated('fields') as $action_field_id => $value)
			{
				foreach ($activity->activity_fields as $i => $activity_field)
				{
					if ($activity_field->action_field_id == $action_field_id)
					{
						$activity_field->value = $value;
						$activity->activity_fields[$i] = $activity_field;
					}
				}
			}

			$activity->save();
			return $this->response(array(
				'valid' => 1,
			));
		}

		$viewmodel = ViewModel::forge('activities/edit');
		$viewmodel->set('id', $id);
		return $this->response(array(
			'html' => $viewmodel->render(),
			'valid' => $validation->run(),
		));
	}

	protected function _initActivityField($action_field_id)
	{
		$action_field = Model_Action_Field::find($action_field_id);
		$field = new Fieldset_Field(
			'value',
			$action_field->name,
			array('type' => 'text')
		);

		if ($action_field->type == 'boolean')
		{
			$field->set_type('boolean');
		}

		if ($action_field->is_required)
		{
			$field->add_rule('required');
		}

		if ($action_field->string_length_min and
			$action_field->string_length_max and
			$action_field->string_length_min == $action_field->string_length_max)
		{
			$field->add_rule(
				'exact_length',
				$action_field->string_length_min
			);
		}
		else
		{
			if ($action_field->string_length_min)
			{
				$field->add_rule(
					'min_length',
					$action_field->string_length_min
				);
			}

			if ($action_field->string_length_max)
			{
				$field->add_rule(
					'max_length',
					$action_field->string_length_max
				);
			}
		}

		if ($action_field->string_regexp)
		{
			$field->add_rule(
				'match_pattern',
				$action_field->string_regexp
			);
		}

		$fields = Fieldset::forge('field');
		$fields->add($field);
		return $fields;
	}

	protected function initActionFields($activity_id)
	{
		$activity = Model_Activity::find($activity_id);
		Log::debug($activity->action_completed_at->format('%Y-%m-%d'));

		$fields = Fieldset::forge('action')->add_model('Model_Activity');
		$field = new Fieldset_Field(
			'action_completed_date',
			'実施日',
			array('type' => 'text')
		);
		$field
			->add_rule(
				'valid_date',
				'Y-m-d'
			)
			->set_value($activity->action_completed_at->format('%Y-%m-%d'))
		;
		$fields->add($field);

		$field = new Fieldset_Field(
			'action_completed_time',
			'実施時刻',
			array('type' => 'text')
		);
		$field
			->add_rule(
				'valid_date',
				'H:i'
			)
			->set_value($activity->action_completed_at->format('%H:%M'))
		;
		$fields->add($field);

		$field = new Fieldset_Field(
			'activity_id',
			'activity_id',
			array('type' => 'text')
		);
		$fields->add($field);


		$action = Model_Action::find($activity->action_id);
		if (! $action)
		{
			return $fields;
		}

		foreach ($action->action_fields as $action_field)
		{
			$field = new Fieldset_Field(
				'fields[' . $action_field->id . ']',
				$action_field->name,
				array('type' => 'text')
			);

			if ($action_field->type == 'boolean')
			{
				$field->set_type('boolean');
			}

			if ($action_field->is_required)
			{
				$field->add_rule('required');
			}

			if ($action_field->string_length_min and
				$action_field->string_length_max and
				$action_field->string_length_min == $action_field->string_length_max)
			{
				$field->add_rule(
					'exact_length',
					$action_field->string_length_min
				);
			}
			else
			{
				if ($action_field->string_length_min)
				{
					$field->add_rule(
						'min_length',
						$action_field->string_length_min
					);
				}

				if ($action_field->string_length_max)
				{
					$field->add_rule(
						'max_length',
						$action_field->string_length_max
					);
				}
			}

			if ($action_field->string_regexp)
			{
				$field->add_rule(
					'match_pattern',
					$action_field->string_regexp
				);
			}

			if ($action_field->is_patient_id_field)
			{
				$field->add_rule(
					'match_patient'
				);
			}

			if ($action_field->is_washer_id_field)
			{
				$field->add_rule(
					'match_washer'
				);
			}

			$fields->add($field);
		}
		return $fields;
	}

	protected function initActivityFields()
	{
		$fields = Fieldset::forge('action')->add_model(new Model_Activity());
		$field = new Fieldset_Field(
			'action_completed_date',
			'実施日',
			array('type' => 'text')
		);
		$field->add_rule(
			'valid_date',
			'Y-m-d'
		);
		$fields->add($field);
		$field = new Fieldset_Field(
			'action_completed_time',
			'実施時刻',
			array('type' => 'text')
		);
		$field->add_rule(
			'valid_date',
			'H:i'
		);
		$fields->add($field);

		$field = new Fieldset_Field(
			'activity_id',
			'activity_id',
			array('type' => 'text')
		);
		$fields->add($field);

		if (Input::post('action_id'))
		{
			$action = Model_Action::find(Input::post('action_id'));
			if (! $action)
			{
				return $fields;
			}

			foreach ($action->action_fields as $action_field)
			{
				$field = new Fieldset_Field(
					'fields[' . $action_field->id . ']',
					$action_field->name,
					array('type' => 'text')
				);

				$field->add_rule('remove_emoji');

				if ($action_field->type == 'boolean')
				{
					$field->set_type('boolean');
				}

				if ($action_field->is_required)
				{
					$field->add_rule('required');
				}

				if ($action_field->string_length_min and
					$action_field->string_length_max and
					$action_field->string_length_min == $action_field->string_length_max)
				{
					$field->add_rule(
						'exact_length',
						$action_field->string_length_min
					);
				}
				else
				{
					if ($action_field->string_length_min)
					{
						$field->add_rule(
							'min_length',
							$action_field->string_length_min
						);
					}

					if ($action_field->string_length_max)
					{
						$field->add_rule(
							'max_length',
							$action_field->string_length_max
						);
					}
				}

				if ($action_field->string_regexp)
				{
					$field->add_rule(
						'match_pattern',
						$action_field->string_regexp
					);
				}

				if ($action_field->is_patient_id_field)
				{
					$field->add_rule(
						'match_patient'
					);
				}

				if ($action_field->is_washer_id_field)
				{
					$field->add_rule(
						'match_washer'
					);
				}

				$fields->add($field);
			}
		}
		return $fields;
	}
}
