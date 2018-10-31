<?php

class View_Scope_History extends ViewModel
{
	public function view()
	{
		$total_items = Model_Activity::query()
			->where(array('scope_id' => $this->id))
			->count()
		;

		$pagination = null;
		if ($exists = Pagination::instance('scope-history'))
		{
			$pagination = $exists;
		}
		else
		{
			$pagination = Pagination::forge('scope-history', array(
				'pagination_url' => Uri::create('/scope/history/' . $this->id),
				'total_items'    => $total_items,
				'per_page'       => 50,
				'uri_segment'    => 'p',
			));
		}

		$model = Model_Activity::query()
			->where(array('scope_id' => $this->id))
			->order_by('created_at', 'desc')
			->limit($pagination->per_page)
			->offset($pagination->offset)
		;

		$this->_view->set_safe('activities', $model->get());

		$this->_view->set_safe('pager', $pagination->render());
		$this->start_item = $pagination->offset + 1;
		$this->end_item = ($pagination->offset + $pagination->per_page) > $total_items ? $total_items : ($pagination->offset + $pagination->per_page);
		$this->total_items = $total_items;

		Asset::js(array('scope/history.js'), array(), 'add_js');

	}
}
