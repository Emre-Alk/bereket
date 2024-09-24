import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ['fees']

  toggle(event) {
    this.feesTarget.classList.toggle('hidden')
    const icon = event.target
    icon.classList.toggle('fa-chevron-down')
    icon.classList.toggle('fa-chevron-up')
  }
}
