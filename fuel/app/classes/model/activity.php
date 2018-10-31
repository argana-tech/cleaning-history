<?php

class Model_Activity extends \Orm\Model_Soft
{
	protected static $_properties = array(
		'id',
		'action_id' => array(
			'data_type' => 'int',
			'label' => 'アクションID',
			'validation' => array(
				'required',
				'check_action_id',
			),
		),
		'action_name',
		'staffm_sh_id' => array(
			'data_type' => 'text',
			'label' => '担当者ID',
			'validation' => array(
				'required',
				'check_exists_staffm_sh_id',
			),
		),
		'staffm_sh_name' => array(
			'data_type' => 'text',
			'label' => '担当者氏名',
			'validation' => array(),
		),
		'staffm_ka_name' => array(
			'data_type' => 'text',
			'label' => '担当者部署名',
			'validation' => array(),
		),
		'staffm_byoto_name' => array(
			'data_type' => 'text',
			'label' => '担当者病棟名',
			'validation' => array(),
		),
		'scope_id' => array(
			'data_type' => 'text',
			'label' => 'スコープID',
			'validation' => array(
				'remove_emoji',
				'required',
				'match_scope',
			),
		),
		'device',
		'action_completed_at' => array(
			'data_type' => 'time_mysql',
			'label' => '実施日時',
		),
		'created_staffm_sh_id',
		'created_staffm_sh_name',
		'created_staffm_ka_name',
		'created_staffm_byoto_name',
		'updated_staffm_sh_id',
		'updated_staffm_sh_name',
		'updated_staffm_ka_name',
		'updated_staffm_byoto_name',
		'removed_at',
		'removed_staffm_sh_id',
		'created_at',
		'updated_at',
		'has_eve_check_error',
	);

	protected static $_observers = array(
		'Orm\Observer_Self' => array(
			'events' => array('before_save', 'after_insert', 'after_update', 'before_delete'),
		),
		'Orm\Observer_Typing',
		'Orm\Observer_CreatedAt' => array(
			'events' => array('before_insert'),
			'mysql_timestamp' => true,
		),
		'Orm\Observer_UpdatedAt' => array(
			'events' => array('before_update'),
			'mysql_timestamp' => true,
		),
	);
	protected static $_table_name = 'activities';
	protected static $_soft_delete = array(
		'deleted_field' => 'removed_at',
		'mysql_timestamp' => true,
	);

	protected static $_has_many = array(
		'activity_fields' => array(
			'key_to' => 'activity_id',
			'model_to' => 'Model_Activity_Field',
			'cascade_delete' => false,
		),
		'activity_histories' => array(
			'key_to' => 'activity_id',
			'model_to' => 'Model_Activity_History',
			'cascade_delete' => false,
		),
	);

	protected static $_to_array_exclude = array(
		'created_staffm_sh_id',
		'created_staffm_sh_name',
		'created_staffm_ka_name',
		'created_staffm_byoto_name',
		'updated_staffm_sh_id',
		'updated_staffm_sh_name',
		'updated_staffm_ka_name',
		'updated_staffm_byoto_name',
		'removed_at',
		'removed_staffm_sh_id',
	);

