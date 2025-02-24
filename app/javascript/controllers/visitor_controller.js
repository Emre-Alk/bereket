import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="visitor"
export default class extends Controller {
  static targets = ['form']

  // connect(){
  //   const inputs = document.getElementById('form').elements

  //   for (let i = 0; i < inputs.length; i++) {
  //     const element = inputs[i]
  //     if (element.nodeName === 'INPUT') {
  //       element.addEventListener('click', this.saveInfo.bind(this))
  //     }
  //   }
  // }

  // disconnect(){
  //   const inputs = document.getElementById('form').elements

  //   for (let i = 0; i < inputs.length; i++) {
  //     const element = inputs[i]
  //     if (element.nodeName === 'INPUT') {
  //       element.removeEventListener('click', this.saveInfo.bind(this))
  //     }
  //   }
  // }

  initialize(){
    const visitorInfo = JSON.parse(localStorage.getItem('visitorInfo'))

    if (visitorInfo) {
      for (const data in visitorInfo.donator) {
        const input = document.getElementsByName(`donator[${data}]`)
        input[0].value = visitorInfo['donator'][data]
      }
    }

  }

  saveInfo(){
    // build a form object to manipulate data from it
    const formInfo = new FormData(this.formTarget)
    const test = Object.fromEntries(formInfo)


    // build the visitor info payload
    const data = {
      email: formInfo.get('donator[email]'),
      first_name: formInfo.get('donator[first_name]'),
      last_name: formInfo.get('donator[last_name]'),
      address: formInfo.get('donator[address]'),
      city: formInfo.get('donator[city]'),
      country: formInfo.get('donator[country]'),
      zip_code: formInfo.get('donator[zip_code]')
    }

    // save it into localstorage of the user device as temporary
    localStorage.setItem("visitorInfo", JSON.stringify({donator: data}))
  }




}
