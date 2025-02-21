import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pdf-generate"
export default class extends Controller {
  static targets = ['btn', 'modal', 'form', 'submitBtn']
  static values = {
    donId: Number,
    donatorId: Number
  }

  connect() {
    this.loadAnimation = this.loadAnimation.bind(this)
    this.form = new FormData(this.formTarget)
  }

  initialize(){
    this.timeoutId
    this.delay = 500
  }

  disconnect(){
    this.formTarget.removeEventListener('input', this.allowSubmit.bind(this))
    clearTimeout(this.timer)
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
  // generate() {
  //   const url = `/donators/${this.donatorIdValue}/donations/${this.donIdValue}/pdf`

  //   fetch(url)
  //   .then(response => response.json())
  //   .then((data) => {
  //       if (data.message === "job enqueued") {
  //         this.fetchCerfa(data)
  //       }
  //     })
  // }

  // fetchCerfa(data) {
  //   // const details = {
  //   //   headers: {
  //   //     "Accept" : "application/pdf"
  //   //   }
  //   // }
  //   // fetch(`/donators/${data.donator_id}/donations/${data.donation_id}/cerfa`, details)
  //   // fetch(`/donators/${data.donator_id}/donations/${data.donation_id}/cerfa`)
  //   fetch(`/donators/${data.donator_id}/donations/${data.donation_id}/cerfa_inline`)
  //   .then(response => {
  //     if (response.ok) {

  //       let status = 'loading'
  //       this.loadAnimation(status)

  //       setTimeout(() => {
  //         window.location.href = response.url
  //         status = 'reset'
  //         this.loadAnimation(status)

  //       }, 4000)
  //     }
  //   })
  // }

  // from view retrieve if profile is completed via {params} #generate()
  // if complete, proceed to ajax initiate job #generate/fetch
  // if not complete, display modal (form): #displayForm()
    // collect form inputs
    // if checkbox 'save info' is checked, ajax to update donator: #saveInfo()
      // success path: proceed to ajax initiate job
      // failure path: show object.errors retrieve form back-end
    // if not checked, build new payload and ajax it to initate job #generate()

  // ajax job success path: ajax to new location #downloadFile()
  // ajax job failure path: show custome msg 'contact support' #downloadFile()

  isComplete({params}){
    const isCompleted = params.payload.completed
    console.log('isComplete:', isCompleted)

    if (isCompleted === 'true') {
      this.generateJob()
      console.log('generate job path')
    } else {
      console.log('collect info path')
      this.toggleModal()
      this.formTarget.addEventListener('input', this.allowSubmit.bind(this))
    }
  }

  allowSubmit(event){
    if (this.timeoutId) {
      clearInterval(this.timeoutId)
    }

    this.timeoutId = setTimeout(() => {
      for (const pair of this.form.entries()) {
        console.log(pair[0], pair[1]);
      }
      const selectInput = event.target.name
      const newValue = event.target.value
      const rememberMeBtn = document.getElementById('remember')
      const oldValue = this.form.get(selectInput)

      if ((oldValue !== newValue) && (selectInput !== rememberMeBtn.name)) {
        this.submitBtnTarget.removeAttribute('disabled')
      } else {
        this.submitBtnTarget.setAttribute('disabled', true)
        console.log('disabled');

      }
    }, this.delay)

  }

  toggleModal(){
    const isOpen = this.modalTarget.classList.contains('-translate-y-full')
    if (isOpen) {
      this.modalTarget.classList.remove('-translate-y-full')
    } else {
      this.modalTarget.classList.add('-translate-y-full')
    }
  }

  collectInfo(event){
    event.preventDefault()

    const form = new FormData(event.target)
    const saveAccepted = form.get('remember')

    if (saveAccepted === 'on') {
      this.saveDonatorInfo(event)
    } else {
      // on the fly
      this.generateJob(form)
    }
  }

  saveDonatorInfo(event) {
    const form = new FormData(this.formTarget)

    const details = {
      method: 'PATCH',
      headers: {
        "Accept" : "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
      body: form
    }

    fetch(`${event.params.url}`, details)
    .then(response => {
      if (response.ok) {
        return response.json()
      }
      return Promise.reject(response)
    })
    .then((data) => {
      // success path: info is updated
      this.submitBtnTarget.setAttribute('disabled', true)
      this.toggleModal()
      this.generateJob()
      console.log('data', data)
    })
    .catch((response) => {
      // failure path: unprocessable entity
      response.json().then((errors) => {
        // donator.errors are received
        this.submitBtnTarget.setAttribute('disabled', true)
        const keys = Object.keys(errors)
        this.cleanOldErrors(keys)

        for (const key in errors) {
          console.log(`${key}: ${errors[key]}`)
          this.insertError(key, errors[key])
        }
      })
    })
  }

  cleanOldErrors(attributes){
    // Attributes = array of attributes issues by object.errors
    const oldErrors = document.querySelectorAll('.validation-alert')

    for (const oldError of oldErrors) {
      if (!attributes.includes(oldError.id)) {
        oldError.remove()
      }
    }
  }

  insertError(attribute, message){
    // retrieve the form field of the key (city, address...)
    // insert the value errros[key] (validation msg) under the field + add border red for invalid
    // do it for each key received

    const invalideField = document.getElementById(`donator_${attribute}`)

    // invalideField.setCustomValidity(`${message}`)
    // invalideField.setCustomValidity(" ")
    // invalideField.reportValidity()

    const parag = document.createElement('p')
    parag.innerText = `${message}`
    parag.classList.add('validation-alert', 'text-red-500', 'italic', 'text-sm')
    parag.setAttribute('id', `${attribute}`)

    const paragExits = document.getElementById(`${attribute}`)

    if (paragExits) {
      paragExits.replaceWith(parag)
      parag.classList.add('animate-bounce')
      setTimeout(() => {
        parag.classList.remove('animate-bounce')
      }, 1000);
    }
    invalideField.insertAdjacentElement("afterend", parag)
  }

  generateJob(payload) {
    this.toggleAllButtons('disable')
    let status = 'loading'
    this.loadAnimation(status)
    let data = null

    if (payload) {
      data = {
        first_name: payload.get('donator[first_name]'),
        last_name: payload.get('donator[last_name]'),
        address: payload.get('donator[address]'),
        city: payload.get('donator[city]'),
        country: payload.get('donator[country]'),
        zip_code: payload.get('donator[zip_code]')
      }
    }

    const details = {
      method: 'POST',
      headers: {
        "Accept" : "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
      body: payload ? JSON.stringify({content: data}) : null
    }

    fetch(`/donators/${this.donatorIdValue}/donations/${this.donIdValue}/pdf`, details)
    .then(response => {
      if (response.ok) {
        return response.json()
      }
      return Promise.reject(response)
    })
    .then((data) => {
      // success path
      if (payload) {
        this.toggleModal()
      }
      this.downloadFile(data.url, data.filename, data.token)
    })
    .catch((response) => {
      // fail path
      response.json().then((errors) => {
        console.log('errors', errors)
        // profile incomplet
          // rediriger vers donator#edit ou afficher partial donator#edit
          // plus, pas de check validation des infos onthefly applied.. to be carried somehow

      })
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

  downloadFile(url, filename, token) {
    setTimeout(() => {

      const details = {
        method: 'get',
        headers: {
          "Accept": "application/json",
        }
      }
      // re-do the fetch so that if !rep.ok, return Promise.reject(response)
      // then handle in the catch method
      fetch(`${url}?token=${token}`, details)
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
