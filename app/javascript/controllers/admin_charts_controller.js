import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.ensureChart().then((ready) => {
      if (!ready) return

      this.loadCharts()
      this.poller = setInterval(() => this.loadCharts(), 30000)
    })
  }

  disconnect() {
    if (this.poller) {
      clearInterval(this.poller)
    }
  }

  async ensureChart() {
    if (window.Chart) return true

    try {
      const module = await import("chart.js/auto")
      window.Chart = module.default
      return true
    } catch (error) {
      return this.loadChartFromCdn()
    }
  }

  loadChartFromCdn() {
    return new Promise((resolve) => {
      if (window.Chart) {
        resolve(true)
        return
      }

      const existing = document.querySelector("script[data-chartjs]")
      if (existing) {
        existing.addEventListener("load", () => resolve(!!window.Chart))
        existing.addEventListener("error", () => resolve(false))
        return
      }

      const script = document.createElement("script")
      script.src = "https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.js"
      script.async = true
      script.dataset.chartjs = "true"
      script.addEventListener("load", () => resolve(!!window.Chart))
      script.addEventListener("error", () => resolve(false))
      document.head.appendChild(script)
    })
  }

  async loadCharts() {
    const url = this.element.dataset.adminChartsUrl
    if (!url) return

    try {
      const response = await fetch(url, { credentials: "same-origin" })
      if (!response.ok) return

      const data = await response.json()
      this.renderSignups(data.signup_labels, data.signup_series)
      this.renderCategories(data.category_labels, data.category_series)
      this.renderPageViews(data.pageview_labels, data.pageview_series)
    } catch (error) {
      return
    }
  }

  renderSignups(labels, series) {
    const ctx = document.getElementById("signupsChart")
    if (!ctx || !labels || !series) return

    if (this.signupsChart) {
      this.signupsChart.data.labels = labels
      this.signupsChart.data.datasets[0].data = series
      this.signupsChart.update()
      return
    }

    this.signupsChart = new Chart(ctx, {
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

    if (this.categoriesChart) {
      this.categoriesChart.data.labels = labels
      this.categoriesChart.data.datasets = datasets
      this.categoriesChart.update()
      return
    }

    this.categoriesChart = new Chart(ctx, {
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

    if (this.pageViewsChart) {
      this.pageViewsChart.data.labels = labels
      this.pageViewsChart.data.datasets = datasets
      this.pageViewsChart.update()
      return
    }

    this.pageViewsChart = new Chart(ctx, {
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
