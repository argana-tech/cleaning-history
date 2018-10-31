<?php

namespace Fuel\Tasks;

class Export_access_log
{
	public function run()
	{
		$where = array(
			array('remote_addr', '!=', '10.20.10.20'),
			array('uri', 'LIKE', '/api%'),
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

		if (is_file(APPPATH . '/tmp/export_access_log.csv'))
		{
			\File::delete(APPPATH . '/tmp/export_access_log.csv');
		}
		$header = array(
			'',
			'担当者ID',
			'Method',
			'URI',
			'リクエストデータ',
			'レスポンスデータ',
			'デバイス',
			'日時',
			'実施登録時直前チェックエラー発生',
			'患者番号エラー',
			'スコープIDエラー',
			'洗浄・消毒機器IDエラー',
		);
		\File::create(APPPATH, '/tmp/export_access_log.csv', \Format::forge($header)->to_csv(null, null, true) . PHP_EOL);

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
				$last_action_error = $this->check_last_action_error($record);
				$patient_error = $this->check_patient_error($record);
				$scope_format_error = $this->check_scope_format_error($record);
				$washer_format_error = $this->check_washer_format_error($record);
				$data = array(
					'id' => $record->id,
					'staffm_sh_id' => $record->staffm_sh_id,
					'method' => $record->method,
					'uri' => $record->uri,
					'request_values' => \Format::forge($record->request_values)->to_json(),
					'response_values' => $record->response_values,
					'device' => $record->device,
					'timestamp' => $record->timestamp,
					'has_last_action_error' => $last_action_error,
					'patient_error' => $patient_error,
					'scope_format_error' => $scope_format_error,
					'washer_format_error' => $washer_format_error,
				);
				$formatter = \Format::forge($data);
				\File::append(APPPATH, '/tmp/export_access_log.csv', $formatter->to_csv(null, null, true) . PHP_EOL);
			}
		}
	}

	private function check_last_action_error(\Model_Access_Log $record)
	{
		if ($record->uri == '/api/activity/save' or
			$record->uri == '/api/activity/validate')
		{
			if (preg_match('/"invalid_last_action":true/', $record->response_values))
			{
				return true;
			}
		}
		return false;
	}

	private function check_patient_error(\Model_Access_Log $record)
	{
		if (strpos($record->uri, '/api/patient/') === 0 and
			preg_match('/"result":false/', $record->response_values))
		{
			return true;
		}

		return false;
	}

	private function check_scope_format_error(\Model_Access_Log $record)
	{
		if ($record->uri == '/api/scope/' and
			preg_match('/"format_result":false/', $record->response_values))
		{
			return true;
		}

		return false;
	}

	private function check_washer_format_error(\Model_Access_Log $record)
	{
		if (strpos($record->uri, '/api/washer/') === 0 and
			preg_match('/"result":false/', $record->response_values))
		{
			return true;
		}

		return false;
	}
}
