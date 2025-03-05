import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password"
export default class extends Controller {

  static targets = ['passwordInput', 'eyeIcon', 'passwordConfirmInput']

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
