# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :entries, through: :authors_entries

  scope :search, lambda { |query|
    query.present? ? where('first_name LIKE ? OR last_name LIKE ?', "%#{query}%", "%#{query}%") : none
  }

  validates :first_name, presence: true, unless: ->(author) { author.last_name.present? }
  validates :last_name, presence: true, unless: ->(author) { author.first_name.present? }

  validates :first_name,
            uniqueness: { scope: :last_name,
                          message: I18n.t('authors.validations.duplicate_full_name') }

  validate :first_or_last_name_present

  def full_name
    "#{last_name}, #{first_name}"
  end

  private

  def first_or_last_name_present
    return unless first_name.blank? && last_name.blank?

    errors.add(:base, I18n.t('authors.validations.first_and_last_name_blank'))
  end
end
