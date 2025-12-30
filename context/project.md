# Book-Hoard Project Context

## Project Overview

**Book-Hoard** is a scholarly article and book cataloging application built to help organize, search, and manage thousands of scanned academic articles and books. The primary goal is to provide a UI that facilitates:

- Cataloging scholarly articles and books with detailed metadata
- Organizing and renaming scanned document files
- Moving scans to a hard drive with a structured filing system
- Providing searchable, referenceable entries for future lookup

The application is designed to solve the problem of having thousands of scanned articles with no efficient way to find, organize, or reference them.

## Technical Stack

### Backend
- **Framework**: Ruby on Rails 8.0.2
- **Database**: SQLite3 (development and test)
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **Cable/WebSockets**: Solid Cable
- **Server**: Puma
- **Deployment**: Kamal (configured)

### Frontend
- **Build Tool**: Vite (with vite_rails gem)
- **JavaScript Framework**: Stimulus 3.2.2
- **Turbo**: @hotwired/turbo-rails 8.0.16
- **Styling**: Bootstrap 5.3.7 with custom SCSS
- **Icons**: Bootstrap Icons 1.13.1
- **Additional Libraries**: jQuery 3.7.1, Popper.js 2.11.8

### Template Engine
- **Slim** templates for cleaner, more maintainable views

### Testing
- **Framework**: RSpec
- **Test Tools**: 
  - Capybara (integration testing)
  - Factory Bot (test data)
  - Faker (fake data generation)
  - SimpleCov (code coverage)
- **Security**: Brakeman (security scanning)
- **Linting**: RuboCop Rails, Slim Lint

## Current Database Schema

### Tables

#### `authors`
- `id` (primary key)
- `first_name` (string)
- `last_name` (string)
- `additional_information` (string) - stored as "distinction" in forms
- `created_at` (datetime)
- `updated_at` (datetime)

**Validations**: Requires at least first_name OR last_name (not both required)

#### `entries`
Main table for cataloging books and articles:
- `id` (primary key)
- `full_title` (text)
- `publication_date` (datetime)
- `start_page` (integer)
- `end_page` (integer)
- `start_folio` (integer)
- `end_folio` (integer)
- `start_side` (string)
- `end_side` (string)
- `type` (integer enum) - Currently only supports `book: 0`
- `isbn` (string)
- `isbn13` (string)
- `format` (integer)
- `language` (string)
- `publisher` (string)
- `file_location` (string) - **Critical field** for tracking scanned file paths
- `volume` (integer)
- `series` (string)
- `notes` (text)
- `created_at` (datetime)
- `updated_at` (datetime)

#### `authors_entries` (join table)
Many-to-many relationship between authors and entries:
- `entry_id` (integer, not null)
- `author_id` (integer, not null)
- Composite indexes on both directions

## Models

### Entry (`app/models/entry.rb`)
```ruby
class Entry < ApplicationRecord
  has_many :authors, through: :authors_entries
  enum :type, { book: 0 }
end
```

**Current State**: Basic model with author association. Needs expansion for:
- Additional entry types (article, chapter, etc.)
- Validations for required fields
- File management logic
- Search functionality

### Author (`app/models/author.rb`)
```ruby
class Author < ApplicationRecord
  has_many :entries, through: :authors_entries
  validates :first_name, presence: true, unless: ->(author) { author.last_name.present? }
  validates :last_name, presence: true, unless: ->(author) { author.first_name.present? }
end
```

**Current State**: Functional with conditional validations ensuring at least one name is present.

## Controllers

### EntriesController (`app/controllers/entries_controller.rb`)
```ruby
class EntriesController < ApplicationController
  def new
    @entry = Entry.new
  end
end
```

**Current State**: Minimal implementation. Only has `new` action.

**Missing Actions**:
- `create` - to save new entries
- `index` - to list all entries
- `show` - to view entry details
- `edit` / `update` - to modify entries
- `destroy` - to delete entries

