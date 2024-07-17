import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="donation"
export default class extends Controller {
  static targets = [ 'inputfield', 'confirmBox', 'monDon']

  connect() {
    console.log('hello donation');
    const confirmBox = this.confirmBoxTarget
    this.donationForm = document.getElementById("formDon")
  }

  showConfirm(event) {
    event.preventDefault()
    confirmBox.classList.toggle("-translate-y-full")
    let boxOpen = confirmBox.classList.contains("-translate-y-full")
    if (boxOpen) {
      this.inputfieldTarget.value = event.target.value
    } else {
      document.getElementById("formDon").reset()
    }
    event.stopPropagation()
  }

  hideConfirmation(event) {
    console.log(event.target);
    if (confirmBox.contains(event.target)) return
      confirmBox.classList.remove("-translate-y-full")
      document.getElementById("formDon").reset()

  }

  confirmTip() {
    // Implement your confirmation logic here
    console.log('go stripe')
    // this.hideConfirmation()
    confirmBox.classList.remove("-translate-y-full")

  }

  cancelTip() {
    // this.hideConfirmation()
    confirmBox.classList.remove("-translate-y-full")

  }
}
