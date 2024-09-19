import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets =['source']
  // source is the target whome value is to be copied

  copy(event) {
    // in case the source is inside a link anchor and don't want browser to redirect on click
    event.preventDefault()
    // copy the source value in the clipboard
    navigator.clipboard.writeText(this.sourceTarget.value)
  }
}
