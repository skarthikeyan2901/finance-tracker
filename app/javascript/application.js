// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick"
import "Chart.bundle"

jQuery(document).on("click", "#form-submit-button", function(event) {
  var results = jQuery("#results");
  results.hide();
  var spinner = jQuery("#results-spinner");
  spinner.show();
  var formButtonElement = jQuery("#form-submit-button");
  var formInput = jQuery("#stock-input");
  var stock = formInput.val();
  console.log("pressed");
  debugger;
  jQuery.ajax({
    url: formButtonElement.data("url"),
    data: { stock: stock },
    method: 'GET',
    success: function(result) {
      spinner.hide();
      results.show();
      console.log(result)
    }
  })
})

jQuery(document).on("click", "#form-submit-button-friends", function(event) {
  var results = jQuery("#friend-results");
  results.hide();
  var spinner = jQuery("#results-spinner-friends");
  spinner.show();
  var formButtonElement = jQuery("#form-submit-button-friends");
  var formInput = jQuery("#user-input");
  var friend = formInput.val();
  console.log("pressed");
  debugger;
  jQuery.ajax({
    url: formButtonElement.data("url"),
    data: { friend: friend },
    method: 'GET',
    success: function(result) {
      spinner.hide();
      results.show();
      console.log(result)
    }
  })
})