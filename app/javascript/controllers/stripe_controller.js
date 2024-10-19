import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stripe"
export default class extends Controller {
  connect() {
  }

  token(event){
    // event.preventDefault()
    console.log('prevented');
  }
}
