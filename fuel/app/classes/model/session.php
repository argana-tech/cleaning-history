<?php

class Model_Session extends \Orm\Model
{
	protected static $_properties = array(
		'id',
		'session_id',
		'previous_id',
		'user_agent',
		'ip_hash',
		'created',
		'updated',
		'payload',
	);

	protected static $_table_name = 'sessions';

}
