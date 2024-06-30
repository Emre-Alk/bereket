import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
Chart.register(...registerables)


// Connects to data-controller="line-chart"
export default class extends Controller {
  static values = {
    revenue: Array,
    timeframe: Array
  }

  connect() {

  // creer le graph ici

  }
}