### AuthorsController (`app/controllers/authors_controller.rb`)
More complete implementation with Turbo support:
- `new_modal` - Renders modal form for creating authors
- `create` - Creates author with Turbo Stream response
  - Shows flash notice on success
  - Returns modal link partial
  - Returns notices partial
  - Renders with unprocessable_entity status on failure

**Current State**: Functional modal-based author creation using Turbo Streams.

### DashboardController
Not yet examined - needs review.

## Views

### Layout
- Using Slim templates
- Bootstrap 5 components
- Modal-based workflows for authors

### Entry Views (`app/views/entries/`)
- `new.html.slim` - Card-based layout with form
- `_form.html.slim` - Entry creation form
  - Author selection (needs implementation)
  - Turbo frame for "New Author" modal link
  - Full title field
  - Submit and Reset buttons

**Current Issues**:
- Form fields are incomplete (many schema fields not in form)
- No file upload/management UI
- Author selection not implemented

### Author Views (`app/views/authors/`)
- `_form.html.slim` - Modal form for author creation
  - Fields: last_name, first_name, distinction
  - Bootstrap modal structure
  - Form validation error display
- `_new_modal_link.html.slim` - Link to trigger author modal

**Current State**: Working modal implementation with Turbo integration.

## Frontend JavaScript (Stimulus Controllers)

### `authors_modal_controller.js`
```javascript
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    $('#author-modal-form').modal('show')
  }

  submitEnd() {
    $('body').removeClass('modal-open')
    $('.modal-backdrop').remove()
    $('#new-author-success').removeClass('show')
    window.setTimeout(() => {
      $('.alert').fadeTo(500, 0).slideUp(500, () => {
        $(this).remove()
      })
    }, 1000)
  }
}
```

**Current State**: Mixes jQuery with Stimulus. Should be refactored to use Bootstrap 5's native JavaScript API or Stimulus best practices.

### Other Controllers
- `hello_controller.js` - Likely boilerplate
- `application.js` - Base Stimulus application controller
- `index.js` - Controller registration

## Routes (`config/routes.rb`)

```ruby
Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'dashboard#index'

  resources :authors do
    collection do
      get 'new_modal'
    end
  end

  resources :entries
end
```

## Development Setup

### Running the Application
```bash
# Start Vite dev server
bin/vite dev

# Start Rails server (separate terminal)
bundle exec rails s
```

### Database Migrations
Three migrations created:
1. `20250718235938_create_entries.rb`
2. `20250719001136_create_authors.rb`
3. `20250719002054_create_join_table_entry_author.rb`
4. `20250805003228_start_and_end_side_to_entries.rb`

## Testing

### RSpec Configuration
- Configured with Factory Bot
- SimpleCov for coverage reports (see `coverage/` directory)
- Request specs for controllers
- Model specs for validations
- Acceptance specs directory structure started

### Test Coverage
- `spec/models/author_spec.rb` - Validates conditional name requirements
- `spec/models/entry_spec.rb` - Basic factory validation
- `spec/requests/entries_spec.rb` - Needs implementation
- `spec/requests/dashboard_spec.rb` - Needs implementation

## Key Design Patterns & Conventions

1. **Turbo Streams**: Used for dynamic updates without full page reloads (author creation)
2. **Modal Workflows**: Authors created via Bootstrap modals
3. **Turbo Frames**: Isolated content replacement (new author link)
4. **RESTful Resources**: Standard Rails resourceful routing
5. **Slim Templates**: Cleaner, indentation-based templating
6. **Stimulus Controllers**: Progressive enhancement for JavaScript interactions

## Priority TODOs

### High Priority - Core Functionality
1. **Complete Entry CRUD Operations**
   - [ ] Implement `create` action in EntriesController
   - [ ] Build comprehensive entry form with all fields
   - [ ] Implement `index` action with search/filter
   - [ ] Add `show` action for entry details
   - [ ] Add `edit` and `update` actions

2. **File Management System**
   - [ ] Add file upload capability to entries
   - [ ] Implement file renaming logic based on entry metadata
   - [ ] Create file storage organization strategy
   - [ ] Build file browser/selector UI
   - [ ] Add file preview functionality

