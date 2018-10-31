<?php

class Model_Access_Log extends \Orm\Model
{
	protected static $_properties = array(
		'id',
		'staffm_sh_id',
		'uri',
		'method',
		'request_values' => array(
			'data_type' => 'json',
		),
		'response_values',
		'device',
		'remote_addr',
		'timestamp',
	);

	protected static $_table_name = 'access_logs';

	protected static $_observers = array(
		'Orm\\Observer_Typing',
	);

}
