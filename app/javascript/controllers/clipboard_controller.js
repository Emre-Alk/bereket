import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets =['source']
  // source is the target whome value is to be copied

  copy(event) {
    // in case the source is inside a link anchor and don't want browser to redirect on click
    event.preventDefault()
    // copy the source value in the clipboard
    if (this.sourceTarget.value) {
      navigator.clipboard.writeText(this.sourceTarget.value)
    } else {
      navigator.clipboard.writeText(this.sourceTarget.innerText)
    }

    const iconCopied = document.createElement('div')
    iconCopied.classList.add('absolute', 'right-2', 'px-2', 'py-1', 'bg-gray-600', 'opacity-50', 'rounded-lg', 'text-white', 'text-sm')
    iconCopied.innerHTML = ` Copié <i class="fa-solid fa-check" style="color: #11de0f;"></i>`

    this.sourceTarget.classList.add('relative')
    this.sourceTarget.append(iconCopied)

    setTimeout(() => {
      iconCopied.remove()
    }, 1000)
  }

  displayCopy(){
    this.sourceTarget.innerHTML = `${this.sourceTarget.value} <i class="fa-solid fa-headset fa-xl"></i>`
  }
}
