import { Controller } from '@hotwired/stimulus'
import { Modal } from 'bootstrap'

// Connects to data-controller="authors-modal"
export default class extends Controller {
  connect() {
    console.log('Authors modal controller connected')
    // Show modal when controller connects (after frame loads)
    this.showModal()
  }

  showModal() {
    const modalElement = document.getElementById('author-modal-form')
    console.log('Modal element:', modalElement)
    if (modalElement) {
      this.modal = new Modal(modalElement)
      this.modal.show()
    }
  }

  submitEnd(event) {
    console.log('Submit end event:', event.detail)
    // Close modal on successful form submission
    if (event.detail.success) {
      this.closeModal()
    }
  }

  closeModal() {
    const modalElement = document.getElementById('author-modal-form')
    if (modalElement) {
      const modal = Modal.getInstance(modalElement)
      if (modal) {
        modal.hide()
      }
    }
    
    // Clean up any remaining modal artifacts
    document.body.classList.remove('modal-open')
    const backdrops = document.querySelectorAll('.modal-backdrop')
    backdrops.forEach(backdrop => backdrop.remove())
  }
}
