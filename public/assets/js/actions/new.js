$(function() {
	$('div#enableValidateLastActionFields').hide();
	$('input:checkbox#validateLastActionEnable').click(
		toggleValidateLastActionFields
	);
	toggleValidateLastActionFields();

	$('div#enableSendNoticeMailOnInvalidLastActionFields').hide();
	$('input:radio.sendNoticeMailOnInvalidLastAction').click(
		toggleSendNoticeMailOnInvalidLastActionFields
	);
	toggleSendNoticeMailOnInvalidLastActionFields();

	$('div#enableReturnElapsedLastActionFields').hide();
	$('input:radio.returnElapsedLastAction').click(
		toggleReturnElapsedLastActionFields
	);
	toggleReturnElapsedLastActionFields();

	$('div#enableValidateDuplicateActionFields').hide();
	$('input:checkbox#validateDuplicateAction').click(
		toggleValidateDuplicateActionFields
	);
	toggleValidateDuplicateActionFields();

	// modal を開く前のcallback
	var $modal = $('.modal');
	$modal.on('show.bs.modal', function() {
		$modal.find('.stringSettings').hide();
		$modal.find('input:radio.selectType').click(function() {
			var $radio = $(this);
			if ($radio.val() == 'barcode' || $radio.val() == 'input') {
				$modal.find('.stringSettings').show();
			} else {
				$modal.find('.stringSettings').hide();
				$modal.find('.stringSettings input').val('');
			}
		});

		var $checkedType = $modal.find('input:radio.selectType:checked');
		if ($checkedType.val() == 'barcode' || $checkedType.val() == 'input') {
			$modal.find('.stringSettings').show();
		} else {
			$modal.find('.stringSettings').hide();
			$modal.find('.stringSettings input').val('');
		}
	});

	// modal を閉じた後のcallback
	$modal.on('hidden.bs.modal', function() {
		$modal.find('p.help-block').remove();
		$modal.find('.form-group').removeClass('has-error');
		$modal.find('input:text').val('');
		$modal.find('input[type^=\'hidden\']').val('');
		renderFields();
	});

	renderFields();

	// フォームを送信前の処理
	$('form#actionsNew').on('submit', function () {
		if ($.isEmptyObject(fields)) {
			alert('入力項目が設定されていません。');
			return false;
		}

		$(this).append(
			$('<input>').attr({
				'type': 'hidden',
				'name': 'fields'
			}).val($.toJSON(fields))
		);
		return true;
	});
});
function toggleValidateLastActionFields()
{
	if ($('input:checkbox#validateLastActionEnable').prop('checked')) {
		$('div#enableValidateLastActionFields').show();
	} else {
		$('div#enableValidateLastActionFields').hide();
	}
}
function toggleSendNoticeMailOnInvalidLastActionFields()
{
	if ($('input:radio.sendNoticeMailOnInvalidLastAction:checked').val() == '1') {
		$('div#enableSendNoticeMailOnInvalidLastActionFields').show();
	} else {
		$('div#enableSendNoticeMailOnInvalidLastActionFields').hide();
	}
}
function toggleReturnElapsedLastActionFields()
{
	if ($('input:radio.returnElapsedLastAction:checked').val() == '1') {
		$('div#enableReturnElapsedLastActionFields').show();
	} else {
		$('div#enableReturnElapsedLastActionFields').hide();
	}
}
function toggleValidateDuplicateActionFields()
{
	if ($('input:checkbox#validateDuplicateAction').prop('checked')) {
		$('div#enableValidateDuplicateActionFields').show();
	} else {
		$('div#enableValidateDuplicateActionFields').hide();
	}
}