	public function _event_before_save()
	{
		// action_name セット
		$action = Model_Action::find($this->action_id);
		if ($action)
		{
			$this->action_name = $action->name;
		}

		// cis_name セット
		$sess = Session::instance();
		$this->staffm_sh_name = $sess->get('cis_name');
		$this->staffm_ka_name = $sess->get('cis_ka_name');
		$this->staffm_byoto_name = $sess->get('cis_byoto_name');
		$staffm = Model_Staffm::findByStaffmShId($this->staffm_sh_id);
		if ($staffm)
		{
			$this->staffm_sh_name = $staffm->getName();
			$this->staffm_ka_name = $staffm->getBusyoName();
			$this->staffm_byoto_name = $staffm->getByotoName();
		}

		$this->device = Input::get_device_name();

		if ($this->created_staffm_sh_id)
		{
			$staffm = Model_Staffm::findByStaffmShId($this->created_staffm_sh_id);
			if ($staffm)
			{
				$this->created_staffm_sh_name = $staffm->getName();
				$this->created_staffm_ka_name = $staffm->getBusyoName();
				$this->created_staffm_byoto_name = $staffm->getByotoName();
			}
		}

		if ($this->updated_staffm_sh_id)
		{
			$staffm = Model_Staffm::findByStaffmShId($this->updated_staffm_sh_id);
			if ($staffm)
			{
				$this->updated_staffm_sh_name = $staffm->getName();
				$this->updated_staffm_ka_name = $staffm->getBusyoName();
				$this->updated_staffm_byoto_name = $staffm->getByotoName();
			}
		}

	}

	public function _event_after_insert()
	{
		$activity_history = Model_Activity_History::forge();

		$field_values = array(
		);
		foreach ($this->activity_fields as $activity_field)
		{
			$field_values[] = $activity_field->to_array();
		}

		$activity_history->from_array(array(
			'activity_id' => $this->id,
			'staffm_sh_id' => $this->created_staffm_sh_id,
			'staffm_sh_name' => $this->created_staffm_sh_name,
			'staffm_ka_name' => $this->created_staffm_ka_name,
			'staffm_byoto_name' => $this->created_staffm_byoto_name,
			'action_id' => $this->action_id,
			'action_staffm_sh_id' => $this->staffm_sh_id,
			'action_completed_at' => Date::create_from_string($this->action_completed_at, 'mysql'),
			'scope_id' => $this->scope_id,
			'field_values' => serialize($field_values),
			'method' => 'create',
			'device' => Input::get_device_name(),
		));

		$activity_history->save();
	}

	public function _event_after_update()
	{
		$activity_history = Model_Activity_History::forge();

		$field_values = array();
		foreach ($this->activity_fields as $activity_field)
		{
			$field_values[] = $activity_field->to_array();
		}

		$activity_history->from_array(array(
			'activity_id' => $this->id,
			'staffm_sh_id' => $this->updated_staffm_sh_id,
			'staffm_sh_name' => $this->updated_staffm_sh_name,
			'staffm_ka_name' => $this->updated_staffm_ka_name,
			'staffm_byoto_name' => $this->updated_staffm_byoto_name,
			'action_id' => $this->action_id,
			'action_staffm_sh_id' => $this->staffm_sh_id,
			'action_completed_at' => Date::create_from_string($this->action_completed_at, 'mysql'),
			'scope_id' => $this->scope_id,
			'field_values' => serialize($field_values),
			'method' => 'update',
			'device' => Input::get_device_name(),
		));

		$activity_history->save();
	}

	public function _event_before_delete()
	{
		$sess = Session::instance();
		if ($cis_id = $sess->get('cis_id'))
		{
			$this->removed_staffm_sh_id = $cis_id;
		}
	}

	public static function _validation_check_action_id($val)
	{
		$active = Validation::active();
		$active->set_message('check_action_id', '不正なアクションIDです。');

		$query = Model_Action::query()->where('id', $val);
		return $query->count() == 1;
	}

	public static function _validation_match_patient($val)
	{
		$active = Validation::active();
		$active->set_message('match_patient', '不正な患者番号です。');

		return Model_Patient::findByPatientId($val) ? true : false;
	}

	public static function _validation_match_scope($val)
	{
		$active = Validation::active();
		$active->set_message('match_scope', '不正なスコープIDです。');

		$mecenter_scope_code_format = Config::get('scope.mecenter_format');
		if ($mecenter_scope_code_format and
			preg_match($mecenter_scope_code_format, $val))
		{
			return true;
		}

		return false;
	}

