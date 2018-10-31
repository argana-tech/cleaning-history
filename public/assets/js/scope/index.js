$(function() {
	$('#editModal').on('shown.bs.modal', function() {
		var $modal = $(this);
		$modal.find('.enable_datepicker').datepicker({
			format: 'yyyy-mm-dd'
		});
		$modal.find('.enable_timepicker').timepicker({
			minuteStep: 5,
			showSeconds: false,
			showMeridian: false
		});
	});

	$('a.openEditModal').click(function() {
		var target = $(this).attr('href');
		var $modal = $('#editModal');
		$.ajax({
			url: target,
			type: 'get',
			dataType: 'json',
			success: function(data, status) {
				$modal.find('.modal-body').html(data.html);
				$modal.modal('show');
			},
			error: function(res, status, thrown) {
				$modal.find('.modal-body').html(res.responseText);
				$modal.modal('show');
			}
		});

		return false;
	});

	$('.enable_datepicker').datepicker({
		format: 'yyyy-mm-dd'
	});
	$('.enable_timepicker').timepicker({
		minuteStep: 5,
		showSeconds: false,
		showMeridian: false
	});
});

function saveActivity(type)
{
	if (type == undefined) {
		type = '#editModal';
	}
	var $modal = $(type);
	var $form = $(type + ' form');
	var data = $form.serializeArray();

	$.ajax({
		url: $form.attr('action'),
		type: 'post',
		dataType: 'json',
		data: $form.serializeArray(),
		success: function(data, status) {
			if (data.valid) {
				$modal.modal('hide');
				window.location.reload();
				return false;
			}
			$modal.find('.modal-body').html(data.html);
		},
		error: function(res, status, thrown) {
			$modal.find('.modal-body').html(res.responseText);
		}
	});

}
