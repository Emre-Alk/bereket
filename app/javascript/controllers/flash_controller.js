import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = ['flash']

  connect() {
    setTimeout(() => {

      this.flashTarget.classList.remove('opacity-100') // Fades out the flash message
      this.flashTarget.classList.add('opacity-0') // Fades out the flash message
      this.flashTarget.addEventListener('transitionend', () => {
        this.flashTarget.remove() // Removes element after fade-out
      })

    }, 1800);
  }
}
