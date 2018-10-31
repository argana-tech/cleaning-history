<?php

class View_Washers_Edit extends ViewModel
{

	public function view()
	{
		$washer = Model_Washer::find($this->id);

		$fields = Fieldset::instance('washer');
		$fields->populate($washer)->repopulate();
		$fields->field('self_id')->set_value($this->id);

	}

}
