# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('body').on 'click', '#choose-file-btn', ->
    $('#upload_file').click()

  $('body').on 'change', '#upload_file', ->
    filename = $('#upload_file').val()
    $('#file_name').val(filename)
    if filename == ""
      $('#upload-file-btn').attr('disabled', true)
      $('#choose-file-btn').removeClass('btn-success').addClass('btn-default')
      return
    $('#choose-file-btn').removeClass('btn-default').addClass('btn-success')
    $('#upload-file-btn').attr('disabled', false)

  $('body').on 'click', '#upload-file-btn', ->
    return if $('#upload_file').val() == ""

