import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="favorite"
export default class extends Controller {
  static targets = ['heart']
  static values = {
    donatorId: Number,
    placeId: Number,
    fav: Object,
  }

  connect() {
    console.log("hello fav")
  }

  actuate(event) {
    event.preventDefault()
    const heart = this.heartTarget.querySelector("#heart")

    if (heart.getAttribute("style")) {
      // scenario: already favorite, I destroy the favorite
      // Change the icon from fill red to hollow (no animation)
      heart.removeAttribute("style")
      heart.classList.toggle("fa-regular")
      heart.classList.toggle("fa-solid")
      // Ajax to fav ctrl def destroy
      const url_destroy = `/donators/${this.donatorIdValue}/favorites/${this.favValue.id}`
      let method_destroy = 'DELETE'
      this.fetchFavorite(url_destroy, method_destroy)
    } else {
      // scenario: not yet favorite, I create a favorite
      // Change the icon from hollow to red fill and animation
      heart.setAttribute("style", "color: red")
      heart.classList.toggle("fa-regular")
      heart.classList.toggle("fa-solid")
      heart.classList.add("fa-2xl")
      heart.classList.add("fa-bounce")
      setTimeout(() => {
        heart.classList.remove("fa-bounce");
        heart.classList.remove("fa-2xl")
      }, 1000)
      // Ajax to fav ctrl def create
      const url_create = `/donators/${this.donatorIdValue}/favorites`
      let method_create = 'POST'
      this.fetchFavorite(url_create, method_create)
    }
  }

  fetchFavorite(path, verb) {
    const url = path
    let details = {}
    if (verb === 'POST') {
      details = {
        method: `${verb}`,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content"),
        },
        body: JSON.stringify( { content: this.placeIdValue } )
      }
    } else {
      details = {
        method: `${verb}`,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content"),
        }
      }
    }
    const favContainer = this.heartTarget
    fetch(url, details)
    .then(response => response.json())
    .then((data) => {
      console.log(data.message);
      if (data.message === 'created') {
        favContainer.outerHTML = data.html_favorite_icon
      }
    }
    )
  }

}
