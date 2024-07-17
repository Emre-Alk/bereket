import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="donation"
export default class extends Controller {
  static targets = [ 'inputfield', 'confirmBox', 'monDon']

  connect() {
    console.log('hello donation');
    const confirmBox = this.confirmBoxTarget
    this.donationForm = document.getElementById("formDon")
    this.overlay = document.getElementById('overlay')
  }

  showConfirm(event) {
    event.preventDefault()
    confirmBox.classList.toggle("-translate-y-full")
    let boxOpen = confirmBox.classList.contains("-translate-y-full")
    if (boxOpen) {
      this.inputfieldTarget.value = event.target.value
      this.monDonTarget.innerText = `${event.target.value} €`
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

  confirmTip() {
    // Implement your confirmation logic here
    console.log('go stripe')
    // this.hideConfirmation()
    confirmBox.classList.remove("-translate-y-full")
    this.overlay.classList.add('hidden')

  }

  cancelTip() {
    // this.hideConfirmation()
    confirmBox.classList.remove("-translate-y-full")
    this.overlay.classList.add('hidden')

  }
}
