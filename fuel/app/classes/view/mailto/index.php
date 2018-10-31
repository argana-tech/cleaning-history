<?php

class View_Mailto_Index extends ViewModel
{

	public function view()
	{
		$q = Input::get('q');
		$this->q = $q;

		$count_query = Model_Configure_Mailto::query();
		if (isset($q['address']) and !empty($q['address']))
		{
			$count_query->where('address', 'like', '%' . $q['address'] . '%');
		}
		$total_items = $count_query->count();

		$pagination = null;
		if ($exists = Pagination::instance('mailto-index'))
		{
			$pagination = $exists;
		}
		else
		{
			$pagination = Pagination::forge('mailto-index', array(
				'pagination_url' => Uri::create('/mailto'),
				'total_items'    => $total_items,
				'per_page'       => 50,
				'uri_segment'    => 'p',
			));
		}

		$model = Model_Configure_Mailto::query()
			->limit($pagination->per_page)
			->offset($pagination->offset)
		;

		if (isset($q['address']) and !empty($q['address']))
		{
			$model->where('address', 'like', '%' . $q['address'] . '%');
		}

		$this->_view->set_safe('mailtos', $model->get());

		$this->_view->set_safe('pager', $pagination->render());
		$this->start_item = $pagination->offset + 1;
		$this->end_item = ($pagination->offset + $pagination->per_page) > $total_items ? $total_items : ($pagination->offset + $pagination->per_page);
		$this->total_items = $total_items;
	}

}
