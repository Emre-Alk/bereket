import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-button"
export default class extends Controller {
  static targets = ['button', 'input']

  connect() {
    const tos = document.getElementById('tos')
    const sirenHave = document.getElementById('siren_have')
    const sirenNone = document.getElementById('siren_none')

    tos.addEventListener('click', this.checked)
    sirenHave.addEventListener('click', this.checked)
    sirenNone.addEventListener('click', this.checked)
  }

  disconnect() {
    const tos = document.getElementById('tos')
    const sirenHave = document.getElementById('siren_have')
    const sirenNone = document.getElementById('siren_none')

    tos.removeEventListener('click', this.checked)
    sirenHave.removeEventListener('click', this.checked)
    sirenNone.removeEventListener('click', this.checked)
  }

  checked() {
    const tosIsChecked = document.getElementById('tos').checked
    const sirenNoneIsChecked = document.getElementById('siren_none').checked
    const sirenHaveIsChecked = document.getElementById('siren_have').checked
    const submitBtn = document.getElementById('submitBtn')
    const isDisabled = submitBtn.hasAttribute('disabled')

    if ((tosIsChecked && sirenHaveIsChecked) || (tosIsChecked && sirenNoneIsChecked)) {
      submitBtn.removeAttribute('disabled')
    } else {
      submitBtn.setAttribute('disabled', '')
    }
  }

  toggleRequire() {
    const sirenHaveIsChecked = document.getElementById('siren_have').checked
    if (sirenHaveIsChecked) {
      this.inputTarget.setAttribute("required", "")
    } else {
      this.inputTarget.removeAttribute("required")
    }
  }
}
