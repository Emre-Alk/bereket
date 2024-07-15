import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="donation"
export default class extends Controller {
  static targets = [ 'inputfield', 'confirmBox' ]
  connect() {
    console.log('hello donation');
    this.toggle = this.toggle.bind(this)
  }

  selected(event) {
    const button = event.target
  // pass the button black and set the value of the inputfield of the form with its own value
    button.classList.toggle("bg-white")
    button.classList.toggle("bg-black")
    button.classList.toggle("text-white")
    this.inputfieldTarget.value = button.value
  // popup confirmation page
    this.confirmBoxTarget.classList.toggle("-translate-y-full")
    let boxOpen = this.confirmBoxTarget.classList.contains("-translate-y-full")
    if (boxOpen) {
      document.addEventListener('touchstart', this.toggle)
    }
  }

  toggle(event) {
    const touched = this.confirmBoxTarget.contains(event.target)
  }
}
