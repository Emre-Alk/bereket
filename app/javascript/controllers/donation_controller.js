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

  confirmTip() {
    // Implement your confirmation logic here

    // this.hideConfirmation()
    confirmBox.classList.remove("-translate-y-full")
    this.overlay.classList.add('hidden')

    if (this.donatorIdValue) {
      // logic when donator exists
      // continue to checkout stripe
      this.checkoutTest()
    } else {
      // logic when donator do not exists
      // you go on stripe but in the form add input fields for email and mdp
      // other attribute to create user and donator record can be completed by myself
      // Or redirect to sign_in / registration
      // Or custom form to insert in dom to fill email and mdp
      // if credential exit => log in user
      // if don't exist => create user donator
      // then, get back on track
      this.checkoutTest()

    }
  }

  checkoutTest() {
    console.log('you are being redirected to stripe payment test');
    fetch('/checkout_test', {
      headers: {
        'Accept' : 'application/json'
      }
    })
    .then(response => response.json())
    .then((data) => {
      console.log('data', data);
      if (data.url) {
        // user is sign in
        // go to stripe checkout (user needs to be signed in before landing in stripe)
        window.location.href = data.url
      } else if (data.error === 'You need to sign in or sign up before continuing.') {
        // user not logged in or not registered
        // go to authenticate by signing in or signing up (connection ou inscription)
        console.log('authentication needed');
      } else {
        console.log('error case not handled');
      }
    })
  }

  checkout() {
    // donation value is retrived. its type is string and unit is not converted to 1000s (ex: 21 or 20,5 and not 2100)
    const donationValue = this.monDonTarget.getAttribute('value')
    // defining an object to store all informations about the donation to send to backend
    const donation = {
      donator_id: this.donatorIdValue,
      place_id: this.placeIdValue,
      amount: donationValue
    }
    // defining a object 'payload' for the AJAX to works properly
    // the auth token will be filled by rails
    const payload = {
      authenticity_token: "",
      donation: donation
    }

    const url = `/checkout`
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
          // success logic : redirect the user to stripe embedded form with the url returned from checkout:session.create()
          window.location.href = data.url
        })
      } else {
        response.json()
        .then((data) => {
          // failure logic: render cancel template with msg 'smthg went wrong. ur donation couldnt be processed'
        })
      }
    })
  }
}
