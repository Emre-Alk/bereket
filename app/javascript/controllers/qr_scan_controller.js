import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="qr-scan"
export default class extends Controller {
  static targets = [ "scanBox", "scanBtn" ]

  fetchPlaceDonationNew(path, qrText) {
    const details = {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-TOKEN': document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content"),
      }
    }
    fetch(path, details)
    .then(response => {
      if (response.ok) {
        response.json()
        .then((data) => {
          console.log(data.message)
          window.location.href = data.url
        })
      } else {
        console.log('resource does not exists')
        alert("Qr code non valide ou la page n'existe plus") // this might not work once go PWA
        // change by a partial from server or insert div for error
        // or insert div
        // const errorDiv = document.createElement('div')
        // errorDiv.innerText = `QR code non valide ou la page n'existe plus. QR code: ${qrText}`
        // or import gem sweetalert
      }
    })
  }

  scan() {
    this.qrReader = new Html5Qrcode("scanBox")
    const camera = { facingMode: "user" } // choose a camera by applying a constrain (other value 'user' for front)
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
      // start ajax
      let newUrl
      if (decodedText.startsWith('http:')) {
        const urlChunked = decodedText.split('http://192.168.1.168:3000/') // these lines are to be changed once domain name available
        newUrl = `http://localhost:3000/${urlChunked[1]}` // these lines are to be changed once domain name available
      }
      else {
        newUrl = decodedText // in production
      }
      this.fetchPlaceDonationNew(newUrl, decodedText)
      // end ajax
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
    const scanWindow = document.getElementById("bbox")
    if (!scanWindow.classList.contains('hidden')) {
      scanWindow.classList.remove('inset-0')
      scanWindow.classList.add('hidden')
      this.qrReader.stop() // stop scanning
    } else {
      scanWindow.classList.remove('hidden')
      scanWindow.classList.add('inset-0')
      this.scan()
       // how to lauch animation as same time as start() promise succeeds ? ( start().then( this.toggleScanWindow() ) don't do it )
    }
  }

  disconnect() {
    // this.qrReader.stop().catch(console.error)
  }
}
