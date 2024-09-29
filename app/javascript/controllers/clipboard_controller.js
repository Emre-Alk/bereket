import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets =['source', 'defaultIcon', 'successIcon']
  // source is the target whome value is to be copied

  copy(event) {
    // in case the source is inside a link anchor and don't want browser to redirect on click
    event.preventDefault()
    // copy the source value in the clipboard
    if (this.sourceTarget.hasAttribute('value')) {
      navigator.clipboard.writeText(this.sourceTarget.value)
    } else {
      navigator.clipboard.writeText(this.sourceTarget.innerText)
    }

    this.defaultIconTarget.classList.toggle('hidden')
    this.successIconTarget.classList.toggle('hidden')
    setTimeout(() => {
      this.defaultIconTarget.classList.toggle('hidden')
      this.successIconTarget.classList.toggle('hidden')
    }, 2000)

  }

  displayCopy(){
    const textSource = this.sourceTarget.innerText
    this.sourceTarget.firstChild.replaceWith(this.sourceTarget.value)
    setTimeout(() => {
      this.sourceTarget.firstChild.replaceWith(textSource)
    }, 2000);

  }
}