3. **Entry Form Enhancements**
   - [ ] Add all schema fields to form (publication_date, pages, folios, ISBN, etc.)
   - [ ] Implement author selection/association in entry form
   - [ ] Add multi-author support in entry form
   - [ ] Create entry type selector (expand beyond just "book")

### Medium Priority - UX Improvements
4. **Search & Discovery**
   - [ ] Add full-text search across entries
   - [ ] Implement filter by author
   - [ ] Filter by publication date range
   - [ ] Filter by entry type
   - [ ] Add tags/categories system

5. **Author Management**
   - [ ] Create author index page
   - [ ] Add author show page with associated entries
   - [ ] Implement author edit/update
   - [ ] Add author merge functionality (for duplicates)

6. **Dashboard**
   - [ ] Review and enhance dashboard controller/views
   - [ ] Add statistics (total entries, recent additions, etc.)
   - [ ] Show recent entries
   - [ ] Quick search widget

### Low Priority - Polish & Enhancement
7. **JavaScript Refactoring**
   - [ ] Remove jQuery dependencies where possible
   - [ ] Refactor `authors_modal_controller.js` to use Bootstrap 5 JS API
   - [ ] Add more Stimulus controllers for dynamic behaviors
   - [ ] Implement proper Turbo Drive error handling

8. **Testing Coverage**
   - [ ] Add controller request specs
   - [ ] Add system/acceptance specs for workflows
   - [ ] Increase model test coverage
   - [ ] Add JavaScript controller tests

9. **Deployment & Production**
   - [ ] Configure production database (PostgreSQL recommended)
   - [ ] Set up Kamal deployment
   - [ ] Configure production asset compilation
   - [ ] Set up backup strategy for database and files

## Known Issues

1. **Missing Join Table Model**: The `authors_entries` join table doesn't have an explicit model. Consider adding `has_and_belongs_to_many` or creating explicit `AuthorsEntry` model if additional attributes needed.

2. **jQuery Dependency**: The project uses jQuery alongside modern Stimulus/Turbo. This should be minimized or eliminated for better maintainability.

3. **Entry Type Enum**: Currently only supports `book: 0`. Needs expansion for articles, chapters, etc.

4. **Form Validation**: Entry form has no validations yet. Need to determine required fields and add validations.

5. **No File Upload**: The `file_location` field exists but no upload mechanism is implemented.

## Future Considerations

### Potential Enhancements
- **OCR Integration**: Extract text from scanned PDFs for searchability
- **Citation Generation**: Auto-generate citations in various formats (MLA, APA, Chicago)
- **Export Functionality**: Export catalog to BibTeX, CSV, or other formats
- **Tagging System**: Add tags/categories for better organization
- **Notes & Annotations**: Ability to add reading notes to entries
- **Collection Management**: Group entries into collections or reading lists
- **API**: REST API for programmatic access
- **Import**: Bulk import from BibTeX or other sources

### Scalability Considerations
- Switch from SQLite to PostgreSQL for production
- Add full-text search engine (e.g., Elasticsearch, pg_search)
- Implement file storage strategy (Active Storage with S3/cloud storage)
- Add pagination for large datasets
- Consider background jobs for file processing

## Project Structure Notes

- **Vite Integration**: Custom frontend build pipeline separate from Asset Pipeline
- **Rails 8 Features**: Using new Solid* gems (Solid Queue, Cache, Cable)
- **Modern Hotwire Stack**: Turbo + Stimulus for reactive UI without heavy JavaScript
- **Development Workflow**: Separate Vite and Rails servers in development

## Configuration Files

- `config/routes.rb` - Application routes
- `config/database.yml` - Database configuration
- `config/vite.json` - Vite frontend configuration
- `vite.config.ts` - Vite build configuration
- `package.json` - Frontend dependencies
- `Gemfile` - Ruby dependencies
- `Procfile.dev` - Development process management
- `config/deploy.yml` - Kamal deployment configuration

---

**Last Updated**: December 30, 2025  
**Rails Version**: 8.0.2  
**Status**: Early Development - Core CRUD operations in progress
