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
      qrbox: { width: 150, height: 150 } // scanning box size
    }
    const qrCodeSuccessCallback = (decodedText, decodedResult) => {
      /* handle success */
      // TODO: redirect to url of qrcode
      console.log('decodedText', decodedText);
      console.log('decodedResult', decodedResult);
      this.qrReader.stop() // stop scanning
      this.toggleScanWindow() // close scan window
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
  }


  toggleScanBtn() {
    this.scanBtnTarget.classList.toggle('hidden')
  }

  toggleScanWindow() {
    console.log('open window now')
    // toggle scan btn
    this.toggleScanBtn()
    const parentBox = document.getElementById("bbox")
    if (!parentBox.classList.contains('hidden')) {
      parentBox.classList.remove('inset-0')
      parentBox.classList.add('hidden')
      this.qrReader.stop() // stop scanning
    } else {
      parentBox.classList.remove('hidden')
      parentBox.classList.add('inset-0')
      this.scan()
       // how to lauch animation as same time as start() promise succeeds ? ( start().then( this.toggleScanWindow() ) don't do it )
    }
  }

  disconnect() {
    this.qrReader.stop().catch(console.error)
  }
}
