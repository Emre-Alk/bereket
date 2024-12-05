import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="landing"
export default class extends Controller {
  static targets = ['demoAsso', 'demoDonator', 'btnAsso', 'btnDonator']
  static classes = ['switch']

  display(event) {
    const AssoBtn = event.params.name === 'asso'
    const DonatorBtn = event.params.name === 'donator'
    const notSelected = !event.currentTarget.classList.contains(...this.switchClasses)
    if (notSelected) {
      switch (event.params.name) {
        case 'asso':
          this.btnAssoTarget.classList.add(...this.switchClasses)
          this.demoAssoTarget.classList.toggle('hidden')
          this.btnDonatorTarget.classList.remove(...this.switchClasses)
          this.demoDonatorTarget.classList.toggle('hidden')
          break;
        case 'donator':
          // const frame = document.getElementById('frame')
          // console.log(frame);
          // const autoplay = '&player[autoplay]=true&player[muted]=true&player[loop]=true'

          // let src = frame.src
          // const wordCutter = '[start_offset]=0'
          // const word = src.split(wordCutter)
          // console.log(word);

          // const wordStart = word[0]
          // const wordEnd = word[1]
          // const newSrcPlay = wordStart.concat(wordCutter).concat(autoplay).concat(wordEnd)

          // src = newSrcPlay

          // console.log('src', src);


          this.btnDonatorTarget.classList.add(...this.switchClasses)
          this.demoDonatorTarget.classList.toggle('hidden')
          this.btnAssoTarget.classList.remove(...this.switchClasses)
          this.demoAssoTarget.classList.toggle('hidden')
          break;
        default:
          this.btnAssoTarget.classList.add(...this.switchClasses)
          this.btnDonatorTarget.classList.remove(...this.switchClasses)
          this.demoDonatorTarget.classList.add('hidden')
          break;
      }
    }
  }
}
