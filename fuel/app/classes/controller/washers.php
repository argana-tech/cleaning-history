<?php

class Controller_Washers extends Controller_Index
{
	public function action_index()
	{
		$this->template->title = '洗浄・消毒機器情報管理';
		$this->template->content = Response::forge(ViewModel::forge('washers/index'));
	}

	public function action_new()
	{
		$this->template->title = '洗浄・消毒機器情報新規追加';

		$fields = $this->initWasherFields();

		$this->template->content = Response::forge(ViewModel::forge('washers/new'));
	}

	public function action_create()
	{
		if (Input::method() != 'POST')
		{
			Session::set_flash('error', '不正なアクセスです。もう一度はじめからやり直してください。');
			return Response::redirect('index');
		}

		$fields = $this->initWasherFields();
		$fields->repopulate();
		$validation = $fields->validation();
		if ($validation->run())
		{
			$sess = Session::instance();
			$account = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$washer = Model_Washer::forge($fields->validated());
			$washer->created_account_id = $account->id;
			$washer->updated_account_id = $account->id;
			$washer->removed = 0;

			if ($washer->save(null, true))
			{
				Session::set_flash('success', '洗浄・消毒機器情報を保存しました。');
				return Response::redirect('washers/index');
			}
		}

		Session::set_flash('error', '入力内容を確認して下さい。');
		$fields->populate($fields->validated());
		$this->template->title = '洗浄・消毒機器情報新規追加';
		$this->template->content = Response::forge(ViewModel::forge('washers/new'));
	}

	public function action_edit($id)
	{
		$this->template->title = '洗浄・消毒機器情報編集';

		$fields = $this->initWasherFields();

		$viewmodel = ViewModel::forge('washers/edit');
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
		$washer = Model_Washer::find($id);

		$fields = $this->initWasherFields();
		$fields->populate($washer)->repopulate();
		$validation = $fields->validation();
		/* $validation->fieldset()->field('code')->delete_rule('unique_code'); */

		if ($validation->run())
		{
			$input = array(
				'code' => $fields->field('code')->validated(),
				'type' => $fields->field('type')->validated(),
				'solution' => $fields->field('solution')->validated(),
				'location' => $fields->field('location')->validated(),
				'alert_message' => $fields->field('alert_message')->validated(),
			);

			$washer->from_array($input);

			$sess = Session::instance();
			$account = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$washer->updated_account_id = $account->id;

			$remove_fields = array();
			if ($washer->save(null, true))
			{
				Session::set_flash('success', '洗浄・消毒機器情報を保存しました。');
				return Response::redirect('washers/index');
			}
		}

		Session::set_flash('error', '入力内容を確認して下さい。');
		$fields->populate($fields->validated());
		$this->template->title = '洗浄・消毒機器情報編集';

		$viewmodel = ViewModel::forge('washers/edit');
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

		$washer = Model_Washer::find($id);
		if ($washer)
		{
			$sess = Session::instance();
			$user = Model_Account::findByStaffmShId($sess->get('cis_id'));
			$washer->removed_account_id = $user->id;
			if ($washer->save(null, true) and $washer->delete())
			{
				Session::set_flash('success', '洗浄・消毒機器情報を削除しました。');
				return Response::redirect('washers/index');
			}
		}

		Session::set_flash('error', '洗浄・消毒機器情報を削除できませんでした。');
		return Response::redirect('washers/index');
	}

	protected function initWasherFields()
	{
		$fields = Fieldset::forge('washer')->add_model(new Model_Washer());
		$fields->add(
			'self_id',
			'元ID',
			array('type' => 'init')
		);

		return $fields;
	}
}
