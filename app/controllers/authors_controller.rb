# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :require_turbo_frame, only: [:new_modal]

  def create
    @author = Author.new(author_params)
    if @author.save
      flash.now[:notice] = t('authors.notices.create_success')
      render turbo_stream: [
        turbo_stream.update('new_author_modal', partial: 'new_modal_link'),
        turbo_stream.update('notices', partial: 'shared/notices')
      ]
    else
      render :new_modal, status: :unprocessable_content
    end
  end

  def new_modal
    @author = Author.new
  end

  def new_modal_link
    render partial: 'new_modal_link'
  end

  private

  def require_turbo_frame
    redirect_to new_entry_path unless turbo_frame_request?
  end

  def author_params
    params.expect(author: %i[first_name last_name additional_information])
  end
end
