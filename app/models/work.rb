class Work < ApplicationRecord

  def work_category(category)
    works_in_category = Work.where(category: category)
    return works_in_category
  end

end
