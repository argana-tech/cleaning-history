<?php

class View_Washers_Index extends ViewModel
{

	public function view()
	{
		$q = Input::get('q');
		$this->q = $q;

		$count_query = Model_Washer::query();
		if (isset($q['code']) and !empty($q['code']))
		{
			$count_query->where('code', 'like', '%' . $q['code'] . '%');
		}
		$total_items = $count_query->count();

		$pagination = null;
		if ($exists = Pagination::instance('washers-index'))
		{
			$pagination = $exists;
		}
		else
		{
			$pagination = Pagination::forge('washers-index', array(
				'pagination_url' => Uri::create('/washers'),
				'total_items'    => $total_items,
				'per_page'       => 50,
				'uri_segment'    => 'p',
			));
		}

		$model = Model_Washer::query()
			->limit($pagination->per_page)
			->offset($pagination->offset)
		;

		if (isset($q['code']) and !empty($q['code']))
		{
			$model->where('code', 'like', '%' . $q['code'] . '%');
		}

		$this->_view->set_safe('washers', $model->get());

		$this->_view->set_safe('pager', $pagination->render());
		$this->start_item = $pagination->offset + 1;
		$this->end_item = ($pagination->offset + $pagination->per_page) > $total_items ? $total_items : ($pagination->offset + $pagination->per_page);
		$this->total_items = $total_items;
	}

}
