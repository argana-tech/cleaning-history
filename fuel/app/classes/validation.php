<?php

/**
 * override Fuel\Core\Validation class.
 */
class Validation extends Fuel\Core\Validation
{
	public static function _validation_remove_emoji($val)
	{
		$active = Validation::active();
		$active->set_message(
			'remove_emoji',
			'入力した値に絵文字が含まれています。'
		);

		$found_emoji = preg_match(
			'/[\xF0-\xF7][\x80-\xBF][\x80-\xBF][\x80-\xBF]/',
			$val
		);

		return $found_emoji ? false : true;
	}
}
