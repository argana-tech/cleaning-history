<?php

class View_History_Index extends Viewmodel
{

	public function view()
	{
		$q = Input::get('q');
		$this->q = $q;

		$count_query = Model_Access_Log::query();
		if (isset($q['uri']) and $q['uri'] != '')
		{
			$count_query->where('uri', 'LIKE', $q['uri'] . '%');
		}
		if (isset($q['cis_id']) and $q['cis_id'] != '')
		{
			$count_query->where('staffm_sh_id', $q['cis_id']);
		}
		if (isset($q['date']) and $q['date'] != '')
		{
			$count_query->where(
				'timestamp',
				'BETWEEN',
				array(
					$q['date'] . ' 00:00:00',
					$q['date'] . ' 23:59:59'
				)
			);
		}

		$total_items = $count_query->count();

		$url = Uri::create('/history', array(), array('q' => $q));

		$pagination = Pagination::forge('actions-index', array(
			'pagination_url' => $url,
			'total_items'    => $total_items,
			'per_page'       => 50,
			'uri_segment'    => 'p',
		));

		$model = Model_Access_Log::query()
			->limit($pagination->per_page)
			->offset($pagination->offset)
			->order_by('timestamp', 'desc')
		;

		if (isset($q['uri']) and $q['uri'] != '')
		{
			$model->where('uri', 'LIKE', $q['uri'] . '%');
		}
		if (isset($q['cis_id']) and $q['cis_id'] != '')
		{
			$model->where('staffm_sh_id', $q['cis_id']);
		}
		if (isset($q['date']) and $q['date'] != '')
		{
			$model->where(
				'timestamp',
				'BETWEEN',
				array(
					$q['date'] . ' 00:00:00',
					$q['date'] . ' 23:59:59'
				)
			);
		}

		$this->_view->set_safe('histories', $model->get());

		$this->_view->set_safe('pager', $pagination->render());
		$this->start_item = $pagination->offset + 1;
		$this->end_item = ($pagination->offset + $pagination->per_page) > $total_items ? $total_items : ($pagination->offset + $pagination->per_page);
		$this->total_items = $total_items;
	}

}
