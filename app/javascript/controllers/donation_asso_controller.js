import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="donation-asso"
export default class extends Controller {
  static values = {
    url: String
  }

  connect() {
    console.log('hello donation asso')
  }

  createDonation(event){
    // prevent the form to be submitted already
    event.preventDefault()

    // grab the form to change amount into cents
    const donationForm = new FormData(event.target)
    // get the user's amount
    const amount = donationForm.get("donation[amount]")
    // format it to cents
    const amountFormated = amount * 100
    // overwrite the user's amount with the formated value
    donationForm.set("donation[amount]", amountFormated)

    // build the payload
    const payload = {
      method: 'POST',
      headers: {
        'Accept': 'application/json'
      },
      body: donationForm
    }

    // url to hit
    const url = `${this.urlValue}`

    // perform AJAX to back end
    // As the form is build on front with all strong params already
    // the controller shall permit the params
    fetch(url, payload)
    .then(response => response.json())
    .then((data) => {
      console.log(data.message)
      console.log(data.token)
      if (data.message == "successful") {

        this.element.outerHTML = data.html_donation_qrcode

      }
    })
  }


}
