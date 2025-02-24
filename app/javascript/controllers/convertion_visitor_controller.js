import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="convertion-visitor"
export default class extends Controller {

  connect() {
    console.log('hello convertion-visitor')
  }

  initialize(){
    const visitorInfo = JSON.parse(localStorage.getItem('visitorInfo'))

    if (!visitorInfo) {
      return
    }

    for (const data in visitorInfo.donator) {
      const input = document.getElementsByName(`user[${data}]`)
      input[0].value = visitorInfo['donator'][data]
    }

  }


  scrollTo(event) {
    event.preventDefault()
    // const form = document.getElementById('conversionForm')
    const form = document.getElementById('CTA-conversion')
    form.scrollIntoView({behavior: "smooth"})
  }
}
