import { Controller } from "@hotwired/stimulus"
import {loadStripe} from '@stripe/stripe-js'


// Connects to data-controller="stripe"
export default class extends Controller {
  static targets = ['form', 'submit']

  async connect() {

    const {publishableKey} = await fetch('/assos/account/stripe').then(response => response.json())
    const stripe = await loadStripe(publishableKey)
    const myForm = this.formTarget
    myForm.addEventListener('submit', handleForm)

    async function handleForm(event) {
      event.preventDefault()

      const submitBtn = document.getElementById('submitBtn')
      if (submitBtn) {
        submitBtn.children[0].remove()
        const spinner = document.getElementById('spinner')
        spinner.classList.toggle('hidden')
      }

      const form = new FormData(myForm)

      const accountToken = await stripe.createToken('account', {
        account: {
          business_type: 'non_profit',
          company: {
            name: form.get('name'),
            structure: form.get('structure'),
            address: {
              line1: form.get('line1'),
              postal_code: form.get('postal_code'),
              city: form.get('city'),
              country: form.get('country')
            },
            tax_id: form.get('tax_id') ? form.get('tax_id') : '000000000'
          },
          tos_shown_and_accepted: true
        }
      })


      if (accountToken.token) {
        const field = document.getElementById('token_account')
        field.value = accountToken.token.id
        myForm.submit()

      } else {
        console.log('error');
      }
    }


  }
}