	public static function _validation_match_washer($val)
	{
		$active = Validation::active();
		$active->set_message('match_washer', '不正な洗浄機器IDです。');

		$washer = Model_Washer::find('first', array(
			'where' => array(
				array('code', '=', $val),
			)
		));

		$result = false;
		$arr = array();
		if ($washer)
		{
			$result = true;
		}
		else
		{
			// MEセンターのフォーマットと一致するか
			$mecenter_washer_code_format = Config::get('washer.mecenter_format');
			if ($mecenter_washer_code_format and
				preg_match($mecenter_washer_code_format, $val))
			{
				$result = true;
			}
		}

		return $result;
	}

	public static function _validation_check_last_action($val)
	{
		$active = Validation::active();
		$scope_id = $active->fieldset()->validated('scope_id');
		$action_id = $active->fieldset()->validated('action_id');

		$activity_id = $active->fieldset()->validated('activity_id');
		Log::debug('activity_id => ' . $activity_id);

		if ($action = Model_Action::find($action_id))
		{
			$active->set_message(
				'check_last_action',
				$action->validate_last_action_error_message
			);

			$last_activity_query = Model_Activity::query();
			$last_activity_query
				->where(
					'scope_id', '=', $scope_id
				)
				->order_by('created_at', 'desc')
			;
			if ($activity_id !== '')
			{
				$last_activity_query->where(
					'id', '!=', $activity_id
				);
			}

			$last_action_id = $action->validate_last_action_id;
			$last_activity = $last_activity_query->get_one();

			if ($last_activity and $action->validate_last_action) {
				return $last_activity->action_id == $last_action_id;
			}
		}

		return true;
	}

	public static function _validation_check_exists_staffm_sh_id($val)
	{
		$active = Validation::active();
		$active->set_message('check_exists_staffm_sh_id', '無効な実施担当者IDです。');

		$query = Model_Staffm::query()
			->where('sh_id', '=', $val)
			->where('active_flg', '=', '1')
			->where('sh_ed_date', '=', '99991231')
		;

		return $query->count() == 1;
	}

	public function getActivityFieldByActionFieldId($action_field_id)
	{
		foreach ($this->activity_fields as $activity_field)
		{
			if ($activity_field->action_field_id == $action_field_id)
			{
				return $activity_field;
			}
		}

		return false;
	}

