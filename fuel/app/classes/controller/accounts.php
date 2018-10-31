<?php

class Controller_Accounts extends Controller_Index
{
	public function action_index()
	{
		$this->template->title = '管理者一覧';
		$this->template->content = Response::forge(ViewModel::forge('accounts/index'));
	}

	public function action_new()
	{
		$this->template->title = '管理者新規追加';

		$fields = $this->initAccountFields();

		$this->template->content = Response::forge(ViewModel::forge('accounts/new'));
	}

	public function action_create()
	{
		if (Input::method() != 'POST')
		{
			Session::set_flash('error', '不正なアクセスです。もう一度はじめからやり直してください。');
			return Response::redirect('index');
		}

		$fields = $this->initAccountFields();
		$fields->repopulate();
		$validation = $fields->validation();
		if ($validation->run())
		{
			$sess = Session::instance();
			$user = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$account = Model_Account::forge($fields->validated());
			$account->created_account_id = $user->id;
			$account->updated_account_id = $user->id;
			$account->removed = 0;

			if ($account->save(null, true))
			{
				Session::set_flash('success', '管理者を追加しました。');
				return Response::redirect('accounts/index');
			}
		}

		Session::set_flash('error', '入力内容を確認して下さい。');
		$fields->populate($fields->validated());
		$this->template->title = '管理者新規追加';
		$this->template->content = Response::forge(ViewModel::forge('accounts/new'));
	}

	public function action_remove($id)
	{
		if (Input::method() != 'POST')
		{
			Session::set_flash('error', '不正なアクセスです。もう一度はじめからやり直してください。');
			return Response::redirect('index');
		}

		$sess = Session::instance();
		$account = Model_Account::find($id);
		if ($account and $account->staffm_sh_id != $sess->get('cis_id'))
		{
			$user = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$account->removed_account_id = $user->id;
			if ($account->save() and $account->delete())
			{
				Session::set_flash('success', '管理者を削除しました。');
				return Response::redirect('accounts/index');
			}
		}

		Session::set_flash('error', '管理者を削除できませんでした。');
		return Response::redirect('accounts/index');
	}

	protected function initAccountFields()
	{
		$fields = Fieldset::forge('account')->add_model(new Model_Account());

		return $fields;
	}
}
