import { Controller } from "@hotwired/stimulus"
import { loadStripe } from '@stripe/stripe-js'


// Connects to data-controller="stripe"
export default class extends Controller {
  connect() {
  }

  token(event){
    event.preventDefault()
    const form = new FormData(this.element)

    const publishableKey = fetch('/assos/account/stripe')
    .then(response => response.json())
    .then((data) => {
      console.log(data.publishableKey);
      // const stripe = loadStripe(data.publishableKey)
      // const stripe = loadStripe('pk_live_51OtFSuGd9wN7UfIMLeZwm9WJrLGfIpOxlyBRX8b9at8GXa5dJfZbufP21jXMrbiXw7EAis9NKUMXGJbOkEPaGDhY00a8CPrQen')
      // console.log(stripe);
      // const accountToken = stripe.createToken({
      //   account: {
      //     business_type: 'non_profit',
      //     company: {
      //       name: form.get('name'),
      //       structure: 'incorporated_non_profit',
      //       address: {
      //         line1: form.get('line1'),
      //         postal_code: '69001',
      //         city: form.get('city'),
      //         country: 'FR'
      //       }
      //     },
      //     tos_shown_and_accepted: true
      //   }
      // })

      // console.log(accountToken);
    })


  }
}
