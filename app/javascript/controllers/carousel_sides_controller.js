import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="carousel-sides"
export default class extends Controller {
  static targets = ["container", "indicators"]
  static classes = ["active", "inactive", "indicatorOn", "indicatorOff"]

  initialize(){
    this.active = 1
    this.items = this.containerTarget.children
    this.startX = 0
    this.indicators = this.indicatorsTarget.children
    this.delay = 3000
    this.intervalID;
  }

  connect(){
    this.load()
    this.containerTarget.addEventListener('touchstart', this.startSwipe.bind(this))
    this.containerTarget.addEventListener('touchend', this.endSwipe.bind(this))
    document.addEventListener('DOMContentLoaded', this.resetTimeout.bind(this))
  }

  disconnect() {
    this.containerTarget.removeEventListener('touchstart', this.startSwipe())
    this.containerTarget.removeEventListener('touchend', this.endSwipe())
    document.removeEventListener('DOMContentLoaded', this.resetTimeout.bind(this))

  }

  startSwipe(event){
    this.startX = event.touches[0].clientX
  }

  endSwipe(event){
    const endX = event.changedTouches[0].clientX
    const diff = endX - this.startX
    if (diff > 80) {
      this.delay = 6000
      this.prev()
    } else if (diff < -80) {
      this.delay = 6000
      this.next()
    }
  }

  resetTimeout() {
    if (this.intervalID) {
      clearInterval(this.intervalID)
    }

    this.intervalID = setInterval(() => {
      this.next()
    }, this.delay)
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
    this.resetTimeout()
    let stt = 0 // stepper

    this.items[this.active].style.transform = 'none'
    this.items[this.active].style.zIndex = this.items.length
    this.items[this.active].style.filter = "none"
    this.items[this.active].style.opacity = 1
    this.items[this.active].classList.remove(...this.inactiveClasses)
    this.items[this.active].classList.add(...this.activeClasses)
    this.items[this.active].dataset.active = 'active'
    this.indicators[this.active].classList.remove(...this.indicatorOffClasses)
    this.indicators[this.active].classList.add(...this.indicatorOnClasses)



    for (let index = this.active + 1; index < this.items.length; index++) {
      stt++
      // this.items[index].style.transform = `translateX(${208*stt}px) scale(${1 - 0.2*stt}) perspective(16px) rotateY(1deg)`
      this.items[index].style.transform = `translateX(${208*stt}px) scale(${1 - 0.2*stt}) perspective(16px)`
      this.items[index].style.zIndex = stt
      this.items[index].classList.remove(...this.activeClasses)
      this.items[index].classList.add(...this.inactiveClasses)
      this.indicators[index].classList.remove(...this.indicatorOnClasses)
      this.indicators[index].classList.add(...this.indicatorOffClasses)
      // this.items[index].style.filter = "blur(5px)"
      this.items[index].style.opacity = stt > 2 ? 0 : 0.6
      this.items[index].dataset.active = 'inactive'
    }

    stt = 0 // reset stepper

    for (let index = this.active - 1 ; index >= 0 ; index--) {
      stt++
      // this.items[index].style.transform = `translateX(${-208*stt}px) scale(${1 - 0.2*stt}) perspective(16px) rotateY(-1deg)`
      this.items[index].style.transform = `translateX(${-208*stt}px) scale(${1 - 0.2*stt}) perspective(16px)`
      this.items[index].style.zIndex = stt
      this.items[index].classList.remove(...this.activeClasses)
      this.items[index].classList.add(...this.inactiveClasses)
      this.indicators[index].classList.remove(...this.indicatorOnClasses)
      this.indicators[index].classList.add(...this.indicatorOffClasses)
      // this.items[index].style.filter = "blur(5px)"
      this.items[index].style.opacity = stt > 2 ? 0 : 0.6
      this.items[index].dataset.active = 'inactive'

    }
    this.delay = 3000
  }

}
