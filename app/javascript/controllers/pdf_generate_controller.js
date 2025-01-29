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
  // 1st approach = send data inline:
  // hit the route (controller pdfs#generate) that initiate the 'job perform' in the back-end
  // then, if response from 'pdfs#generate' is ok, then hit the route (pdfs#view_pdf) that send_data(cerfa newly attached to model) to browser
  // result => modulo a setTimeout needed to cope with background job time to perform (<4s), the pdf is displayed inline
  // pbm => in PWA mode, the browser UI is not longer available so no more download menu mechanism. (no pbm in web app mode)
  // 2nd approach = send data inline + add btns to download :
  // hit the route (pdfs#cerfa_inline) that capture in an instance variable (@pdf_inline) the path (pdfs#view_pdf) to send data inline for the view (cerfa_inline.html.erb)
  // in the view, display the @pdf_inline within an iframe or object tag to see the pdf file inline
  // in the view, add btn to go back and to download
  // create a route (pdfs#download) with send_data 'attachment' (tried also send file to not send pdf in binary but file direcly) for the button to hit
  // download btn => see view several method attempted but none worked as expected. once clicked, a new view identical to 1st approach is open witout the UI.
  // 3rd approach:
  // hit the route (controller pdfs#generate) that initiate the 'job perform' in the back-end
  // then, if response from 'pdfs#generate' is ok, hit route (pdfs#download) to 'get' the pdf in the response
  // with the response, programmatically create a file Blob in JavaScript from url and use a hidden <a> tag to trigger the download mechanism
  // result in PWA => it opens the pdf inline like send data inline but add UI to download. no changes in web app mode.
  // CC => the best approach would still be the 2nd if can be solved.
  generate() {
    const url = `/donators/${this.donatorIdValue}/donations/${this.donIdValue}/pdf`

    fetch(url)
    .then(response => response.json())
    .then((data) => {
        if (data.message === "job enqueued") {
          this.fetchCerfa(data)
        }
      })
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
      if (response.ok) {

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

  download({params}) {
    this.toggleAllButtons('disable')
    let status = 'loading'
    this.loadAnimation(status)

    // test
    const data = {
      first_name: 'toto',
      last_name: 'tata',
      address: '1 rue des totos',
      city: 'lyon',
      country: 'france',
      zip_code: '69006'
    }
    const details = {
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        "Accept" : "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
      body: JSON.stringify({content: data})
    }

    const details2 = {
      method: 'POST',
      headers: {
        "Accept" : "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      }
    }

    fetch(`/donators/${this.donatorIdValue}/donations/${this.donIdValue}/pdf`, details)
    .then(response => response.json())
    .then((data) => {
      if (data.message === "job enqueued") {
        const url = params.payload.url
        const filename = params.payload.filename
        this.downloadFile(url, filename)
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
    setTimeout(() => {

      fetch(url)
      .then(response => response.blob())
      .then(blob => {

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
      })
      .catch(error => {
        console.error('Error downloading the file:', error);
      });
    }, 5000)
  }

  loadAnimation(status) {
    // const spin = document.querySelector(`.spinner-${this.donIdValue}`)
    const spin = document.getElementById(`spinner-${this.donIdValue}`)

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
