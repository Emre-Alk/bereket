import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="star-rating"
export default class extends Controller {
  static targets = ['star', 'message', 'commentBtnOpen', 'commentForm', 'ratingForm', 'submitBtnOpen']

  sendReview(event){
    // prevent the form form being submitted
    event.preventDefault()

    // retrieve the form into a formData object
    const payload = {
      method: 'POST',
      headers: {
        'Accept': 'application/json'
      },
      body: new FormData(event.target)
    }

    // perform AJAX to back end
    // As the form is build on front with all strong params already
    // the controller shall permit the params
    fetch("/reviews", payload)
    .then(response => response.json())
    .then((data) => {
      // success path: if review can be saved => render 'thanks' partial receive from response
      this.element.outerHTML = data.html;
    })
    .catch ((error) => {
      //failure path: activerecond::recordnotsaved raised => build an error message to user
      const div = document.createElement('div')
      div.classList.add('flex-auto', 'bg-red-400', 'rounded-lg', 'px-3', 'py-2', 'w-fit', 'text-white', 'text-sm', 'tracking-wider', 'text-center', 'roboto-regular')
      div.innerText = "Une erreur est survenu. Nous allons résoudre ce désagrément dans les plus bref délais."

      // replace controller element by new div
      this.element.replaceWith(div)
    })
  }

  openComment(){
    // hide comment btn open when clicked
    this.commentBtnOpenTarget.classList.toggle('hidden')
    // display comment box
    this.commentFormTarget.classList.toggle('hidden')
  }

  rate(event){
    // able comment btn
    this.commentBtnOpenTarget.removeAttribute('disabled')

    // able send btn
    this.submitBtnOpenTarget.removeAttribute('disabled')

    // retrive star touched by the user
    const currentStar = event.currentTarget
    // collect all stars into a array
    const arrayStars = Array.from(currentStar.parentElement.children)
    // get the index of the touched star
    const indexStar = arrayStars.indexOf(currentStar)

    // create a new array from main array with all star below the touched star
    const rating = arrayStars.filter((star) => arrayStars.indexOf(star) <= indexStar )
    // create a new array from main array with all other star above the touched star
    const other = arrayStars.filter((star) => arrayStars.indexOf(star) > indexStar )


    // for each star of the rating array, color it to black
    rating.forEach((star) => this.fill(star.getElementsByTagName("*")[0]))
    // for each star of the other array, remove color
    other.forEach((star) => this.unfill(star.getElementsByTagName("*")[0]))

    // if user give a 5/5 star, color all stars in gold
    if (rating.length == 5 ) {
      rating.forEach((star) =>
        star.getElementsByTagName("*")[0].classList.add('text-yellow-300')
      )
    }

    // display a message in fct of the rating given by user
    this.displayMessage(rating)

    // write rating score inside hidden input of the form
    this.ratingFormTarget.value = rating.length
  }

  fill(star){
    // remove previous possible colors and color in black
    star.classList.remove('text-gray-300', 'text-yellow-500')
    star.classList.add('text-black')
  }

  unfill(star){
    // remove previous possible colors and color in default
    star.classList.remove('text-black', 'text-yellow-500')
    star.classList.add('text-gray-300')
  }

  displayMessage(rating){
    const prompt = [
      "Très décevant. Qu'est-ce qui vous a déplu ?",
      "Décevant. Qu'est-ce qui vous a déplu ?",
      "Ni bon ni mauvais. Qu'est-ce qui vous a déplu ?",
      "Plutôt bien, mais qu'est ce qui faudrait amélioré ?",
      "Au top ! Qu'avez vous apprécié le plus ?"
    ]
    let message = ""

    // return a prompt in fonction of the rating index 0 being 1 star
    switch (rating.length) {
      case 1:
        message = prompt[0]
        break;
      case 2:
        message = prompt[1]
        break;
      case 3:
        message = prompt[2]
        break;
      case 4:
        message = prompt[3]
        break;
      case 5:
        message = prompt[4]
        break;

      default:
        console.log('something went wrong');
        break;
    }

    // display returned message inside the target container
    this.messageTarget.innerText = message
  }
}
