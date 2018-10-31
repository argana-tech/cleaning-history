<?php

namespace Fuel\Tasks;

/**
 * 直前チェックエラーが発生したものを抽出する
 */
class Export_ActionLog_w_Invalid_From_AccessLog
{
	public function run()
	{
		$where = array(
			array('remote_addr', '!=', '10.20.10.20'),
			array('uri', '=', '/api/activity/validate'),
		);
		$count_query = \Model_Access_Log::query();
		$count_query->where($where);
		$total_items = $count_query->count();
		$per_page = 50;
		$total_page = ceil($total_items / 50);

		if ($total_items == 0)
		{
			exit;
		}

		$filename = APPPATH . '/tmp/export_actionlog_w_invalid_from_accesslog.csv';

		if (is_file($filename))
		{
			\File::delete($filename);
		}

		$header = array(
			'新規/変更',
			'変更対象ID',
			'実施日付',
			'実施時刻',
			'実施者職員ID',
			'アクション名',
			'対象スコープID',
			'患者ID',
			'洗浄機器ID',
			'端末IPアドレス',
			'端末種類',
			'直前チェックエラー',
		);
		\File::create(dirname($filename), basename($filename), \Format::forge($header)->to_csv(null, null, true) . PHP_EOL);

		for ($p = 1; $p <= $total_page; $p++)
		{
			$offset = ($p - 1) * $per_page;
			$model = \Model_Access_Log::query()
				->where($where)
				->limit($per_page)
				->offset($offset)
				->order_by('timestamp', 'desc')
			;

			foreach ($model->get() as $record)
			{
				$response = \Format::forge($record->response_values, 'json')->to_array();
				$post_data = \Arr::get($response, 'post_data', array());

				if (\Arr::get($response, 'errors.validate_last_action'))
				{
					$action_at = \Date::create_from_string(
						$record->timestamp,
						'mysql'
					);

					$is_new_activity = true;
					// 上書き
					if (\Arr::get($post_data, 'activity_id'))
					{
						$is_new_activity = false;
					}

					$patient_id = $this->get_patient_data($post_data);
					$washer_id = $this->get_washer_data($post_data);

					$data = array(
						$is_new_activity ? '新規' : '変更',
						$is_new_activity ? null : \Arr::get($post_data, 'activity_id'),
						$action_at->format('%Y/%m/%d'),
						$action_at->format('%H:%M:%S'),
						\Arr::get($post_data, 'staffm_sh_id'),
						\Arr::get($post_data, 'activity.action_name'),
						\Arr::get($post_data, 'scope_id'),
						$patient_id ?: null, // 患者ID,
						$washer_id ?: null, // 洗浄機器コード,
						$record->remote_addr,
						$record->device,
						\Arr::get($response, 'errors.validate_last_action'),
					);

					$formatter = \Format::forge($data);

					\File::append(dirname($filename), basename($filename), $formatter->to_csv(null, null, true) . PHP_EOL);
				}
			}
		}
	}

	private function get_patient_data($post_data)
	{
		$fields = \Arr::get($post_data, 'fields', array());

		foreach ($fields as $action_field_id => $value)
		{
			$action_field = \Model_Action_Field::find($action_field_id);
			if ($action_field and $action_field->is_patient_id_field)
			{
				return $value;
			}
		}

		return null;
	}

	private function get_washer_data($post_data)
	{
		$fields = \Arr::get($post_data, 'fields', array());

		foreach ($fields as $action_field_id => $value)
		{
			$action_field = \Model_Action_Field::find($action_field_id);
			if ($action_field and $action_field->is_washer_id_field)
			{
				return $value;
			}
		}

		return null;
	}
}
