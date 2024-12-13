import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel-cards"
export default class extends Controller {
  static targets = ["container"];

  initialize() {
    this.currentIndex = 0; // Active card index
    this.startX = 0; // Starting X-coordinate for touch
    this.isSwiping = false;
  }

  connect() {
    this.updateCarousel(); // Position the first card at start
    this.containerTarget.addEventListener("touchstart", this.startSwipe.bind(this));
    this.containerTarget.addEventListener("touchmove", this.trackSwipe.bind(this));
    this.containerTarget.addEventListener("touchend", this.endSwipe.bind(this));
  }

  disconnect() {
    this.containerTarget.removeEventListener("touchstart", this.startSwipe);
    this.containerTarget.removeEventListener("touchmove", this.trackSwipe);
    this.containerTarget.removeEventListener("touchend", this.endSwipe);
  }

  // Button navigation
  previous() {
    if (this.currentIndex > 0) {
      this.currentIndex--;
    } else {
      this.currentIndex = this.totalCards - 1; // Loop to last card
    }
    this.updateCarousel();
  }

  next() {
    if (this.currentIndex < this.totalCards - 1) {
      this.currentIndex++;
    } else {
      this.currentIndex = 0; // Loop to first card
    }
    this.updateCarousel();
  }

  // Swipe logic
  startSwipe(event) {
    this.startX = event.touches[0].clientX;
    this.isSwiping = true;
  }

  trackSwipe(event) {
    if (!this.isSwiping) return;
    const currentX = event.touches[0].clientX;
    const diffX = this.startX - currentX;

    // Optional: Add real-time drag effect (commented out for smoothness)
    // this.containerTarget.style.transform = `translateX(${-this.currentIndex * this.containerWidth - diffX}px)`;
  }

  endSwipe(event) {
    if (!this.isSwiping) return;
    const endX = event.changedTouches[0].clientX;
    const diffX = this.startX - endX;

    if (diffX > 50) {
      this.next(); // Swipe left
    } else if (diffX < -50) {
      this.previous(); // Swipe right
    }

    this.isSwiping = false;
  }

  updateCarousel() {
    const cardWidth = this.containerTarget.children[0].offsetWidth; // Width of a single card
    const gap = 16; // Match the gap in `gap-4`
    const offset =
      (this.currentIndex * (cardWidth + gap)) - // Center the active card
      (this.element.offsetWidth / 2 - cardWidth / 2); // Adjust for partial visibility

    this.containerTarget.style.transform = `translateX(-${offset}px)`;
  }

  get totalCards() {
    return this.containerTarget.children.length;
  }


}
