import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
Chart.register(...registerables)


// Connects to data-controller="line-chart"
export default class extends Controller {
  static values = {
    revenue: Array,
    timeframe: Array
  }
  static targets = ["revenueChart"]

  connect() {
    const data = this.revenueValue.map((earning) => earning[1]/100.0)
    const labels = this.revenueValue.map((day) => day[0])

    const ctx = this.revenueChartTarget
    const config = {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          labels: 'Revenu en €',
          data: data,
          borderColor: 'rgba(0, 0, 0, 1)',
          pointBackgroundColor: 'rgba(0, 0, 0, 1)',
          pointBorderColor: 'rgba(0, 0, 0, 1)',
          borderCapStyle: 'rounded',
          borderWidth: 3,
          pointHitRadius: 1,
          pointStyle: 'circle',
          fill: false,
        }]
      },
      options: {
        plugins: {
          title: {
            display: true,
            text: 'Ce mois-ci'
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            grid: {
              display: false
            }
          },
          y: {
            beginAtZero: true,
            grid: {
              display: false,
            }
          }
        }
      }
    }
    new Chart(ctx, config)
  }
}
