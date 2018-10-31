<?php

class View_Mailto_Edit extends ViewModel
{

	public function view()
	{
		$mailto = Model_Configure_Mailto::find($this->id);

		$fields = Fieldset::instance('mailto');
		$fields->populate($mailto)->repopulate();
		$fields->field('self_id')->set_value($this->id);

	}

}
