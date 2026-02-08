import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (!window.Chart) return

    const signupLabels = this.parseJSON(this.element.dataset.adminChartsSignupLabels)
    const signupSeries = this.parseJSON(this.element.dataset.adminChartsSignupSeries)
    const categoryLabels = this.parseJSON(this.element.dataset.adminChartsCategoryLabels)
    const categorySeries = this.parseJSON(this.element.dataset.adminChartsCategorySeries)
    const pageviewLabels = this.parseJSON(this.element.dataset.adminChartsPageviewLabels)
    const pageviewSeries = this.parseJSON(this.element.dataset.adminChartsPageviewSeries)

    this.renderSignups(signupLabels, signupSeries)
    this.renderCategories(categoryLabels, categorySeries)
    this.renderPageViews(pageviewLabels, pageviewSeries)
  }

  parseJSON(value) {
    if (!value) return null
    try {
      return JSON.parse(value)
    } catch (error) {
      return null
    }
  }

  renderSignups(labels, series) {
    const ctx = document.getElementById("signupsChart")
    if (!ctx || !labels || !series) return

    new Chart(ctx, {
      type: "line",
      data: {
        labels,
        datasets: [
          {
            label: "Signups",
            data: series,
            borderColor: "#16a34a",
            backgroundColor: "rgba(22, 163, 74, 0.12)",
            tension: 0.3,
            fill: true
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: { x: { ticks: { maxTicksLimit: 8 } } }
      }
    })
  }

  renderCategories(labels, seriesByCategory) {
    const ctx = document.getElementById("categoriesChart")
    if (!ctx || !labels || !seriesByCategory) return

    const palette = ["#16a34a", "#22c55e", "#f59e0b", "#3b82f6", "#a855f7"]
    const datasets = Object.entries(seriesByCategory).map(([category, series], index) => ({
      label: category,
      data: series,
      borderColor: palette[index % palette.length],
      backgroundColor: "rgba(22, 163, 74, 0.08)",
      tension: 0.3,
      fill: false
    }))

    new Chart(ctx, {
      type: "line",
      data: {
        labels,
        datasets
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: "bottom" } },
        scales: { x: { ticks: { maxTicksLimit: 8 } } }
      }
    })
  }

  renderPageViews(labels, seriesByPath) {
    const ctx = document.getElementById("pageViewsChart")
    if (!ctx || !labels || !seriesByPath) return

    const palette = ["#2563eb", "#16a34a", "#f59e0b", "#7c3aed", "#ef4444"]
    const datasets = Object.entries(seriesByPath).map(([path, series], index) => ({
      label: path,
      data: series,
      borderColor: palette[index % palette.length],
      backgroundColor: "rgba(37, 99, 235, 0.08)",
      tension: 0.3,
      fill: false
    }))

    if (datasets.length === 0) return

    new Chart(ctx, {
      type: "line",
      data: {
        labels,
        datasets
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: "bottom" } },
        scales: { x: { ticks: { maxTicksLimit: 8 } } }
      }
    })
  }
}
