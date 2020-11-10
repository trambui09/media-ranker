class Work < ApplicationRecord

  validates :title, presence: true, uniqueness: true

  def work_category(category)
    works_in_category = Work.where(category: category)
    return works_in_category
  end

  # need a top 10
  # need a method for spotlight for a work
  # For top-10 or spotlight, what if there are less than 10 works? What if there are no works?
  def self.spotlight
    return Work.all.sample
  end

  def self.top_ten(category)
    return Work.where(category: category).sample(10)
  end

end
