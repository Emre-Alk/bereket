import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-button"
export default class extends Controller {
  static targets = ['button']

  toggle() {
    this.buttonTarget.toggleAttribute('disabled')
  }
}
