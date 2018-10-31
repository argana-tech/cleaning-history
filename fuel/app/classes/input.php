<?php

/**
 * override Fuel\Core\Input class.
 */
class Input extends Fuel\Core\Input
{
	public static function is_ipod_touch()
	{
		return preg_match('/(iPod|CleanManageSystem|cleaning\-history)/', Input::user_agent());
	}

	public static function get_device_name()
	{
		$ua = Input::user_agent();

		// cleaning-history/1.12.0 (iPad; 7.0.4; iPhone OS; ja)
		$pattern = '/^cleaning\-history\/(.+?)\s\((.+?);\s(.+?);\s(.+?);\s(.+?)\)/';
		if (preg_match($pattern, $ua, $m))
		{
			// $m[1] = iOS app version
			// $m[2] = device model
			// $m[3] = iOS version
			// $m[4] = OS
			// $m[5] = language
			return $m[2];
		}

		return 'PC';
	}

}
