import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="carousel-sides"
export default class extends Controller {
  static targets = ["container", "items"]
  static classes = ["active", "inactive"]

  initialize(){
    this.active = 1
    this.items = this.containerTarget.children
    this.startX = 0

  }

  connect(){
    this.load()
    this.containerTarget.addEventListener('touchstart', this.startSwipe.bind(this))
    this.containerTarget.addEventListener('touchend', this.endSwipe.bind(this))
  }

  startSwipe(event){
    this.startX = event.touches[0].clientX
  }

  endSwipe(event){
    const endX = event.changedTouches[0].clientX
    const diff = endX - this.startX
    if (diff > 80) {
      this.prev()
    } else if (diff < -80) {
      this.next()
    }
  }

  prev(){
    this.active = this.active - 1 >= 0 ? this.active - 1 : this.items.length - 1
    this.load()
  }

  next(){
    this.active = this.active + 1 < this.items.length ? this.active + 1 : 0
    this.load()
  }

  load(){
    let stt = 0 // stepper

    this.items[this.active].style.transform = 'none'
    this.items[this.active].style.zIndex = 1
    this.items[this.active].style.filter = "none"
    this.items[this.active].style.opacity = 1
    this.items[this.active].classList.remove(...this.inactiveClasses)
    this.items[this.active].classList.add(...this.activeClasses)
    this.items[this.active].dataset.active = 'active'



    for (let index = this.active + 1; index < this.items.length; index++) {
      stt++
      // this.items[index].style.transform = `translateX(${208*stt}px) scale(${1 - 0.2*stt}) perspective(16px) rotateY(1deg)`
      this.items[index].style.transform = `translateX(${208*stt}px) scale(${1 - 0.2*stt}) perspective(16px)`
      this.items[index].style.zIndex = -stt
      this.items[index].classList.add(...this.inactiveClasses)
      // this.items[index].style.filter = "blur(5px)"
      this.items[index].style.opacity = stt > 2 ? 0 : 0.6
      this.items[index].dataset.active = 'inactive'

    }

    stt = 0 // reset stepper

    for (let index = this.active - 1 ; index >= 0 ; index--) {
      stt++
      // this.items[index].style.transform = `translateX(${-208*stt}px) scale(${1 - 0.2*stt}) perspective(16px) rotateY(-1deg)`
      this.items[index].style.transform = `translateX(${-208*stt}px) scale(${1 - 0.2*stt}) perspective(16px)`
      this.items[index].style.zIndex = -stt
      this.items[index].classList.add(...this.inactiveClasses)
      // this.items[index].style.filter = "blur(5px)"
      this.items[index].style.opacity = stt > 2 ? 0 : 0.6
      this.items[index].dataset.active = 'inactive'

    }
  }

}