	public static function get_search_query($q = array(), $sort_by = 'created_desc', $limit = null, $offset = 0)
	{
		$action_fields = Model_Action_Field::find('all', array('order' => 'id'));
		$select_columns = array(
			'a.*',
		);
		foreach ($action_fields as $action_field)
		{
			$select_columns[] = '(SELECT value FROM activity_fields as af WHERE af.activity_id = a.id AND af.action_field_id = ' . DB::quote($action_field->id) . ') AS action_field_' . $action_field->id . '_value';
		}
		$sql = 'SELECT ' . implode(', ', $select_columns) . ' FROM activities AS a JOIN activity_fields AS af ON af.activity_id = a.id';
		$where = array();

		if (isset($q['date']) and $q['date'] !== '')
		{
			$where[] = 'created_at BETWEEN ' . DB::quote($q['date'] . ' 00:00:00') . ' AND ' . DB::quote($q['date'] . ' 23:59:59');
		}

		if (isset($q['staffm_ka_name']) and $q['staffm_ka_name'] !== '')
		{
			$where[] = 'staffm_ka_name LIKE ' . DB::quote('%' . $q['staffm_ka_name'] . '%');
		}

		if (isset($q['staffm_sh_id']) and $q['staffm_sh_id'] !== '')
		{
			$where[] = 'staffm_sh_id LIKE ' . DB::quote('%' . $q['staffm_sh_id'] . '%');
		}

		if (isset($q['action_id']) and $q['action_id'] !== '')
		{
			$where[] = 'action_id = ' . DB::quote($q['action_id']);
		}

		if (isset($q['has_eve_check_error']) and $q['has_eve_check_error'] !== '')
		{
			$where[] = 'has_eve_check_error = ' . DB::quote($q['has_eve_check_error']);
		}

		if (isset($q['scope_id']) and $q['scope_id'] !== '')
		{
			$where[] = 'scope_id LIKE ' . DB::quote('%' . $q['scope_id'] . '%');
		}

		if (isset($q['action_field']) and is_array($q['action_field']))
		{
			foreach ($q['action_field'] as $action_field_id => $str)
			{
				if ($str !== '')
				{
					$where[] = '(' .
						'af.action_field_id = ' . DB::quote($action_field_id) .
						' AND ' .
						'af.value LIKE ' . DB::quote('%' . $str . '%') .
						')'
					;
				}
			}
		}

		if (!empty($where))
		{
			$sql .= (' WHERE ' . implode(' AND ', $where));
		}

		$sql .= (' GROUP BY a.id');
		switch ($sort_by)
		{
			case 'scope_asc':
				$sql .= ' ORDER BY scope_id ASC';
				break;
			case 'scope_desc':
				$sql .= ' ORDER BY scope_id DESC';
				break;
			case 'eve_check_asc':
				$sql .= ' ORDER BY has_eve_check_error ASC';
				break;
			case 'eve_check_desc':
				$sql .= ' ORDER BY has_eve_check_error DESC';
				break;
			case 'action_asc':
				$sql .= ' ORDER BY action_id ASC';
				break;
			case 'action_desc':
				$sql .= ' ORDER BY action_id DESC';
				break;
			case 'staff_asc':
				$sql .= ' ORDER BY staffm_sh_id ASC';
				break;
			case 'staff_desc':
				$sql .= ' ORDER BY staffm_sh_id DESC';
				break;
			case 'ka_asc':
				$sql .= ' ORDER BY staffm_ka_name ASC';
				break;
			case 'ka_desc':
				$sql .= ' ORDER BY staffm_ka_name DESC';
				break;
			case 'created_asc':
				$sql .= ' ORDER BY action_completed_at ASC';
				break;
			case 'created_desc':
				$sql .= ' ORDER BY action_completed_at DESC';
				break;
		}
		if (preg_match('/^action_field_(\d+)_(asc|desc)$/', $sort_by, $m))
		{
			$sql .= (' ORDER BY action_field_' . $m[1] . '_value ' . $m[2]);
		}

		if ($limit)
		{
			$sql .= (' LIMIT ' . $offset . ', ' . $limit);
		}

		return DB::query($sql);
	}

	public function get_action_completed_at($format = '%Y-%m-%d %H:%M')
	{
		if (is_object($this->action_completed_at) and
			get_class($this->action_completed_at) == 'Fuel\Core\Date')
		{
			return $this->action_completed_at->format($format);
		}

		try
		{
			return Date::create_from_string(
				$this->action_completed_at,
				'mysql'
			)->format($format);
		}
		catch (UnexpectedValueException $e)
		{
			return $this->action_completed_at;
		}

		return $this->action_completed_at;
	}

	public function get_elapsed_message()
	{
		$action = Model_Action::find($this->action_id);
		if (! $action->return_elapsed_last_action)
		{
			return '';
		}

		$target_elapsed_action = Model_Action::find($action->return_elapsed_last_action_id);
		if (! $target_elapsed_action)
		{
			return '';
		}

		$last_activity = self::find('last', array(
			'where' => array(
				array('id', '!=', $this->id),
				array('scope_id', '=', $this->scope_id),
				array('action_id', '=', $target_elapsed_action->id),
			),
			'order_by' => array(
				array('created_at', 'desc'),
			),
		));

		if (! $last_activity)
		{
			return '';
		}

		// 対象の実施記録の実施日時から経過時間を計算する
		$elapsed = Date::time_ago(
			$last_activity->get_action_completed_at('%s'),
			Date::time()->format('%s')
		);

		return sprintf('%s の実施から %s しています。',
			$target_elapsed_action->name,
			$elapsed
		);
	}

}
