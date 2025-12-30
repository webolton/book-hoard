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
      
      // Listen for modal hidden event to reset the frame
      modalElement.addEventListener('hidden.bs.modal', () => {
        this.resetFrame()
      }, { once: true })
    }
  }

  submitEnd(event) {
    console.log('Submit end event:', event.detail)
    // Close modal after form submission (the turbo stream will replace the frame)
    this.closeModal()
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

  resetFrame() {
    // Use Turbo to reload the frame with just the link
    const frame = document.getElementById('new_author_modal')
    if (frame) {
      // Perform a Turbo visit to reload the frame with the link
      fetch('/authors/new_modal_link', {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
        }
      })
      .then(response => response.text())
      .then(html => {
        frame.innerHTML = html
      })
    }
  }
}
