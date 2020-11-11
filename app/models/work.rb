class Work < ApplicationRecord

  validates :title, presence: true, uniqueness: true

  has_many :votes
  has_many :users, through: :votes

  def work_category(category)
    works_in_category = Work.where(category: category)
    return works_in_category
  end

  # need a top 10
  # need a method for spotlight for a work
  # For top-10 or spotlight, what if there are less than 10 works? What if there are no works?
  # How are we testing for these custom methods?
  def self.spotlight
    return Work.all.sample
  end

  def self.top_ten(category)
    return Work.where(category: category).sample(10)
  end

  def date_voted_on
    vote = Vote.find_by(work_id: self.id )
    return vote.created_at.strftime('%b %d, %Y')
  end

end
