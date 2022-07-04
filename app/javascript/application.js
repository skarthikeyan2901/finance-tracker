// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

jQuery("#form-submit-button").on("click", function(event) {
  // event.preventDefault();
  var formButtonElement = jQuery("#form-submit-button");
  var formInput = jQuery("#stock-input");
  var stock = formInput.val();
  jQuery.ajax({
    url: formButtonElement.data("url"),
    data: { stock: stock },
    method: 'GET',
    success: function(result) {
      console.log(result)
    }
  })
})

jQuery("#form-submit-button-friends").on("click", function(event) {
  // event.preventDefault();
  var formButtonElement = jQuery("#form-submit-button-friends");
  var formInput = jQuery("#user-input");
  var friend = formInput.val();
  jQuery.ajax({
    url: formButtonElement.data("url"),
    data: { friend: friend },
    method: 'GET',
    success: function(result) {
      console.log(result)
    }
  })
})