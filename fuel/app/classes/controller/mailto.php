<?php

class Controller_Mailto extends Controller_Index
{
	public function action_index()
	{
		$this->template->title = '通知メール送信先一覧';
		$this->template->content = Response::forge(ViewModel::forge('mailto/index'));
	}

	public function action_new()
	{
		$this->template->title = '通知メール送信先新規追加';

		$fields = $this->initMailtoFields();

		$this->template->content = Response::forge(ViewModel::forge('mailto/new'));
	}

	public function action_create()
	{
		if (Input::method() != 'POST')
		{
			Session::set_flash('error', '不正なアクセスです。もう一度はじめからやり直してください。');
			return Response::redirect('index');
		}

		$fields = $this->initMailtoFields();
		$fields->repopulate();
		$validation = $fields->validation();
		if ($validation->run())
		{
			$sess = Session::instance();
			$user = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$mailto = Model_Configure_Mailto::forge($fields->validated());
			$mailto->created_account_id = $user->id;
			$mailto->updated_account_id = $user->id;
			$mailto->removed = 0;

			if ($mailto->save(null, true))
			{
				Session::set_flash('success', '通知メール送信先を追加しました。');
				return Response::redirect('mailto/index');
			}
		}

		Session::set_flash('error', '入力内容を確認して下さい。');
		$fields->populate($fields->validated());
		$this->template->title = '通知メール送信先新規追加';
		$this->template->content = Response::forge(ViewModel::forge('mailto/new'));
	}

	public function action_edit($id)
	{
		$this->template->title = '通知メール送信先編集';

		$fields = $this->initMailtoFields();

		$viewmodel = ViewModel::forge('mailto/edit');
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
		$mailto = Model_Configure_Mailto::find($id);

		$fields = $this->initMailtoFields();
		$fields->populate($mailto)->repopulate();
		$validation = $fields->validation();

		if ($validation->run())
		{
			$input = array(
				'address' => $fields->field('address')->validated(),
				'note' => $fields->field('note')->validated(),
			);

			$mailto->from_array($input);

			$sess = Session::instance();
			$account = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$mailto->updated_account_id = $account->id;

			if ($mailto->save(null, true))
			{
				Session::set_flash('success', '通知メール送信先を保存しました。');
				return Response::redirect('mailto/index');
			}
		}

		Session::set_flash('error', '入力内容を確認して下さい。');
		$fields->populate($fields->validated());
		$this->template->title = '通知メール送信先編集';

		$viewmodel = ViewModel::forge('mailto/edit');
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

		$sess = Session::instance();
		$mailto = Model_Configure_Mailto::find($id);
		if ($mailto)
		{
			$user = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$mailto->removed_account_id = $user->id;
			if ($mailto->save() and $mailto->delete())
			{
				Session::set_flash('success', '通知メール送信先アドレスを削除しました。');
				return Response::redirect('mailto/index');
			}
		}

		Session::set_flash('error', '通知メール送信先アドレスを削除できませんでした。');
		return Response::redirect('mailto/index');
	}

	protected function initMailtoFields()
	{
		$fields = Fieldset::forge('mailto')->add_model(new Model_Configure_Mailto());

		$fields->add(
			'self_id',
			'元ID',
			array('type' => 'init')
		);

		return $fields;
	}
}
