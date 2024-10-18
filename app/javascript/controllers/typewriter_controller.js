import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="typewriter"
export default class extends Controller {
  static targets = ['text', 'logo']

  connect() {
    console.log(this.textTarget.textContent);
    console.log(this.textTarget.getBoundingClientRect().width);
    this.index = 0
    this.typingSpeed = 100 // Adjust typing speed here (milliseconds)
    this.originalText = this.textTarget.textContent
    this.textTarget.textContent = "" // Clear the text initially
    this.type()
  }

  type() {
    if (this.index < this.originalText.length) {
      this.textTarget.textContent += this.originalText.charAt(this.index)
      this.index++
      setTimeout(() => this.type(), this.typingSpeed)
    }
  }

}
