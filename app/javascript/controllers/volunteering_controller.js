import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="volunteering"
export default class extends Controller {
  static targets = ['filter', 'modal', 'deleteBtn']

  connect() {
    // console.log(this.deleteBtnTarget)
    // console.log(this.modalTarget)
    console.log(this.deleteBtnTarget)

  }

  toggleModal() {
    const isOpen = this.modalTarget.classList.contains('-translate-y-full')
    this.filterTarget.classList.toggle('-z-10')
    if (isOpen) {
      this.modalTarget.classList.remove('-translate-y-full')
    } else {
      this.modalTarget.classList.add('-translate-y-full')
    }
  }

  setAction(event){
    event.preventDefault()
    this.deleteBtnTarget.href = event.params.url
    this.toggleModal()
    // actions are: delete, change status to 'inactive/paused',
    // target delete button to set the path with the selected Volunteering record
    // this.deleteBtnTarget.href
  }

}
