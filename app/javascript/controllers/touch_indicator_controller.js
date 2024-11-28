import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="touch-indicator"
export default class extends Controller {
  connect() {
    this.handleTouch = this.handleTouch.bind(this); // Bind this for event listeners

    // Add touch event listeners
    document.addEventListener("touchstart", this.handleTouch);
    // document.addEventListener("touchmove", this.handleTouch);
  }

  disconnect() {
    // Remove touch event listeners
    document.removeEventListener("touchstart", this.handleTouch);
    // document.removeEventListener("touchmove", this.handleTouch);
  }

  handleTouch(event) {
    for (let touch of event.touches) {
      this.createTouchIndicator(touch.clientX, touch.clientY);
    }
  }

  createTouchIndicator(x, y) {
    const circle = document.createElement("div");
    circle.style.position = "absolute";
    circle.style.left = `${x - 15}px`; // Center the circle
    circle.style.top = `${y - 15}px`;  // Center the circle
    circle.style.width = "30px";
    circle.style.height = "30px";
    circle.style.backgroundColor = "rgba(255, 0, 0, 0.5)"; // Semi-transparent red
    circle.style.borderRadius = "50%";
    circle.style.pointerEvents = "none"; // Don't block interactions
    circle.style.zIndex = 9999;
    document.body.appendChild(circle);

    // Remove the circle after animation
    setTimeout(() => circle.remove(), 500);
  }
}
