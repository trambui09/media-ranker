class Work < ApplicationRecord

  validates :title, presence: true

  def work_category(category)
    works_in_category = Work.where(category: category)
    return works_in_category
  end

  # need a top 10
  # need a method for spotlight for a work

end
