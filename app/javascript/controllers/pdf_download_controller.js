import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pdf-download"
export default class extends Controller {
  // used it with cerfa_inline view. to be deleted if cerfa_inline view is deleted
  download(event) {
    event.preventDefault()
    const url = this.data.get('url'); // PDF URL from data attribute
    const filename = this.data.get('filename'); // Optional filename
    const token = this.data.get('token')
    this.downloadFile(url, filename, token)
    // this.downloadFile(url, filename)
  }

  downloadFile(url, filename, token) {

    const details = {
      method: 'get',
      headers: {
        "Accept": "application/json",
      }
    }

    fetch(`${url}?token=${token}`, details)
    // fetch(url)
    .then(response => {
      if (response.ok) {
        return response.blob()
      }
      return Promise.reject(response)
    })
    .then(blob => {
      const a = document.createElement('a');
      const objectUrl = URL.createObjectURL(blob);
      a.href = objectUrl;
      a.download = filename || 'file.pdf';
      document.body.appendChild(a); // Required for some mobile browsers
      a.click();
      document.body.removeChild(a); // Clean up
      URL.revokeObjectURL(objectUrl); // Release memory
    })
    .catch((response) => {
      response.json().then((errors) => {
        console.log('errors', errors)
      })
    })
  }
}
