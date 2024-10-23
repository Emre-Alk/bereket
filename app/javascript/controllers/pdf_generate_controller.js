import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pdf-generate"
export default class extends Controller {
  static targets = ['btn']
  static values = {
    donId: Number,
    donatorId: Number
  }

  connect() {
    this.loadAnimation = this.loadAnimation.bind(this)
  }
  generate() {
    const url = `/donators/${this.donatorIdValue}/donations/${this.donIdValue}/pdf`

    fetch(url)
    .then(response => response.json())
    .then((data) => {
        if (data.message === "job enqueued") {
          this.fetchCerfa(data)
          console.log('data message', data.message);
          console.log('don id', data.donation_id);
          console.log('donator id', data.donator_id);
        }
      })
  }

  fetchCerfa(data) {
    const details = {
      headers: {
        "Accept" : "application/pdf"
      }
    }
    fetch(`/donators/${data.donator_id}/donations/${data.donation_id}/cerfa`, details)
      .then(response => {
        console.log('response cerfa', response)
        if (response.ok) {
          console.log(response.url);

          let status = 'loading'
          this.loadAnimation(status)

          setTimeout(() => {
            window.location.href = response.url
            status = 'reset'
            this.loadAnimation(status)

          }, 4000)
        }
      })
  }

  loadAnimation(status) {
    const spin = document.querySelector(`.spinner-${this.donIdValue}`)

    if (status === 'loading') {
      this.btnTarget.children[0].classList.toggle('hidden')
      spin.classList.toggle('hidden')
      spin.classList.toggle('flex')
    } else {
      setTimeout(() => {
        // code executes sec before pfd opening so i set a timeout to cope with it
        spin.classList.toggle('hidden')
        spin.classList.toggle('flex')
        this.btnTarget.children[0].classList.toggle('hidden')
      }, 1000)
    }
  }
}
