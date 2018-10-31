<?php

class Controller_Actions extends Controller_Index
{
	public function action_index()
	{
		$this->template->title = 'アクション管理';
		$this->template->content = Response::forge(ViewModel::forge('actions/index'));
	}

	public function action_new()
	{
		$this->template->title = 'アクション新規追加';

		$fields = $this->initActionFields();

		$this->template->content = Response::forge(ViewModel::forge('actions/new'));
	}

	public function action_create()
	{
		if (Input::method() != 'POST')
		{
			Session::set_flash('error', '不正なアクセスです。もう一度はじめからやり直してください。');
			return Response::redirect('index');
		}

		$fields = $this->initActionFields();
		$fields->repopulate();
		$validation = $fields->validation();
		if ($validation->run())
		{
			$sess = Session::instance();
			$account = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$action = Model_Action::forge($fields->validated());
			$action->created_account_id = $account->id;
			$action->updated_account_id = $account->id;
			$action->removed = 0;

			if ($fields->field('fields')->validated())
			{
				$action_fields = json_decode($fields->field('fields')->validated());
				foreach ($action_fields as $field)
				{
					$action_field = Model_Action_Field::forge((array)$field);
					$action_field->created_account_id = $account->id;
					$action_field->updated_account_id = $account->id;
					$action_field->removed = 0;
					$action->action_fields[] = $action_field;
				}
			}

			if (!$action->validate_last_action_enable)
			{
				$action->send_notice_mail_on_invalid_last_action = 0;
			}

			if ($action->save(null, true))
			{
				Session::set_flash('success', 'アクションを保存しました。');
				return Response::redirect('actions/index');
			}
		}

		Session::set_flash('error', '入力内容を確認して下さい。');
		$fields->populate($fields->validated());
		$this->template->title = 'アクション新規追加';
		$this->template->content = Response::forge(ViewModel::forge('actions/new'));
	}

	public function action_edit($id)
	{
		$this->template->title = 'アクション編集';

		$fields = $this->initActionFields();

		$viewmodel = ViewModel::forge('actions/edit');
		$viewmodel->set('id', $id);
		$this->template->content = Response::forge($viewmodel);
	}

	public function action_update()
	{
		if (Input::method() != 'POST')
		{
			Session::set_flash('error', '不正なアクセスです。もう一度はじめからやり直してください。');
			return Response::redirect('index');
		}

		$id = Input::post('id');
		$action = Model_Action::find($id);

		$fields = $this->initActionFields();
		$fields->populate($action)->repopulate();
		$validation = $fields->validation();
		if ($validation->run())
		{
			$input = array(
				'name' => $fields->field('name')->validated(),
				'validate_last_action_enable' => $fields->field('validate_last_action_enable')->validated(),
				'validate_last_action' => $fields->field('validate_last_action')->validated(),
				'validate_last_action_id' => $fields->field('validate_last_action_id')->validated(),
				'validate_last_action_error_message' => $fields->field('validate_last_action_error_message')->validated(),
				'validate_last_action_error_message_on_completed' => $fields->field('validate_last_action_error_message_on_completed')->validated(),
				'send_notice_mail_on_invalid_last_action' => $fields->field('send_notice_mail_on_invalid_last_action')->validated(),
				'invalid_last_action_notice_mail_subject' => $fields->field('invalid_last_action_notice_mail_subject')->validated(),
				'invalid_last_action_notice_mail_body' => $fields->field('invalid_last_action_notice_mail_body')->validated(),
				'saved_message' => $fields->field('saved_message')->validated(),
				'return_elapsed_last_action' => $fields->field('return_elapsed_last_action')->validated(),
				'return_elapsed_last_action_id' => $fields->field('return_elapsed_last_action_id')->validated(),
				'validate_duplicate_action' => $fields->field('validate_duplicate_action')->validated(),
				'validate_duplicate_action_message' => $fields->field('validate_duplicate_action_message')->validated(),
			);

			$action->from_array($input);
			if (!$action->validate_last_action_enable)
			{
				$action->send_notice_mail_on_invalid_last_action = 0;
			}

			$sess = Session::instance();
			$account = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$action->updated_account_id = $account->id;

			$remove_fields = array();
			if ($fields->field('fields')->validated())
			{
				$action_fields = json_decode($fields->field('fields')->validated());
				$update_fields = array();
				foreach ($action_fields as $field)
				{
					if (isset($field->id))
					{
						// 上書き
						if (isset($action->action_fields[$field->id]))
						{
							$action_field = $action->action_fields[$field->id];
							$action_field->from_array((array)$field);
							$action_field->updated_account_id = $account->id;
							$action->action_fields[$field->id] = $action_field;
							$update_fields[] = $field->id;
						}
					}
					else
					{
						// 追加
						$action_field = Model_Action_Field::forge((array)$field);
						$action_field->created_account_id = $account->id;
						$action_field->updated_account_id = $account->id;
						$action_field->removed = 0;
						$action->action_fields[] = $action_field;
					}
				}

				foreach ($action->action_fields as $action_field)
				{
					if (! in_array($action_field->id, $update_fields))
					{
						$remove_fields[] = $action_field->id;
					}
				}
			}

			if ($action->save(null, true))
			{
				foreach ($action->action_fields as $action_field)
				{
					if (in_array($action_field->id, $remove_fields))
					{
						$action_field->delete();

					}
				}
				Session::set_flash('success', 'アクションを保存しました。');
				return Response::redirect('actions/index');
			}
		}

		Session::set_flash('error', '入力内容を確認して下さい。');
		$fields->populate($fields->validated());
		$this->template->title = 'アクション編集';

		$viewmodel = ViewModel::forge('actions/edit');
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

		$action = Model_Action::find($id);
		if ($action and $action->action_fields)
		{
			$sess = Session::instance();
			$user = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$action->removed_account_id = $user->id;
			foreach ($action->action_fields as $action_field)
			{
				$action_field->removed_account_id = $user->id;
			}
			if ($action->save(null, true) and $action->delete())
			{
				Session::set_flash('success', 'アクションを削除しました。');
				return Response::redirect('actions/index');
			}
		}

		Session::set_flash('error', 'アクションを削除できませんでした。');
		return Response::redirect('actions/index');
	}

	public function action_history($id)
	{
		$action = Model_Action::find($id);
		if (! $action)
		{
			Session::set_flash('error', 'アクションが見つかりませんでした。');
			return Response::redirect('actions/index');
		}

		$this->template->title = 'アクション実施履歴';

		$viewmodel = ViewModel::forge('actions/history');
		$viewmodel->set('id', $id);
		$this->template->content = Response::forge($viewmodel);
	}

	protected function initActionFields()
	{
		$fields = Fieldset::forge('action')->add_model(new Model_Action());

		$fields->add(
			'validate_last_action_enable',
			'直前アクション制限',
			array('type' => 'boolean')
		);

		$fields->add(
			'fields',
			'入力項目',
			array('type' => 'text')
		);

		return $fields;
	}
}
