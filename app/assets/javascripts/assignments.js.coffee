# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'click', '#assignments_search_btn', (event) ->
  subject_id = $("select[name='assignment[subject_id]']").val()
  problem_id = $("select[name='assignment[problem_id]']").val()
  window.location.href = "/assignments?subject_id=" + subject_id + "&problem_id=" + problem_id

$(document).on 'change', "select[name='assignment[subject_id]']", (event) ->
  subject_id = $("select[name='assignment[subject_id]']").val()
  window.location.href = "/assignments?subject_id=" + subject_id
