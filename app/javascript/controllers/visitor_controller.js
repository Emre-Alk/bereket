import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="visitor"
export default class extends Controller {
  static targets = ['form', 'submitBtn']

  initialize(){
    const visitorInfo = JSON.parse(localStorage.getItem('visitorInfo'))

    if (visitorInfo) {
      const now = Date.now()
      const ecart = now - visitorInfo.setTime
      const min = 1

      // min en ms
      if (ecart > min*60*1000) {
        localStorage.clear()
      } else {
        for (const data in visitorInfo.donator) {
          const input = document.getElementsByName(`donator[${data}]`)
          input[0].value = visitorInfo['donator'][data]
        }
      }
    }
  }

  saveInfo(){
    // build a form object to manipulate data from it
    const formInfo = new FormData(this.formTarget)

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

    // setup time to clear LS next visit
    const timestamp = Date.now()

    // save it into localstorage of the user device as temporary
    localStorage.setItem("visitorInfo", JSON.stringify({donator: data, setTime: timestamp}))

    // check if form filled out
    if (this.enableSubmit(formInfo) === true) {
      this.submitBtnTarget.removeAttribute('disabled')
    } else {
      this.submitBtnTarget.setAttribute('disabled', '')
    }

  }

  enableSubmit(form){
    for (const value of form.values()) {
      if (!value) return false
    }
    return true
  }




}
