import { Controller } from "@hotwired/stimulus"
import SignaturePad from "signature_pad"

// Connects to data-controller="signature"
export default class extends Controller {
  static targets = ["canvas", "signatureData", "submitBtn"]

  connect() {
    console.log('hello signature');
    this.signaturePad = new SignaturePad(this.canvasTarget)

    // at page load (t0), resize to handle DPI screens (otherwise pen is shifted)
    this.resizeCanvas()
    // add event listener for any resize of the screen from user that could occur later
    window.addEventListener("resize", this.resizeCanvas.bind(this))
  }

  disconnect() {
    window.removeEventListener("resize", this.resizeCanvas.bind(this));
  }

  resizeCanvas() {
    // action to handle mobile orientation change
    // save signature before the resize
    // draw signature after resize
    if (this.signaturePad.isEmpty()) {
      this.resizeSafely()
    } else {
      const dataURL = this.signaturePad.toDataURL()
      this.resizeSafely()
      this.signaturePad.fromDataURL(dataURL)
    }
  }

  resizeSafely() {
    // This is usualy 1 for low DPI and 2 for high DPI screens (or retina)
    const ratio = Math.max(window.devicePixelRatio || 1, 1)

    // Use the container's width to maintain aspect ratio
    const containerWidth = this.canvasTarget.parentElement.offsetWidth

    // Set a desired aspect ratio, e.g., 3:1 (width:height)
    // check mobile orientation to set ratio. large if portrait small if landscape
    let aspectRatio = 2
    if (screen.orientation.type === 'landscape-primary') {
      aspectRatio = 4
    }

    console.log(aspectRatio);
    this.canvasTarget.width = containerWidth * ratio
    this.canvasTarget.height = (containerWidth / aspectRatio) * ratio

    this.canvasTarget.style.width = `${containerWidth}px` // width to 100% of parent container
    this.canvasTarget.style.height = `${containerWidth / aspectRatio}px`

    // Scale the context to account for high-DPI displays
    this.canvasTarget.getContext('2d').scale(ratio, ratio)
    // this.signaturePad.clear() // to avoid isempty return value to be incorrect (see repo). still necessary ?

  }

  clear(event) {
    console.log('clear action');
    event.preventDefault()
    this.signaturePad.clear()
  }

  save(event) {
    console.log('save action');
    if (this.signaturePad.isEmpty()) {
      event.preventDefault()
      alert("Merci d'aposer votre signature. Puis enregister à nouveau.")
    } else {
      const dataURL = this.signaturePad.toDataURL()
      this.signatureDataTarget.value = dataURL
      console.log('data url', dataURL)
      console.log('submited value', this.signatureDataTarget.value)
    }
  }
}
