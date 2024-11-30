import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pdf-download"
export default class extends Controller {
  // used it with cerfa_inline view. to be deleted if cerfa_inline view is deleted
  download() {
    const url = this.data.get('url'); // PDF URL from data attribute
    const filename = this.data.get('filename'); // Optional filename
    this.downloadFile(url, filename);
  }

  downloadFile(url, filename) {
    fetch(url)
      .then(response => response.blob())
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
      .catch(error => {
        console.error('Error downloading the file:', error);
      });
  }
}
