$(function(){
	$("table.editable > tbody > tr > td.editable").click(edit_togle());
});

function edit_togle(){
	var edit_flag=false;
	return function(){
		if (edit_flag) {
			return;
		}

		var $input = $("<input>")
			.attr("type", "text")
			.val($(this).text())
			.addClass('form-control')
		;

		var $origin = $("<input>")
			.attr("type", "hidden")
			.attr("name", "origin")
			.val($(this).text())
		;
		var $div = $('<div>').addClass('col-sm-6').wrapInner($input);
		$(this).html($div);
		$(this).append($origin);

		$("input:text", this).focus().blur(function(){
			save(this);
			var val = $(this).val();
			$(this).unbind().parent('div').after(val).remove();
			edit_flag = false;
		});
		edit_flag = true;
	}
}

