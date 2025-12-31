import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['container']

  connect() {
    this.index = this.getMaxIndex()
  }

  addAuthor(event) {
    event.preventDefault()
    
    const newIndex = ++this.index
    const template = `
      <div class="author-field mb-3" data-controller="author-autocomplete">
        <div class="row align-items-end">
          <div class="col-11">
            <input type="hidden" name="entry[authors_entries_attributes][${newIndex}][author_id]" data-author-autocomplete-target="authorId">
            <input type="text" class="form-control" placeholder="Search author..." data-author-autocomplete-target="searchInput" data-action="input->author-autocomplete#search keydown->author-autocomplete#handleKeydown">
            <ul class="list-group" data-author-autocomplete-target="results" style="display: none;"></ul>
          </div>
          <div class="col-1">
            <button type="button" class="btn btn-outline-danger btn-sm w-100" data-action="click->authors-list#removeAuthor">
              <i class="bi bi-x-lg"></i>
            </button>
          </div>
        </div>
      </div>
    `
    
    this.containerTarget.insertAdjacentHTML('beforeend', template)
  }

  removeAuthor(event) {
    event.preventDefault()
    event.currentTarget.closest('.author-field').remove()
  }

  getMaxIndex() {
    const inputs = document.querySelectorAll('input[name*="authors_entries_attributes"]')
    if (inputs.length === 0) return -1
    
    let maxIndex = -1
    inputs.forEach(input => {
      const match = input.name.match(/authors_entries_attributes\]\[(\d+)\]/)
      if (match) {
        const index = parseInt(match[1], 10)
        if (index > maxIndex) maxIndex = index
      }
    })
    return maxIndex
  }
}
