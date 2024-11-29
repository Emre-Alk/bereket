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

  download({params}) {
    this.toggleAllButtons('disable')
    let status = 'loading'
    this.loadAnimation(status)
    console.log('donator', this.donatorIdValue);
    console.log('donID', this.donIdValue);



    fetch(`/donators/${this.donatorIdValue}/donations/${this.donIdValue}/pdf`)
    .then(response => response.json())
    .then((data) => {
      if (data.message === "job enqueued") {
        const url = params.payload.url
        console.log('url', url);

        const filename = params.payload.filename
        this.downloadFile(url, filename);
      }
    })
  }

  toggleAllButtons(message) {
    const buttons = document.querySelectorAll('.button')

    if (message === 'disable') {
      buttons.forEach((btn) => {
        btn.setAttribute("disabled", "")
        if (btn.id !== this.donIdValue.toString()) {
          btn.classList.toggle('opacity-50')
        }
      })
    } else {
      buttons.forEach((btn) => {
        btn.removeAttribute("disabled")
        if (btn.id !== this.donIdValue.toString()) {
          btn.classList.toggle('opacity-50')
        }
      })
    }
  }

  downloadFile(url, filename) {
    console.log('url next:', url)
    console.log('filename next:', filename)

    fetch(url)
      .then(response => response.blob())
      .then(blob => {
        console.log(blob);
        setTimeout(() => {

          const a = document.createElement('a');
          const objectUrl = URL.createObjectURL(blob);
          a.href = objectUrl;
          a.download = filename || 'file.pdf';
          document.body.appendChild(a); // Required for some mobile browsers
          a.click();
          document.body.removeChild(a); // Clean up
          URL.revokeObjectURL(objectUrl); // Release memory

          let status = 'reset'
          this.loadAnimation(status)
          this.toggleAllButtons()
        }, 5000)
      })
      .catch(error => {
        console.error('Error downloading the file:', error);
      });
  }

  fetchCerfa(data) {
    // const details = {
    //   headers: {
    //     "Accept" : "application/pdf"
    //   }
    // }
    // fetch(`/donators/${data.donator_id}/donations/${data.donation_id}/cerfa`, details)
    // fetch(`/donators/${data.donator_id}/donations/${data.donation_id}/cerfa`)
    fetch(`/donators/${data.donator_id}/donations/${data.donation_id}/cerfa_inline`)
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
    // const spin = document.querySelector(`.spinner-${this.donIdValue}`)
    const spin = document.getElementById(`spinner-${this.donIdValue}`)
    console.log('spinner', spin);

    if (status === 'loading') {
      console.log('animation loading');
      this.btnTarget.children[0].classList.toggle('hidden')
      spin.classList.toggle('hidden')
      spin.classList.toggle('flex')
    } else {
      console.log('animation reset');
      setTimeout(() => {
        // code executes sec before pfd opening so i set a timeout to cope with it
        spin.classList.toggle('hidden')
        spin.classList.toggle('flex')
        this.btnTarget.children[0].classList.toggle('hidden')
      }, 1000)
    }
  }
}
