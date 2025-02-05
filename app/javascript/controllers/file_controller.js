import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="file"
export default class extends Controller {
  static targets = ['source', 'canvas', 'canvasContainer', 'form', 'submitBtn']

  connect() {
    this.formTarget.addEventListener('change', this.toggleSubmit.bind(this))
    this.form = new FormData(this.formTarget)
  }

  disconnect() {
    this.formTarget.removeEventListener('change', this.toggleSubmit.bind(this))
  }

  toggleSubmit(event) {
    console.log('change detected', event.target)
    console.log('form', this.form)

    const selectInput = event.target.name
    const newValue = event.target.value
    console.log('select', selectInput);
    console.log('newValue', newValue);

    const oldValue = this.form.get(selectInput)
    console.log('find', oldValue)

    if (oldValue !== newValue) {
      this.submitBtnTarget.removeAttribute('disabled')
    }
  }

  openField() {
    this.sourceTarget.click()
  }

  preview() {
    const reader = new FileReader()

    reader.onload = function () {
      this.canvasContainerTarget.classList.toggle('hidden')
      this.canvasTarget.src = reader.result
    }.bind(this)

    reader.readAsDataURL(this.sourceTarget.files[0])
  }


}
