class Work < ApplicationRecord

  validates :title, presence: true

  def work_category(category)
    works_in_category = Work.where(category: category)
    return works_in_category
  end

end
