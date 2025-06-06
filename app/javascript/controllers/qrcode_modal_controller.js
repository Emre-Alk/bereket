import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="qrcode-modal"
export default class extends Controller {
  static targets = ['modal']

  toggle(){
    const modal = document.getElementById('modal')
    modal.classList.toggle("-translate-y-full")
  }

}
