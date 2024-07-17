import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="donation"
export default class extends Controller {
  static targets = [ 'inputfield', 'confirmBox', 'monDon', 'inputfield2']
  static values = {
    donatorId: String,
    placeId: String
  }
  connect() {
    console.log('hello donation');
    const confirmBox = this.confirmBoxTarget
    this.donationForm = document.getElementById("formDon")
    this.overlay = document.getElementById('overlay')
    this.customValue = this.customValue.bind(this)
  }

  showConfirm(event) {
      event.preventDefault()
      confirmBox.classList.toggle("-translate-y-full")
      let boxOpen = confirmBox.classList.contains("-translate-y-full")
      if (boxOpen) {
        this.inputfieldTarget.value = event.target.value
        this.monDonTarget.innerText = `${event.target.value} €`
        this.monDonTarget.setAttribute("value", `${event.target.value}`)
        this.overlay.classList.remove('hidden')
      } else {
        document.getElementById("formDon").reset()
        this.overlay.classList.add('hidden')
      }
      event.stopPropagation()

  }

  hideConfirmation(event) {
    if (confirmBox.contains(event.target)) return
      confirmBox.classList.remove("-translate-y-full")
      document.getElementById("formDon").reset()
      this.overlay.classList.add('hidden')
  }

  customValue(event) {
    // event.preventDefault()

    // i cant get the input field value whatever my approach
    // next thing to try is ask GPT or ajax the form to backend def custom and render the field value back as response
    // const form = new FormData(this.donationForm)
    // // for (const [key, value] of form) {
    // //   console.log(key, value);
    // // }
    // console.log(form.getAll('value'));

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
