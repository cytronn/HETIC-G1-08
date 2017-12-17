# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

addCover = ->
  $('#dish_cover').on 'change', (e) ->
    readURL(this);

readURL = (input) ->
  if (input.files && input.files[0])
    reader = new FileReader()

  reader.onload = (e) ->
    $('.yuumm-add-dish .yuumm-form-intro').css({
      'background': "#000 url('#{e.target.result}') no-repeat center center",
      'background-size': 'cover'
    });

  reader.readAsDataURL(input.files[0]);


$(document).ready(addCover)
$(document).on('turbolinks:load', addCover)
