$(function() {
	$('select#action_id').change(loadActionFields);
	loadActionFields();

	$('.enable_datepicker').datepicker({
		format: 'yyyy-mm-dd'
	});
	$('.enable_timepicker').timepicker({
		minuteStep: 5,
		showSeconds: false,
		showMeridian: false
	});

	$('input#scope_id').change(checkScopeId);
	$('select#action_id').change(checkScopeId);
	checkScopeId();

	$(document).on('change', 'input.is_patient_id_field', function() {
		checkPatientId(this);
	});
	$(document).on('change', 'input.is_washer_id_field', function() {
		checkWasherId(this);
	});

	$('form#activity_new').submit(checkValidate);

});
function loadActionFields() {
	var action_id = $('select#action_id').val();
	if (action_id == '') {
		$('div#action_fields').empty();
		return;
	}
	$.ajax({
		url: get_fields_url + '/' + action_id,
		type: 'get',
		dataType: 'json',
		success: function(data, status) {
			$('div#action_fields').empty();
			$(data.action.fields).each(function() {
				var action = this;
				var error = {value: null, error: ''};
				if (fields_error['field_' + action.id] != undefined) {
					error = fields_error['field_' + action.id];
				}
				var $div = $('<div>');
				$div.addClass('form-group');

				var $label = $('<label>').addClass('control-label').text(action.name);
				if (action.is_required == 1) {
					$label.append(' *');
				}

				var $field;
				if (action.type != 'boolean') {
					$field = $('<input>').addClass('form-control').attr('name', 'fields[' + action.id + ']');
					if (error.value) {
						$field.val(error.value);
					}
				} else {
					$field = $('<div>');
					var $radio_y = $('<div>').addClass('radio').append(
						$('<label>').append(
							$('<input>').attr('type', 'radio').val(1).attr('name', 'fields[' + action.id + ']')
						).append('はい')
					);
					var $radio_n = $('<div>').addClass('radio').append(
						$('<label>').append(
							$('<input>').attr('type', 'radio').val(0).attr('name', 'fields[' + action.id + ']')
						).append('いいえ')
					);
					if (error.value == 1) {
						$radio_y.find('input').attr('checked', 'checked');
					} else {
						$radio_n.find('input').attr('checked', 'checked');
					}
					$field.append($radio_y).append($radio_n);
				}

				if (action.is_patient_id_field == 1) {
					$field.addClass('is_patient_id_field');
				}
				if (action.is_washer_id_field == 1) {
					$field.addClass('is_washer_id_field');
				}

				var $error = $('<p>').addClass('help-block');
				if (error.error != '') {
					$div.addClass('has-error');
					$error.text(error.error);
				}
				$div.append($label).append($field).append($error);
				$div.appendTo($('div#action_fields'));
			});
			$('input.is_patient_id_field').each(function() {
				checkPatientId(this);
			});
			$('input.is_washer_id_field').each(function() {
				checkWasherId(this);
			});
		},
		error: function(res, status, thrown) {
			alert(res.responseText);
		}
	});
}

function checkScopeId()
{
	var $input = $('input#scope_id');
	var scope_id = $input.val();
	var action_id = $('select#action_id').val();
	if (scope_id == '') {
		return;
	}

	$.ajax({
		url: check_scope_url,
		type: 'get',
		dataType: 'json',
		data: {'scope_id': scope_id, 'action_id': action_id},
		success: function(data, status) {
			if (data.format_result == false) {
				alert('[' + scope_id + ']はスコープIDではない可能性があります。');
			}
			var msg = '';
			var last_activity = data.last_activity;
			if (last_activity.duplicate_action == true) {
				alert(last_activity.duplicate_action_message.replace('\\n', '\n'));
			}

			if (data.result == true && last_activity) {
				msg += '「' + last_activity.action_name + '」の履歴から' + last_activity.elapsed;
			}
			$input.next('span.scope_data').remove();
			var $span = $('<span>').addClass('scope_data').text(msg);
			$input.after($span);
		}
	});
}

function checkPatientId(input)
{
	var $input = $(input);
	var patient_id = $input.val();
	if (patient_id == '') {
		return;
	}

	$.ajax({
		url: check_patient_url + '/' + patient_id,
		type: 'get',
		dataType: 'json',
		success: function(data, status) {
			if (data.result == false) {
				alert('[' + patient_id + ']で検索しましたが該当するデータは見つかりませんでした。\nこのまま登録しますがよろしいですか？');
			}

			var msg = '';
			var patient = data.patient;
			if (data.result == true && patient) {
				msg += '氏名:' + patient.PT_KJ_NAME + '、カナ:' + patient.PT_KN_NAME;
			}
			$input.next('span.patient_data').remove();
			var $span = $('<span>').addClass('patient_data').text(msg);
			$input.after($span);
		}
	});
}

function checkWasherId(input)
{
	var $input = $(input);
	var washer_id = $input.val();
	if (washer_id == '') {
		return;
	}

	$.ajax({
		url: check_washer_url + '/' + washer_id,
		type: 'get',
		dataType: 'json',
		success: function(data, status) {
			if (data.result == false) {
				alert('[' + washer_id + ']で検索しましたが該当する洗浄種別は見つかりませんでした。\n登録されていない洗浄・消毒機器、または洗浄・消毒機器IDではない可能性があります。');
			}

			var msg = '';
			var washer = data.washer_data;
			if (data.result == true && washer) {
				if (washer.alert_message) {
					alert(washer.alert_message);
				}
				if (washer.type) {
					msg += '洗浄種別:' + washer.type;
				}
				if (washer.solution) {
					if (msg) {
						msg += '、';
					}
					msg += '薬剤:' + washer.solution;
				}
			}
			$input.next('span.washer_data').remove();
			var $span = $('<span>').addClass('washer_data').text(msg);
			$input.after($span);
		}
	});
}

function checkValidate()
{
	var $form = $('form#activity_new');
	var post_data = $form.serializeArray();

	var msg = '';
	$.ajax({
		url: validate_url,
		type: 'post',
		dataType: 'json',
		data: post_data,
		async: false,
		success: function(data, status) {
			if (data.errors.validate_last_action) {
				$.each(data.errors, function() {
					msg += this.replace('\\n', '\n') + '\n';
				});
			}
		}
	});

	if (msg != '') {
		return confirm(msg);
	}
}
