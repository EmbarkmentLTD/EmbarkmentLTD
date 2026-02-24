import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["debug"]

  connect() {
    this.debugLines = []
    this.debug("connect()")

    this.ensureChart().then((ready) => {
      this.debug(`ensureChart() => ${ready}`)
      if (!ready) {
        this.debug("Chart.js unavailable")
        return
      }

      this.renderInitialCharts()
      this.loadCharts()
      this.poller = setInterval(() => this.loadCharts(), 30000)
      this.debug("polling every 30000ms")
    })
  }

  disconnect() {
    if (this.poller) {
      clearInterval(this.poller)
    }
    this.debug("disconnect()")
  }

  async ensureChart() {
    if (window.Chart) {
      this.debug("window.Chart already present")
      return true
    }

    try {
      const module = await import("chart.js/auto")
      const chartConstructor = module.default || module.Chart
      if (chartConstructor) {
        window.Chart = chartConstructor
        this.debug("import chart.js/auto success")
        return true
      }
      this.debug("import chart.js/auto missing export")
      return false
    } catch (error) {
      this.debug(`import failed: ${error?.message || error}`)
      return this.loadChartFromCdn()
    }
  }

  loadChartFromCdn() {
    return new Promise((resolve) => {
      if (window.Chart) {
        this.debug("cdn skipped; Chart already present")
        resolve(true)
        return
      }

      const existing = document.querySelector("script[data-chartjs]")
      if (existing) {
        this.debug("waiting for existing Chart.js script")
        existing.addEventListener("load", () => {
          this.debug("existing Chart.js script loaded")
          resolve(!!window.Chart)
        })
        existing.addEventListener("error", () => {
          this.debug("existing Chart.js script failed")
          resolve(false)
        })
        return
      }

      const script = document.createElement("script")
      script.src = "https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.js"
      script.async = true
      script.dataset.chartjs = "true"
      script.addEventListener("load", () => {
        this.debug("cdn Chart.js loaded")
        resolve(!!window.Chart)
      })
      script.addEventListener("error", () => {
        this.debug("cdn Chart.js failed")
        resolve(false)
      })
      document.head.appendChild(script)
      this.debug("injecting Chart.js CDN script")
    })
  }

  async loadCharts() {
    const url = this.element.dataset.adminChartsUrl
    if (!url) {
      this.debug("missing data-admin-charts-url")
      return
    }

    try {
      const response = await fetch(url, { credentials: "same-origin" })
      this.debug(`fetch ${url} => ${response.status}`)
      if (!response.ok) return

      const data = await response.json()
      this.debug(`json received: signups=${(data?.signup_series || []).length}, categories=${Object.keys(data?.category_series || {}).length}, pageviews=${Object.keys(data?.pageview_series || {}).length}`)
      this.renderAll(data)
    } catch (error) {
      this.debug(`loadCharts error: ${error?.message || error}`)
      return
    }
  }

  renderInitialCharts() {
    const raw = this.element.dataset.adminChartsInitial
    if (!raw) {
      this.debug("no initial chart payload")
      return
    }

    try {
      const data = JSON.parse(raw)
      this.debug("initial payload parsed")
      this.renderAll(data)
    } catch (error) {
      this.debug(`initial payload parse error: ${error?.message || error}`)
      return
    }
  }

  renderAll(data) {
    if (!data) {
      this.debug("renderAll: empty payload")
      return
    }

    this.renderSignups(data.signup_labels, data.signup_series)
    this.renderCategories(data.category_labels, data.category_series)
    this.renderPageViews(data.pageview_labels, data.pageview_series)
  }

  renderSignups(labels, series) {
    const ctx = document.getElementById("signupsChart")
    if (!ctx || !labels || !series) {
      this.debug("signups skipped: missing canvas/labels/series")
      return
    }

    if (this.signupsChart) {
      this.signupsChart.data.labels = labels
      this.signupsChart.data.datasets[0].data = series
      this.signupsChart.update()
      this.debug(`signups updated (${series.length})`)
      return
    }

    this.signupsChart = new window.Chart(ctx, {
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
    this.debug(`signups rendered (${series.length})`)
  }

  renderCategories(labels, seriesByCategory) {
    const ctx = document.getElementById("categoriesChart")
    if (!ctx || !labels || !seriesByCategory) {
      this.debug("categories skipped: missing canvas/labels/series")
      return
    }

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
      this.debug(`categories updated (${datasets.length} datasets)`)
      return
    }

    this.categoriesChart = new window.Chart(ctx, {
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
    this.debug(`categories rendered (${datasets.length} datasets)`)
  }

  renderPageViews(labels, seriesByPath) {
    const ctx = document.getElementById("pageViewsChart")
    if (!ctx || !labels || !seriesByPath) {
      this.debug("pageviews skipped: missing canvas/labels/series")
      return
    }

    const palette = ["#2563eb", "#16a34a", "#f59e0b", "#7c3aed", "#ef4444"]
    const datasets = Object.entries(seriesByPath).map(([path, series], index) => ({
      label: path,
      data: series,
      borderColor: palette[index % palette.length],
      backgroundColor: "rgba(37, 99, 235, 0.08)",
      tension: 0.3,
      fill: false
    }))

    if (datasets.length === 0) {
      this.debug("pageviews skipped: 0 datasets")
      return
    }

    if (this.pageViewsChart) {
      this.pageViewsChart.data.labels = labels
      this.pageViewsChart.data.datasets = datasets
      this.pageViewsChart.update()
      this.debug(`pageviews updated (${datasets.length} datasets)`)
      return
    }

    this.pageViewsChart = new window.Chart(ctx, {
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
    this.debug(`pageviews rendered (${datasets.length} datasets)`)
  }

  debug(message) {
    const stamp = new Date().toLocaleTimeString()
    this.debugLines = this.debugLines || []
    this.debugLines.push(`[${stamp}] ${message}`)
    this.debugLines = this.debugLines.slice(-16)

    if (this.hasDebugTarget) {
      this.debugTarget.textContent = this.debugLines.join("\n")
    }
  }
}
