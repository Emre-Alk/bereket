import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password"
export default class extends Controller {

  static targets = ['passwordInput', 'eyeIcon', 'passwordConfirmInput', 'input', 'submit']

  connect() {
    this.checkFields() // at connexion, check fields if filled out directly (eg. autofill)
  }

  checkFields() {
    let allFilled = true

    // iterate over each inputs and if only one is not filled, then it passes variable from default true to false
    this.inputTargets.forEach((input) => {
      if (!this.isFieldValid(input)) {
        allFilled = false
      }
    })

    this.submitTarget.disabled = !allFilled // will set value of disabled to false or true
  }

  isFieldValid(input) {
    if (input.type === "checkbox" || input.type === "radio") {
      return input.checked // Ensure at least one option is selected
    } else if (input.type === 'password') {
      return input.value.trim().length >= 6
    }
    return input.value.trim() !== ""
  }

  togglePassword(event) {
    if (!event) {
      this.passwordInputTarget.type = 'password'
      this.eyeIconTarget.classList.remove('fa-eye')
      this.eyeIconTarget.classList.add('fa-eye-slash')

    } else {

      if (this.passwordInputTarget.type === 'password') {
        this.passwordInputTarget.type = 'text'
        this.eyeIconTarget.classList.remove('fa-eye-slash')
        this.eyeIconTarget.classList.add('fa-eye')
      } else {
        this.passwordInputTarget.type = 'password'
        this.eyeIconTarget.classList.remove('fa-eye')
        this.eyeIconTarget.classList.add('fa-eye-slash')
      }

    }
  }

  confirm(event) {

    // paste pw value to confirm field
    this.passwordConfirmInputTarget.value = this.passwordInputTarget.value

    // before submit, make sure that password field is type password
    this.togglePassword()

    // submit form
    // event.target.submit()
  }
}
