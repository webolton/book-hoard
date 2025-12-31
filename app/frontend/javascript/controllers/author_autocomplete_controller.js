import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['searchInput', 'results', 'authorId']

  connect() {
    this.selectedIndex = -1
  }

  search() {
    const query = this.searchInputTarget.value.trim()
    
    if (query.length < 1) {
      this.resultsTarget.style.display = 'none'
      this.selectedIndex = -1
      return
    }

    fetch(`/authors/search?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(authors => this.displayResults(authors))
  }

  displayResults(authors) {
    console.log('Authors received:', authors)
    this.resultsTarget.innerHTML = ''
    this.selectedIndex = -1

    if (authors.length === 0) {
      this.resultsTarget.style.display = 'none'
      return
    }

    authors.forEach((author, index) => {
      const name = author.name || `${author.first_name} ${author.last_name}`.trim()
      
      const li = document.createElement('li')
      li.className = 'list-group-item list-group-item-action'
      li.textContent = name
      li.style.cursor = 'pointer'
      li.dataset.index = index
      li.dataset.id = author.id
      li.dataset.name = name
      
      li.addEventListener('click', (event) => {
        this.selectAuthor(event.currentTarget)
      })
      
      li.addEventListener('mouseenter', () => {
        this.highlightItem(index)
      })
      
      this.resultsTarget.appendChild(li)
    })

    this.resultsTarget.style.display = 'block'
  }

  handleKeydown(event) {
    const items = this.resultsTarget.querySelectorAll('li')
    const itemCount = items.length

    if (itemCount === 0) return

    switch (event.key) {
      case 'ArrowDown':
        event.preventDefault()
        this.selectedIndex = (this.selectedIndex + 1) % itemCount
        this.highlightItem(this.selectedIndex)
        break
      case 'ArrowUp':
        event.preventDefault()
        this.selectedIndex = this.selectedIndex <= 0 ? itemCount - 1 : this.selectedIndex - 1
        this.highlightItem(this.selectedIndex)
        break
      case 'Enter':
        event.preventDefault()
        if (this.selectedIndex >= 0 && this.selectedIndex < itemCount) {
          this.selectAuthor(items[this.selectedIndex])
        }
        break
      case 'Escape':
        event.preventDefault()
        this.resultsTarget.style.display = 'none'
        this.selectedIndex = -1
        break
    }
  }

  highlightItem(index) {
    const items = this.resultsTarget.querySelectorAll('li')
    items.forEach((item, i) => {
      if (i === index) {
        item.classList.add('active')
        item.style.backgroundColor = '#0d6efd'
        item.style.color = 'white'
      } else {
        item.classList.remove('active')
        item.style.backgroundColor = ''
        item.style.color = ''
      }
    })
  }

  selectAuthor(element) {
    const selectedId = element.dataset.id
    const selectedName = element.dataset.name
    
    this.authorIdTarget.value = selectedId
    this.searchInputTarget.value = selectedName
    this.resultsTarget.style.display = 'none'
    this.selectedIndex = -1
  }
}
