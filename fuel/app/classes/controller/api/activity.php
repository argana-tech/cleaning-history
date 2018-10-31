<?php

class Controller_Api_Activity extends Controller_Api
{

	public function action_index()
	{
		$this->template->title = 'アクション実施';
		$this->template->content = Response::forge(View::forge('api/activity/index'));

	}

	public function post_validate()
	{
		$fields = $this->initActionFields();

		$field = new Fieldset_Field(
			'validate_last_action',
			'直前アクション制限',
			array('type' => 'text')
		);
		$field->add_rule('check_last_action');
		$fields->add($field);

		$fields->repopulate();
		$validation = $fields->validation();

		$errors = array();
		if (! $validation->run())
		{
			foreach ($validation->error() as $field => $error)
			{
				$errors[$field] = $error->get_message();
			}
		}

		$action = Model_Action::find(Input::post('action_id'));
		return $this->response(array(
			'auth_key' => Crypt::encode(Session::key('session_id')),
			'errors' => $errors,
			'post_data' => Input::post(),
			'validate_last_action' => $action ? $action->validate_last_action : null,
		));
	}

	public function post_save()
	{
		$fields = $this->initActionFields();

		$fields->repopulate();
		$validation = $fields->validation();

		$errors = array();
		if ($validation->run())
		{
			$activity = Model_Activity::forge($fields->validated());
			$activity->action_completed_at = Date::time();
			$activity->updated_staffm_sh_id = $activity->staffm_sh_id;
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
							'is_washer_id_field' => $action_field->is_washer_id_field,
						));
				}
			}

			// すでに保存されているものを修正する場合
			if (Input::post('activity_id') and
				$activity = Model_Activity::find(Input::post('activity_id')))
			{
				$activity->scope_id = $fields->validated('scope_id');
				// 修正する場合実施日時も上書きする
				$activity->action_completed_at = Date::time();
				$activity->staffm_sh_id = $fields->field('staffm_sh_id')->validated();
				$activity->updated_staffm_sh_id = $activity->staffm_sh_id;
				$activity->updated_at = time();
				$activity->removed = 0;

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
			}
			else
			{
				$activity->created_staffm_sh_id = $activity->staffm_sh_id;
			}

			$activity->save(null, true);

			$activity_array = $activity->to_array();
			$activity_array['action_completed_at'] = $activity->get_action_completed_at();

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

			return $this->response(array(
				'auth_key' => Crypt::encode(Session::key('session_id')),
				'post_data' => Input::post(),
				'activity' => $activity_array,
				'saved_message' => $saved_message,
				'elapsed_message' => $activity->get_elapsed_message(),
				'invalid_last_action' => $invalid_last_action,
			));

		}

		foreach ($validation->error() as $field => $error)
		{
			$errors[$field] = $error->get_message();
		}

		return $this->response(array(
			'auth_key' => Crypt::encode(Session::key('session_id')),
			'errors' => $errors,
			'post_data' => Input::post(),
		));
	}

	public function post_remove()
	{
		$activity_id = Input::post('activity_id');

		$result = false;
		$message = '';
		$activity = Model_Activity::find($activity_id);
		if ($activity and $activity->delete())
		{
			$result = true;
			$message = '対象の実施記録を削除しました。';
		}
		else
		{
			$message = '対象の実施記録を削除できませんでした。';
		}

		return $this->response(array(
			'auth_key' => Crypt::encode(Session::key('session_id')),
			'result' => $result,
			'message' => $message,
			'post_data' => Input::post(),
		));
	}

	protected function initActionFields()
	{
		$fields = Fieldset::forge('action')->add_model(new Model_Activity());
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
