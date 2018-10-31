<?php

namespace Fuel\Tasks;

class Import_staffm_csv
{
	private $_temporary_table_name = 'staffm_temp';
	private $_original_table_name = 'staffm';

	public function run()
	{
		// CSV ファイルパスを config から取得
		$csv_file_path = \Config::get('staffm_csv.file_path');
		if (!is_file($csv_file_path))
		{
			die("csv file not found.\n");
		}

		// Shift_JIS で読み込み
		$csv_content = \File::read($csv_file_path, true);

		// UTF-8 に変換
		$csv_content = mb_convert_encoding($csv_content, 'utf-8', 'SJIS-win');

		ini_set('auto_detect_line_endings', 1);

		\DB::start_transaction();
		\DBUtil::set_connection('clinical-record');
		try
		{
			$this->_create_temporary_table();

			$staffm_columns = \DB::list_columns($this->_temporary_table_name);
			$inserted_count = 0;
			if ($csv_fh = fopen('php://temp', 'w+'))
			{
				// テンポラリーファイルに書き込む
				fwrite($csv_fh, $csv_content);
				fseek($csv_fh, 0);

				// テンポラリーファイルから fgetcsv を使って読み込む
				while (($row = fgetcsv($csv_fh)) !== FALSE)
				{
					array_walk(	/* 空白を除去 */
						$row,
						create_function('&$val', '$val = trim($val);')
					);

					$data = array();
					foreach (array_keys($staffm_columns) as $i => $col)
					{
						$data[$col] = $row[$i];
					}
					$insert_result = \DB::insert($this->_temporary_table_name)
						->set($data)
						->execute()
					;

					if ($insert_result[1] > 0)
					{
						$inserted_count += $insert_result[1];
					}
				}
				fclose($csv_fh);
			}

			if ($inserted_count > 0)
			{
				// オリジナルの table を drop
				\DBUtil::drop_table($this->_original_table_name);
				// テンポラリーの table から オリジナルの table を create
				\DB::query(
					'CREATE TABLE ' . \DB::quote_identifier($this->_original_table_name) . ' LIKE ' . \DB::quote_identifier($this->_temporary_table_name)
				)->execute();

				// テンポラリーの table から オリジナルの table に insert
				\DB::query(
					'INSERT INTO ' . \DB::quote_identifier($this->_original_table_name) . ' SELECT * FROM ' . \DB::quote_identifier($this->_temporary_table_name)
				)->execute();

				// テンポラリーの table を drop
				\DBUtil::drop_table($this->_temporary_table_name);
			}
		}
		catch (\Database_Exception $db_exception)
		{
			\DB::rollback_transaction();
			\Log::error($db_exception->__toString());

			$this->_send_error_mail($db_exception);

			die($db_exception->getMessage() . "\n");
		}

		// accounts に記載されている sh_id が含まれているかチェック
		if (!$this->_check_accounts())
		{
			\DB::rollback_transaction();
			die("not includes accounts in staffm.\n");
		}

		\DB::commit_transaction();
		echo "inserted {$inserted_count} record(s).\n";
	}

	private function _check_accounts()
	{
		$accounts = \Model_Account::find('all', array('select' => array('staffm_sh_id')));
		$found = false;
		foreach ($accounts as $account)
		{
			if (\Model_Staffm::is_include($account->staffm_sh_id))
			{
				$found = true;
			}
		}

		return $found;
	}

	private function _send_error_mail($e)
	{
		\Package::load('email');
		$email = \Email::forge();
		$email
			->to(
				\Config::get(
					'staffm_csv.error_mail_to',
					'torut@ebase-sl.jp'
				)
			)
			->subject('[CleaningHistory] ImportStaffmCsv')
			->body($e->__toString())
			;
		try
		{
			$email->send();
		}
		catch (\EmailValidationFailedException $e)
		{
		}
		catch (\EmailSendingFailedException $e)
		{
		}

		return;
	}

	private function _create_temporary_table()
	{
		\DBUtil::drop_table($this->_temporary_table_name);
		\DBUtil::create_table(
			$this->_temporary_table_name,
			array(
				'sh_id' => array('constraint' => 8, 'type' => 'char'),
				'sh_st_date' => array('constraint' => 8, 'type' => 'char'),
				'sh_ed_date' => array('constraint' => 8, 'type' => 'char'),
				'active_flg' => array('constraint' => 1, 'type' => 'char'),
				'sh_name' => array('constraint' => 20, 'type' => 'char'),
				'sh_kana_name' => array('constraint' => 20, 'type' => 'char'),
				'sh_type' => array('constraint' => 4, 'type' => 'char'),
				'sh_type_nm' => array('constraint' => 20, 'type' => 'char'),
				'ka_cd' => array('constraint' => 3, 'type' => 'char'),
				'ka_name' => array('constraint' => 20, 'type' => 'char'),
				'byoto_cd' => array('constraint' => 3, 'type' => 'char'),
				'byoto_name' => array('constraint' => 20, 'type' => 'char'),
				'user_id' => array('constraint' => 8, 'type' => 'char'),
				'password' => array('constraint' => 14, 'type' => 'char'),
				'pw_update_date' => array('constraint' => 8, 'type' => 'char'),
				'idm_no' => array('constraint' => 20, 'type' => 'char'),
				'tel1' => array('constraint' => 15, 'type' => 'char'),
				'tel2' => array('constraint' => 15, 'type' => 'char'),
				'last_op_id' => array('constraint' => 8, 'type' => 'char'),
				'last_date' => array('constraint' => 8, 'type' => 'char'),
				'last_time' => array('constraint' => 8, 'type' => 'char'),
			),
			array(),
			true,
			'InnoDB',
			'utf8'
		);

		\DBUtil::create_index(
			$this->_temporary_table_name,
			array('sh_id', 'sh_st_date'),
			'staffm_sh_id' . '_' . time(),
			'UNIQUE'
		);
	}

}
