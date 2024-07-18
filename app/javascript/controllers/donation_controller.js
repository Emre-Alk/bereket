import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="donation"
export default class extends Controller {
  static targets = [ 'inputfield', 'confirmBox', 'monDon', 'submit']
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
      event.preventDefault()
      confirmBox.classList.add("-translate-y-full")
      this.inputfieldTarget.value = event.target.value
      this.monDonTarget.innerText = `${event.target.value} €`
      this.monDonTarget.setAttribute("value", `${event.target.value}`)
      this.overlay.classList.remove('hidden')
      event.stopPropagation()

    } else {
      confirmBox.classList.add("-translate-y-full")
      this.monDonTarget.innerText = `${this.inputfieldTarget.value} €`
      this.monDonTarget.setAttribute("value", `${this.inputfieldTarget.value}`)
      this.overlay.classList.remove('hidden')
    }
  }

  hideConfirmation(event) {
    if (confirmBox.contains(event.target) || event.target === this.submitTarget ) return
      console.log('hide');
      confirmBox.classList.remove("-translate-y-full")
      // document.getElementById("formDon").reset()
      this.inputfieldTarget.value = ''
      this.overlay.classList.add('hidden')
  }

  showSubmit() {
    this.submitTarget.removeAttribute('disabled', '')
  }

  customValue() {
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
