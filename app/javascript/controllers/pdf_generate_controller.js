import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pdf-generate"
export default class extends Controller {
  static targets = ['btn']
  static values = {
    donId: Number,
    donatorId: Number
  }

  connect() {
  }
  // on click:
  // play loading animation
  // then, fetch get generate pdf action
  // then, response if ok : receive pdf data, stop animation, send data to user
  generate() {
    const url = `/donators/${this.donatorIdValue}/donations/${this.donIdValue}/pdf`

    fetch(url)
    .then(response => response.json())
    .then((data) => {
        if (data.message === "job enqueued") {
          this.fetchCerfa(data)
          console.log(data.message);
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
        console.log(response)
        if (response.ok) {

          setTimeout(() => {
            window.location.href = response.url
          }, 4000)

        }
      })


  }
}
