import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['dateInput', 'dateField']

  handleDateChange(event) {
    const input = event.target.value.trim()
    const date = this.parseDate(input)
    
    if (date) {
      // Format as ISO 8601 for the hidden field
      this.dateFieldTarget.value = date.toISOString().split('T')[0]
      // Display the formatted date in the input
      event.target.value = this.formatDateForDisplay(date)
    } else if (input === '') {
      // Clear both fields if input is empty
      this.dateFieldTarget.value = ''
      event.target.value = ''
    } else {
      // Invalid input - reset to previous value
      console.warn('Invalid date format:', input)
      event.target.value = this.dateFieldTarget.value ? this.formatDateForDisplay(new Date(this.dateFieldTarget.value)) : ''
    }
  }

  parseDate(input) {
    // Check if input is just a year (YYYY)
    if (/^\d{4}$/.test(input)) {
      const year = parseInt(input, 10)
      // Default to January 1st of that year
      return new Date(year, 0, 1)
    }

    // Check if input is a full date (YYYY-MM-DD)
    if (/^\d{4}-\d{2}-\d{2}$/.test(input)) {
      const date = new Date(input)
      // Validate that the date is valid
      if (!isNaN(date.getTime())) {
        return date
      }
    }

    // Check if input is partial date (YYYY-MM)
    if (/^\d{4}-\d{2}$/.test(input)) {
      const [year, month] = input.split('-').map(Number)
      return new Date(year, month - 1, 1)
    }

    return null
  }

  formatDateForDisplay(date) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }
}
