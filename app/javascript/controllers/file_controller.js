import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="file"
export default class extends Controller {
  static targets = ['source', 'canvas']

  connect() {
    console.log(this.sourceTarget);
    console.log('canvas', this.canvasTarget)

  }

  openField() {
    this.sourceTarget.click()
  }

  preview() {
    console.log(this.sourceTarget)
    console.log('canvas', this.canvasTarget)
    // this.canvasTarget.classList.remove('hidden')
    const reader = new FileReader()

    reader.onload = function () {
      this.canvasTarget.src = reader.result
      console.log('src', this.canvasTarget.src)
    }.bind(this)

    reader.readAsDataURL(this.sourceTarget.files[0])
  }


}