function saveField(modalId)
{
	var $modal = $('#' + modalId);
	$modal.find('p.help-block').remove();
	$modal.find('.form-group').removeClass('has-error');
	var inputs = $modal.find('form').serializeArray();
	var values = {
		is_patient_id_field: 0,
		is_washer_id_field: 0
	};
	var valid = true;
	$.each(inputs, function(i, field) {
		if (field.name == 'name' && field.value.length == 0) {
			valid = false;
			set_error(field.name, '必須項目が入力されていません。');
		}

		if (field.name == 'string_length_min' ||
		   field.name == 'string_length_max') {
			if (field.value.length > 0 && ! $.isNumeric(field.value)) {
				valid = false;
				set_error(field.name, '文字数制限を行う場合は、桁数を数字で入力してください。');
			}
		}

		if (field.name == 'string_regexp') {
			if (field.value.length > 0) {
				try {
					new RegExp(field.value);
				} catch (e) {
					alert(e);
					valid = false;
					set_error(field.name, '正規表現パターンが正しくありません。');
				}
			}
		}

		values[field.name] = field.value;
	});

	if (values['type'] == undefined) {
		valid = false;
		set_error('type', '必須項目が選択されていません。');
	}

	if (valid) {
		if (values['priority'] == undefined) {
			values['priority'] = (fields.length + 1) * 10;
		}

		if (values['tmp_id'] == undefined) {
			values['tmp_id'] = randobet(8);
			fields.push(values);
		} else {
			$.each(fields, function(i, f) {
				if (f['tmp_id'] == values['tmp_id']) {
					fields[i] = values;
				}
			});
		}
		$modal.modal('hide');
	}

	return false;
}
function set_error(field, err_msg)
{
	var $modal = $('#newField');
	var $input = $modal.find(':input[name^=\'' + field + '\']');
	$input
		.parents('.form-group')
		.addClass('has-error')
		.append(
			$('<p>')
			.addClass('help-block')
			.text(err_msg)
		)
	;
}
function renderFields()
{
	var $table = $('table#fields');
	$table.find('tbody').empty();


	if (fields.length > 0) {
		fields.sort(sort_by('priority', false, parseInt));
		$.each(fields, function(i, field) {
			var $tr = $('<tr>');
			$tr.append(
				$('<td>').text(field['priority'])
			);
			$tr.append(
				$('<td>').text(field['name'])
			);

			var type = '';
			if (field['type'] == 'barcode') {
				type += 'バーコード読み取り';
			} else if (field['type'] == 'input') {
				type += '手入力';
			} else {
				type += 'はい／いいえ';
			}
			if (field['is_required'] == '1') {
				type += '(必須項目)';
			}
			if (field['string_length_min'] && field['string_length_min'].length) {
				type += ', ' + field['string_length_min'] + '文字以上';
			}
			if (field['string_length_max'] && field['string_length_max'].length) {
				type += ', ' + field['string_length_max'] + '文字以下';
			}
			if (field['string_regexp'] && field['string_regexp'].length) {
				type += ', 正規表現(' + field['string_regexp'] + ')';
			}
			if (field['is_patient_id_field'] == '1') {
				type += ', 患者番号フィールド';
			}
			if (field['is_washer_id_field'] == '1') {
				type += ', 洗浄・消毒IDフィールド';
			}
			$tr.append(
				$('<td>').text(type)
			);

			$tr.append(
				$('<td>').append(
					$('<a>').attr({
						'href': '#',
						'title': 'field_' + field['tmp_id']
					}).text('編集')
					.on('click', openEditFieldModal)
				)
			);

			$tr.append(
				$('<td>').append(
					$('<a>').attr({
						'href': '#',
						'title': 'field_' + field['tmp_id']
					}).text('削除')
					.on('click', removeField)
				)
			);

			$tr.appendTo($table.find('tbody'));
		});
	}
}
function openEditFieldModal()
{
	var $anchor = $(this);
	var id = $anchor.attr('title').replace('field_', '');
	var found = null;
	$.each(fields, function(i, field) {
		if (field['tmp_id'] == id) {
			found = field;
			return false;
		}
	});

	if (found == null) {
		alert('見つかりませんでした。');
		return false;
	}

	var $modal = $('#editField');
	$.each(found, function(k, v) {
		if (k == 'name' ||
			k == 'string_length_min' || k == 'string_length_max' ||
			k == 'string_regexp') {
			$modal.find('input[name^=\'' + k + '\']').val(v);
		}

		if (k == 'is_required' || k == 'is_patient_id_field' || k == 'is_washer_id_field') {
			if (v == '1') {
				$modal.find('input[name^=\'' + k + '\']').prop('checked', true);
			} else {
				$modal.find('input[name^=\'' + k + '\']').prop('checked', false);
			}
		}

		if (k == 'type') {
			$modal.find('input[name^=\'type\']').each(function() {
				var $radio = $(this);
				if ($radio.val() == v) {
					$radio.prop('checked', true);
					return false;
				}
			});
		}

		if (k == 'tmp_id' || k == 'priority' || k == 'id') {
			$modal.find('input[name^=\'' + k + '\']').val(v);
		}
	});
	$modal.modal('show');
	return false;
}
function removeField()
{
	var $anchor = $(this);
	var id = $anchor.attr('title').replace('field_', '');
	var found = null, found_idx = null;

	$.each(fields, function(i, field) {
		if (field['tmp_id'] == id) {
			found = field;
			found_idx = i;
			return false;
		}
	});

	if (found == null) {
		alert('見つかりませんでした。');
		return false;
	}

	if (confirm('入力項目 \'' + found['name'] + '\' を削除してもよろしいですか')) {
		fields.splice(found_idx, 1);
	}

	renderFields();

	return false;
}

function sort_by(field, reverse, primer) {
	reverse = (reverse) ? -1 : 1;
	return function(a,b){
		a = a[field];
		b = b[field];
		if (typeof(primer) != 'undefined'){
			a = primer(a);
			b = primer(b);
		}
		if (a<b) return reverse * -1;
		if (a>b) return reverse * 1;
		return 0;
	}
}
