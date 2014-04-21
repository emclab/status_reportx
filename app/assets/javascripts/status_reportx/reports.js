// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
   $("#report_report_from_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#report_report_to_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#report_report_date").datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
	$("#report_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
    $("#report_end_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});