import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="qr-scan"
export default class extends Controller {
  static targets = [ "scanBox", "scanBtn" ]

  connect() {
    console.log("hello scan")
    this.qrReader = new Html5Qrcode("scanBox")
  }

  scan() {
    const camera = { facingMode: "user" } // choose a camera by applying a constrain
    const config = {
      fps: 10, // frames per second
      qrbox: { width: 250, height: 250 } // scanning box size
    }
    const qrCodeSuccessCallback = (decodedText, decodedResult) => {
      /* handle success */
      // TODO: redirect to url of qrcode
      console.log('decodedText', decodedText);
      console.log('decodedResult', decodedResult);
      this.qrReader.stop()

      this.openScanWindow()
    }

    // start scanning..
    this.qrReader.start(
      camera,
      config,
      qrCodeSuccessCallback
    ).catch((err) => {
      console.log(`error: ${err}`)
      // TODO: insert div with err displayed
      // with 'back' btn enabled
    })
    this.openScanWindow() // how to lauch animation as same time as start() promise succeeds ? ( start().then( this.openScanWindow() ) don't do it )
  }


  toggleScanBtn() {
    this.scanBtnTarget.classList.toggle('hidden')
  }

  openScanWindow() {
    console.log('open window now')
    // hide scan btn
    this.toggleScanBtn()
    const parentBox = document.getElementById("bbox")
    if (parentBox.classList.contains('inset-y-0')) {
      parentBox.classList.remove('inset-y-0', 'inset-x-0','bg-blue-300')
    } else {
      parentBox.classList.add('inset-y-0', 'inset-x-0','bg-blue-300')
    }
  }

  disconnect() {
    this.qrReader.stop().catch(console.error)
  }
}
