<?php

class View_Scope_Index extends ViewModel
{
	public function view()
	{
		$this->q = Input::get('q');
		$this->sort_by = Input::get('sort', 'created_desc');
		$action_fields = Model_Action_Field::find('all', array('order' => 'id'));

		$total_items = $this->build_where(Model_Activity::query())->count();

		$pagination = null;
		if ($exists = Pagination::instance('scope-index'))
		{
			$pagination = $exists;
		}
		else
		{
			$url = Uri::create(
				'/scope/index',
				array(),
				array('q' => $this->q, 'sort' => $this->sort_by)
			);
			$pagination = Pagination::forge('scope-index', array(
				'pagination_url' => $url,
				'total_items'    => $total_items,
				'per_page'       => 50,
				'uri_segment'    => 'p',
			));
		}

		$query = Model_Activity::get_search_query(
			$this->q,
			$this->sort_by,
			$pagination->per_page,
			$pagination->offset
		);

		$activities = array();
		foreach ($query->execute() as $row)
		{
			$activities[] = Model_Activity::forge($row);
		}
		$this->_view->set_safe('activities', $activities);

		$this->_view->set_safe('action_fields', $action_fields);

		$this->actions = array(
			'' => 'アクション',
		);
		foreach (Model_Action::find('all') as $action)
		{
			$this->actions[$action->id] = $action->name;
		}

		$this->_view->set_safe('pager', $pagination->render());
		$this->start_item = $pagination->offset + 1;
		$this->end_item = ($pagination->offset + $pagination->per_page) > $total_items ? $total_items : ($pagination->offset + $pagination->per_page);
		$this->total_items = $total_items;

		Asset::js(
			array(
				'bootstrap-datepicker-ja.js',
				'bootstrap-timepicker-v3.js',
				'scope/index.js',
			),
			array(),
			'add_js'
		);
		Asset::css(
			array(
				'datepicker.css',
				'bootstrap-timepicker.css',
			),
			array(),
			'add_css'
		);
	}

	private function build_where($query)
	{
		$q = $this->q;
		if (isset($q['date']) and $q['date'] !== '')
		{
			$query->where(
				'created_at',
				'BETWEEN',
				array(
					$q['date'] . ' 00:00:00',
					$q['date'] . ' 23:59:59',
				)
			);
		}

		if (isset($q['staffm_ka_name']) and $q['staffm_ka_name'] !== '')
		{
			$query->where('staffm_ka_name', 'LIKE', '%' . $q['staffm_ka_name'] . '%');
		}

		if (isset($q['staffm_sh_id']) and $q['staffm_sh_id'] !== '')
		{
			$query->where('staffm_sh_id', 'LIKE', '%' . $q['staffm_sh_id'] . '%');
		}

		if (isset($q['action_id']) and $q['action_id'] !== '')
		{
			$query->where('action_id', $q['action_id']);
		}

		if (isset($q['has_eve_check_error']) and $q['has_eve_check_error'] !== '')
		{
			$query->where('has_eve_check_error', $q['has_eve_check_error']);
		}

		if (isset($q['scope_id']) and $q['scope_id'] !== '')
		{
			$query->where('scope_id', 'LIKE', '%' . $q['scope_id'] . '%');
		}

		if (isset($q['action_field']) and is_array($q['action_field']))
		{
			$relation_where = array();
			foreach ($q['action_field'] as $action_field_id => $str)
			{
				if ($str !== '')
				{
					$relation_where[] = array(
						array('action_field_id', $action_field_id),
						array('value', 'LIKE', '%' . $str . '%'),
					);
				}
			}
			if (!empty($relation_where))
			{
				$query->related('activity_fields',
					array('where' => $relation_where)
				);
			}
		}

		return $query;
	}
}
