<?php

class View_Accounts_Index extends ViewModel
{

	public function view()
	{
		$q = Input::get('q');
		$this->q = $q;

		$count_query = Model_Account::query();
		if (isset($q['staffm_sh_id']) and !empty($q['staffm_sh_id']))
		{
			$count_query->where('staffm_sh_id', 'like', '%' . $q['staffm_sh_id'] . '%');
		}
		$total_items = $count_query->count();

		$pagination = null;
		if ($exists = Pagination::instance('accounts-index'))
		{
			$pagination = $exists;
		}
		else
		{
			$pagination = Pagination::forge('accounts-index', array(
				'pagination_url' => Uri::create('/accounts'),
				'total_items'    => $total_items,
				'per_page'       => 50,
				'uri_segment'    => 'p',
			));
		}

		$model = Model_Account::query()
			->limit($pagination->per_page)
			->offset($pagination->offset)
		;

		if (isset($q['staffm_sh_id']) and !empty($q['staffm_sh_id']))
		{
			$model->where('staffm_sh_id', 'like', '%' . $q['staffm_sh_id'] . '%');
		}

		$this->_view->set_safe('accounts', $model->get());

		$this->_view->set_safe('pager', $pagination->render());
		$this->start_item = $pagination->offset + 1;
		$this->end_item = ($pagination->offset + $pagination->per_page) > $total_items ? $total_items : ($pagination->offset + $pagination->per_page);
		$this->total_items = $total_items;
	}

}
