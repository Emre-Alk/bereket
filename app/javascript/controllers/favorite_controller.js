import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="favorite"
export default class extends Controller {
  static targets = ['heart']

  connect() {
    console.log("hello fav")
  }

  actuate(event) {
    event.preventDefault()
    const heart = this.heartTarget.querySelector("#heart")
    console.log(heart);
    if (heart.getAttribute("style")) {
      heart.removeAttribute("style")
      heart.classList.toggle("fa-regular")
      heart.classList.toggle("fa-solid")
    } else {
      heart.setAttribute("style", "color: red")
      heart.classList.toggle("fa-regular")
      heart.classList.toggle("fa-solid")
      heart.classList.add("fa-2xl")
      heart.classList.add("fa-bounce")
      setTimeout(() => {
        heart.classList.remove("fa-bounce");
        heart.classList.remove("fa-2xl")
      }, 1000)
    }
  }
}
