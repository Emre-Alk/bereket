import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="share"
export default class extends Controller {
  connect() {
  }

  share({params}) {
    if (navigator.share) {
      navigator.share({
        title: `👉🏻 ${params.payload.place}`,
        text: '🙏🏻 Vous pouvez nous faire un don via ce lien',
        url: `${params.payload.url}`
      })
      .then(() => console.log('Content shared successfully!'))
      .catch((error) => console.error('Error sharing content:', error));
    } else {
      alert('Web Share API is not supported in your browser.');
    }
  }
}
