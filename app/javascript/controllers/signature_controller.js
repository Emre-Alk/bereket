import { Controller } from "@hotwired/stimulus"
import SignaturePad from "signature_pad"

// Connects to data-controller="signature"
export default class extends Controller {
  static targets = ["signaturePad", "signatureData"]

  connect() {
    console.log('hello signature');
    // const canvas = document.getElementById("signature-pad")
    // const signature = new SignaturePad(canvas)
    // console.log(signature);

    // const clearBtn = document.getElementById("clear-signature")
    // clearBtn.addEventListener(click, (e) => {
    //   e.preventDefault()
    //   signature.clear()
    // })

    // const saveBtn = document.getElementById("save-signature")
    // saveBtn.addEventListener(click, (e) => {
    //   e.preventDefault()
    //   if (signature.isEmpty()) {
    //     alert("Please provide a signature first.")
    //   } else {
    //     const dataURL = signature.toDataURL()
    //     this.signatureDataTarget.value = dataURL
    //   }
    // })

    if (this.signaturePadTarget) {
      const canvas = this.signaturePadTarget
      // canvas.height = canvas.offsetHeight
      // canvas.width = canvas.offsetWidth
      window.onresize = this.resizeCanvas(canvas)
      // this.resizeCanvas(canvas)
      this.signaturePad = new SignaturePad(canvas)
      this.signaturePad.clear()
    }
  }

  resizeCanvas(canvas) {
    const ratio =  Math.max(window.devicePixelRatio || 1, 1)
    console.log(window.devicePixelRatio);
    console.log('ratio', ratio);
    canvas.width = canvas.offsetWidth * ratio
    canvas.height = canvas.offsetHeight * ratio
    canvas.getContext("2d").scale(ratio, ratio)
    // this.signaturePad.clear() // otherwise isEmpty() might return incorrect value
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
      console.log(dataURL);
      console.log(this.signatureDataTarget.value);
    }
  }
}
