<?php

namespace Fuel\Tasks;

class Export_ActionLog_From_AccessLog
{
	public function run()
	{
		$where = array(
			array('remote_addr', '!=', '10.20.10.20'),
			array('uri', '=', '/api/activity/save'),
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

		$filename = APPPATH . '/tmp/export_actionlog_from_accesslog.csv';

		if (is_file($filename))
		{
			\File::delete($filename);
		}

		$header = array(
			'activity_id',
			'新規/変更',
			'実施日付',
			'実施時刻',
			'実施者職員ID',
			'アクション名',
			'対象スコープID',
			'患者ID',
			'洗浄機器ID',
			'端末IPアドレス',
			'端末種類',
			'直前アクションエラー',
			'直前アクションエラーメッセージ',
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

				if (\Arr::get($response, 'errors'))
				{
					// エラーがあった
					continue;
				}

				$is_new_activity = true;
				// 上書き
				if (\Arr::get($post_data, 'activity_id'))
				{
					$is_new_activity = false;
				}

				$action_at = \Date::create_from_string(
					$record->timestamp,
					'mysql'
				);

				if (\Arr::get($response, 'action_completed_at'))
				{
					$action_at = \Date::create_from_string(
						\Arr::get($response, 'action_completed_at'),
						'mysql'
					);
				}

				$patient_data = $this->get_patient_data($response);
				$washer_data = $this->get_washer_data($response);

				$data = array(
					\Arr::get($response, 'activity.id'),
					$is_new_activity ? '新規' : '変更',
					$action_at->format('%Y/%m/%d'),
					$action_at->format('%H:%M:%S'),
					\Arr::get($response, 'activity.staffm_sh_id'),
					\Arr::get($response, 'activity.action_name'),
					\Arr::get($response, 'activity.scope_id'),
					$patient_data ? \Arr::get($patient_data, 'PT_ID') : null, // 患者ID,
					$washer_data ? \Arr::get($washer_data, 'code') : null, // 洗浄機器コード,
					$record->remote_addr,
					$record->device,
					\Arr::get($response, 'activity.has_eve_check_error', 0) ? 'あり' : 'なし',
					\Arr::get($response, 'activity.has_eve_check_error', 0)
					? \Arr::get($response, 'saved_message', null) : null,
				);

				$formatter = \Format::forge($data);

				\File::append(dirname($filename), basename($filename), $formatter->to_csv(null, null, true) . PHP_EOL);
			}
		}
	}

	private function get_patient_data($response)
	{
		$activity_fields = \Arr::get($response, 'activity.activity_fields', array());
		if ($activity_fields)
		{
			return \Arr::get(array_shift($activity_fields), 'patient_data');
		}

		return null;
	}

	private function get_washer_data($response)
	{
		$activity_fields = \Arr::get($response, 'activity.activity_fields', array());
		if ($activity_fields)
		{
			return \Arr::get(array_shift($activity_fields), 'washer_data');
		}

		return null;
	}
}
