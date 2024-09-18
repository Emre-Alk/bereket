import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="star-rating"
export default class extends Controller {
  static targets = ['star', 'div']
  connect() {

  }

  rate(event){
    const currentStar = event.currentTarget
    const arrayStars = Array.from(currentStar.parentElement.children)
    const indexStar = arrayStars.indexOf(currentStar)

    const rating = arrayStars.filter((star) => arrayStars.indexOf(star) <= indexStar )
    const other = arrayStars.filter((star) => arrayStars.indexOf(star) > indexStar )

    rating.forEach((star) => this.fill(star.getElementsByTagName("*")[0]))
    other.forEach((star) => this.unfill(star.getElementsByTagName("*")[0]))

    this.displayMessage(rating.length)
  }

  fill(star){
    star.classList.remove('text-gray-300')
    star.classList.add('text-black')
  }

  unfill(star){
    star.classList.remove('text-black')
    star.classList.add('text-gray-300')
  }

  displayMessage(rating){
    const message = [
      "Très décevant.",
      "Décevant.",
      "Ni bon ni mauvais.",
      "Plutôt bien, mais",
      "Au top!"
    ]

  }


}
