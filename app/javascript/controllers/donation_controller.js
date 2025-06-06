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
    this.overlay = document.getElementById('overlay')
    this.submitInput = this.submitInput.bind(this) // this set 'this' in submitinput action equal to 'this' of the controller
  }

  showConfirm(event) {
    // action used to toggle the confirmation box either if:
    // user hit a quick button (event exist), or
    // user type a custom value into the input field (event don't exist => 'else' scenario)

    if (event) {
      console.log('w/ event');
      event.preventDefault()

      confirmBox.classList.add("-translate-y-full")
      this.inputfieldTarget.value = event.target.value
      this.monDonTargets[1].innerText = `${event.target.value} €`
      console.log('if plural 1', this.monDonTargets[1])
      this.monDonTarget.setAttribute("value", `${event.target.value}`)
      console.log('if singular', this.monDonTarget);
      this.overlay.classList.remove('hidden')
      event.stopPropagation()

    } else {
      console.log('w/o event');
      console.log(this.inputfieldTarget.value);

      confirmBox.classList.add("-translate-y-full")
      this.monDonTargets[1].innerText = `${this.inputfieldTarget.value} €`
      console.log('else plural 1', this.monDonTargets[1])
      this.monDonTarget.setAttribute("value", `${this.inputfieldTarget.value}`)
      console.log('else singular', this.monDonTarget);
      this.overlay.classList.remove('hidden')
    }


    // parse to float a string representing the amount given as donation
    const amount = parseFloat(this.monDonTarget.value)
    // apply the discount (ToDo: in auto)
    const amountDiscount = amount * 0.66
    // deduce the net amount
    const amountNet = amount - amountDiscount

    // convert number to currency using 'Intl.NumberFormat' but require a number in 'format'
    // toFixed to rounded at x decimal, and result is type string. then back to parseFloat to get a number
    const discountCurrency = new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(parseFloat(amountDiscount.toFixed(2)))
    const netCurrency = new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(parseFloat(amountNet.toFixed(2)))

    // retrieve the donation breakdown elements
    const discount = document.getElementById('discount')
    const net = document.getElementById('net')

    // insert results at places
    discount.innerText = `-${discountCurrency}`
    net.innerText = netCurrency

  }

  hideConfirmation(event) {
    // this is an endpoint of a user flow so many hidden and disabled stuff must be recalled here
    // in order to get back to the starting point (complete circle)
    // check if event target (user touch) happened on the confirmation box or was from actuation of submit btn or from focus on input field
    // if either one is true, then exists but do nothing (thanks to return)

    if (confirmBox.contains(event.target) || event.target === this.submitBtnTarget || event.target === this.inputfieldTarget) return
    // if one true (user hit on empty spaces on page), then execute these lines
      console.log('hide');
      confirmBox.classList.remove("-translate-y-full")
      this.inputfieldTarget.value = ''
      this.submitBtnTarget.setAttribute('disabled', 'true')
      this.overlay.classList.add('hidden')
      this.messageTarget.classList.add('hidden')
  }

  showSubmit() {
    // this is specific to the scenario, user type a custom value in the input field
    // input value is retrieve and transformed to number type. same for its 'min' attribute
    const inputValue = parseFloat(this.inputfieldTarget.value)
    const inputMin = parseFloat(this.inputfieldTarget.min)
    // initialize a text to display when relevant
    this.messageTarget.innerText = `Don minimum : ${this.inputfieldTarget.min} €`
    // check if field empty or typed value is less than min value
    if (this.inputfieldTarget.value.trim() === '' || inputValue < inputMin) {
      // case either one is true, submit is not possible
      // Therefore, message must be displayed whatever the execution flow

      console.log('nul ou inf')
      this.submitBtnTarget.setAttribute('disabled', 'true')
      this.messageTarget.classList.remove('hidden')

    } else {
      // case can only be greater
      // submit is possible
      // Therefore, message must be hidden whatever the execution flow
      console.log('sup')
      this.submitBtnTarget.removeAttribute('disabled')
      this.messageTarget.classList.add('hidden')
    }
  }

  onBlur() {
    // action blur (ie, when input field loose focus)
    // get actuated each time user deselecte the input field
    // this is to get back to starting point
    // console.log('blur')
    this.showSubmit()
  }

  onInput() {
    // event specific to the input field type
    // get actuated each time the user type in
    // console.log('hit')
    this.showSubmit()
  }


  submitInput() {
    // once submit possible, the user hit it to send custome value of the input field
    // then, it must follow the usual flow (ie, same flow as quick buttons)
    console.log('donner hit');
    this.showConfirm()
  }

  cancelTip() {
    // if user hit cancel on confirm page
    // this is an endpoint of a user flow so many hidden and disabled stuff must be recalled here
    // in order to get back to the starting point (complete circle)
    confirmBox.classList.remove("-translate-y-full")
    this.submitBtnTarget.setAttribute('disabled', 'true')
    this.inputfieldTarget.value = ''
    this.overlay.classList.add('hidden')
    this.messageTarget.classList.add('hidden')

  }

}
