class Work < ApplicationRecord

  validates :title, presence: true, uniqueness: true

  has_many :votes
  has_many :users, through: :votes

  # def work_category(category)
  #   works_in_category = Work.where(category: category)
  #   return works_in_category
  # end

  # For top-10 or spotlight, what if there are less than 10 works? What if there are no works?
  # TODO: fix spotlight based on vote, and if it's a tie, return the recent vote
  def self.spotlight
    max_votes = Work.all.max_by {|work| work.votes.count}.votes.count
    works_with_max_votes = Work.all.select {|work| work.votes.count == max_votes}
    # sort_by vote_id
    max_id = 0
    work_with_high_vote_id = []
    works_with_max_votes.each do |work|
      work.votes.each do |vote|
        if vote.id > max_id
          max_id = vote.id
          work_with_high_vote_id << work
        end
      end
    end

    return work_with_high_vote_id.last
    # return Work.all.sort_by { |work | work.votes.count }.max
  end

  def self.top_ten(category)
    # return Work.where(category: category).sample(10)
    return Work.where(category: category)
               .sort_by { |category_work| category_work.votes.count }
               .reverse[0..9]
  end

  # TODO: this method should be in a view helper?
  def date_voted_on
    vote = Vote.find_by(work_id: self.id )
    return vote.created_at.strftime('%b %d, %Y')
  end

  # def date_voted_on
  #   vote = Vote.find_by(work_id: self.id )
  #   return vote.created_at.strftime('%b %d, %Y')
  # end

end
