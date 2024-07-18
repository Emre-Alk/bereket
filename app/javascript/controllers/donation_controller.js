import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="donation"
export default class extends Controller {
  static targets = [ 'inputfield', 'confirmBox', 'monDon', 'submitBtn', 'message']
  static values = {
    donatorId: String,
    placeId: String
  }
  connect() {
    console.log('hello donation');
    const confirmBox = this.confirmBoxTarget
    // this.donationForm = document.getElementById("formDon")
    this.overlay = document.getElementById('overlay')
    this.customValue = this.customValue.bind(this)
  }

  showConfirm(event) {
    if (event) {
      console.log('w/ event');
      event.preventDefault()
      confirmBox.classList.add("-translate-y-full")
      this.inputfieldTarget.value = event.target.value
      this.monDonTarget.innerText = `${event.target.value} €`
      this.monDonTarget.setAttribute("value", `${event.target.value}`)
      this.overlay.classList.remove('hidden')
      event.stopPropagation()

    } else {
      console.log('w/o event');
      console.log(this.inputfieldTarget.value);

      confirmBox.classList.add("-translate-y-full")
      this.monDonTarget.innerText = `${this.inputfieldTarget.value} €`
      this.monDonTarget.setAttribute("value", `${this.inputfieldTarget.value}`)
      this.overlay.classList.remove('hidden')
    }
  }

  hideConfirmation(event) {
    if (confirmBox.contains(event.target) || event.target === this.submitBtnTarget ) return
      console.log('hide');
      confirmBox.classList.remove("-translate-y-full")
      // document.getElementById("formDon").reset()
      this.inputfieldTarget.value = ''
      this.overlay.classList.add('hidden')
  }

  showSubmit() {

    const inputValue = parseFloat(this.inputfieldTarget.value)
    const inputMin = parseFloat(this.inputfieldTarget.min)
    this.messageTarget.innerText = `Don minimum : ${this.inputfieldTarget.min}`

    if (this.inputfieldTarget.value.trim() === '' || inputValue < inputMin) {
      console.log('nul ou inf')
      this.submitBtnTarget.setAttribute('disabled', 'true')
      this.messageTarget.classList.toggle('hidden')

    } else {
      console.log('sup')
      this.submitBtnTarget.removeAttribute('disabled')
      this.messageTarget.classList.add('hidden')
    }
  }

  onBlur() {
    console.log('blur');
    this.showSubmit()
  }

  onInput() {
    console.log('hit')
    this.showSubmit()
  }


  customValue() {
    console.log('donner hit');
    this.showConfirm()
  }

  confirmTip() {
    // Implement your confirmation logic here
    console.log('go stripe')
    // this.hideConfirmation()
    confirmBox.classList.remove("-translate-y-full")
    this.overlay.classList.add('hidden')

    this.checkout()
  }

  cancelTip() {
    // this.hideConfirmation()
    confirmBox.classList.remove("-translate-y-full")
    this.overlay.classList.add('hidden')

  }

  checkout() {
    const donationValue = this.monDonTarget.getAttribute('value')
    const donation = {
      amount: donationValue,
      place_id: this.placeIdValue
    }
    const payload = {
      authenticity_token: "",
      donation: donation
    }

    const url = `/donators/${this.donatorIdValue}/checkouts`
    const details = {
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content")
      },
      body: JSON.stringify(payload)
    }

    fetch(url, details)
    .then(response => {
      if (response.ok) {
        response.json()
        .then((data) => {
          // success logic
        })
      } else {
        response.json()
        .then((data) => {

          // failure logic
        })
      }
    })
  }
}
