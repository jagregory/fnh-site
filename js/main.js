$(document).ready(function() {
	$('#previousReleases').hide();
	$('#previousReleasesToggle').click(function() {
		$('#previousReleases').toggle(250);
		$('#previousReleasesToggle').toggle();
	});
});