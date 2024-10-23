import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
export default class extends Controller {
  static targets = ['total', 'net', 'reduction']

  toggle(event) {

    const totalBtn = document.getElementById('total')
    const netBtn = document.getElementById('net')
    const reductionBtn = document.getElementById('reduction')

    const btns = [totalBtn, netBtn, reductionBtn]
    const prompts = [this.totalTarget, this.netTarget, this.reductionTarget]

    const isActive = event.target.classList.contains('active')

    if (!isActive) {

      btns.forEach((btn) => {
        if (btn.classList.contains('active')) {
          btn.classList.remove('active')
          btn.classList.remove('bg-black', 'text-white')
          btn.classList.add('bg-neutral-300', 'text-black')

          const indexOld = btns.indexOf(btn)
          prompts[indexOld].classList.toggle('hidden')
          prompts[indexOld].classList.toggle('flex')
        }
      })

      event.target.classList.add('active')
      event.target.classList.remove('bg-neutral-300', 'text-black')
      event.target.classList.add('bg-black', 'text-white')

      const indexNew = btns.indexOf(event.target)
      prompts[indexNew].classList.toggle('hidden')
      prompts[indexNew].classList.toggle('flex')

    }
  }

}
