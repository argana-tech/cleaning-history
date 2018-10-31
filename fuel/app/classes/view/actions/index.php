<?php

class View_Actions_Index extends ViewModel
{

	public function view()
	{
		$q = Input::get('q');
		$this->q = $q;

		$count_query = Model_Action::query();
		if (isset($q['name']) and !empty($q['name']))
		{
			$count_query->where('name', 'like', '%' . $q['name'] . '%');
		}
		$total_items = $count_query->count();

		$pagination = null;
		if ($exists = Pagination::instance('actions-index'))
		{
			$pagination = $exists;
		}
		else
		{
			$pagination = Pagination::forge('actions-index', array(
				'pagination_url' => Uri::create('/actions'),
				'total_items'    => $total_items,
				'per_page'       => 50,
				'uri_segment'    => 'p',
			));
		}

		$model = Model_Action::query()
			->limit($pagination->per_page)
			->offset($pagination->offset)
		;

		if (isset($q['name']) and !empty($q['name']))
		{
			$model->where('name', 'like', '%' . $q['name'] . '%');
		}

		$this->_view->set_safe('actions', $model->get());

		$this->_view->set_safe('pager', $pagination->render());
		$this->start_item = $pagination->offset + 1;
		$this->end_item = ($pagination->offset + $pagination->per_page) > $total_items ? $total_items : ($pagination->offset + $pagination->per_page);
		$this->total_items = $total_items;
	}

}
