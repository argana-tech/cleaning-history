<?php
return array(
	'auto_id'                    => false,
	'form_template'              => "\n{open}\n{fields}\n{close}\n",
	'field_template'             => "<div class=\"form-group {error_class}\">\n{label}{required}\n{field}\n{description} {error_msg}\n</div>\n",
	'multi_field_template'       => "<div class=\"form-group {error_class}\">\n{group_label}{required}\n{fields}\n{description} {error_msg}\n</div>\n",
	'error_template'             => '<p class="help-block">{error_msg}</p>',
	'group_label'	             => '<span>{label}</span>',
	'required_mark'              => '*',
	'inline_errors'              => true,
	'error_class'                => 'has-error',
	'label_class'                => 'control-label',

	// tabular form definitions
	'tabular_form_template'      => "<table>{fields}</table>\n",
	'tabular_field_template'     => "{field}",
	'tabular_row_template'       => "<tr>{fields}</tr>\n",
	'tabular_row_field_template' => "\t\t\t<td>{label}{required}&nbsp;{field} {error_msg}</td>\n",
	'tabular_delete_label'       => "Delete?",
);
