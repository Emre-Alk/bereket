import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="volunteering"
export default class extends Controller {
  static targets = [
    'filter',
    'modal',
    'deleteBtn',
    'pauseBtn',
    'pauseText',
    'deleteText',
    'title'
  ]

  openActions({params}) {
    fetch(params.urlAction)
    .then(response => response.text())
    .then((data) => {
      this.modalTarget.innerHTML = data
      this.toggleModal()
    })
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

  setTitle(e){
    this.titleTarget.innerText = `${e.params.place.name}`
  }

  setAction(event){
    event.preventDefault()
    const status = event.params.payload.status

    switch (status) {
      case 'pending':
        this.pauseBtnTarget.classList.add('hidden')
        this.deleteTextTarget.innerText = 'Annuler la candidature'
        break;
      case 'paused':
        this.pauseBtnTarget.classList.remove('hidden')
        this.pauseTextTarget.innerText = 'Ré-activer'
        this.deleteTextTarget.innerText = 'Supprimer ce bénévolat'
        break;
      case 'active':
        this.pauseBtnTarget.classList.remove('hidden')
        this.pauseTextTarget.innerText = 'Mettre en pause'
        this.deleteTextTarget.innerText = 'Supprimer ce bénévolat'
        break;
      default:
        break;
    }

    this.deleteBtnTarget.href = event.params.urlDelete
    this.pauseBtnTarget.href = event.params.urlPause
    this.pauseBtnTarget.id = `card-${event.params.payload.id}`

    this.setTitle(event)

    this.toggleModal()
  }

  pause(event) {
    const card = document.getElementById(event.currentTarget.id)
    card.classList.toggle('grayscale')
  }

}
