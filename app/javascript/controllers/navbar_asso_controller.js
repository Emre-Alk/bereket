import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-asso"
export default class extends Controller {
  static targets = ["menu"]

  connect(){
    // 'this' represents the context. it can be thinked as similar to 'self'(ruby)
    // check this below from MDN:
    // const test = {
    //   prop: 42,
    //   func: function () {
    //     return this.prop;
    //   },
    // };
    // console.log(test.func());
    // Expected output: 42. This goes back to 'test'. It says go take the 'prop' value from 'test' (self) and not from elsewhere

    // here as require that "this" of touched should refers to 'this' of here (connect).
    // 'this' of 'connect' refers to everything in the controller where am i (ie, in the context of this controller namely, everything inside of it)=> data-controller="navbar-asso"
    // because 'connect' is define in the scope of the controller. connect exits when controller exists in the DOM
    // ex. 'this.element' will give the html of the controller: <div> data-controller="navbar-asso" </div>
    // ex. 'this.

    this.touched = this.touched.bind(this)
  }

  toggle() {
    this.menuTarget.classList.toggle("-translate-x-full")
    let navOpen = this.menuTarget.classList.contains("-translate-x-full")
    if (navOpen) {
      const nav = this.menuTarget
      // touch events
      document.addEventListener('touchstart', this.touched)
      this.element.addEventListener('touchstart', this.noPageScrollOnNav)

      //mouse events
      document.addEventListener('click', this.touched)
    } else {
      // touch events
      document.removeEventListener('touchstart', this.touched)
      this.element.removeEventListener('touchstart', this.noPageScrollOnNav)

      // mouse events
      document.removeEventListener('click', this.touched)
    }
  }

  noPageScrollOnNav(event) {
    event.preventDefault()
  }

  touched(event) {
    const touchOut = !this.element.contains(event.target)
    if (touchOut) {
      this.toggle()
      this.element.removeEventListener('touchstart', (e) => e.preventDefault())
    }
  }
}
