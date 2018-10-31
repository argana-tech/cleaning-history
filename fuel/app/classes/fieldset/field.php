<?php

/**
 * override Fuel\Core\Fieldset_Field.
 */
class Fieldset_Field extends Fuel\Core\Fieldset_Field
{

	/**
	 * validated() で返す値を変更
	 * 通常の validated() では validation エラーがあったときは
	 * 空文字が返るため、入力した値をそのまま返したい
	 */
	public function validated()
	{
		$val = $this->fieldset()->validation()->validated($this->name);

		if ($this->error())
		{
			$val = $this->input();
		}

		return $val;
	}
}
