import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-asso"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.handleOutsideClick = this.handleOutsideClick.bind(this);
  }

  toggle() {
    const isOpen = !this.menuTarget.classList.contains("-translate-x-full");
    this.menuTarget.classList.toggle("-translate-x-full");

    if (isOpen) {
      // Menu is open, remove the outside click listener
      document.addEventListener("click", this.handleOutsideClick);
    } else {
      // Menu is closed, add the outside click listener
      setTimeout(() => {
        document.removeEventListener("click", this.handleOutsideClick);
      }, 0);
    }
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      // Click is outside the menu, close the menu
      this.toggle();
    }
  }

}
