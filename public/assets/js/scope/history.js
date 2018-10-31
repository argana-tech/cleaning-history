$(function() {
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
});

function saveActivity()
{
	var $modal = $('#editModal');
	var $form = $('#editModal form');
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
