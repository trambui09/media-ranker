class Vote < ApplicationRecord
  belongs_to :work
  belongs_to :user

  # validates :work uniqueness: { scope: :user }
  # validates_uniqueness_of :work_id, scope: :user_id
  # validates_uniqueness_of :vote, scope: [:work_id, :user_id]

  validates :user, uniqueness: { scope: :work,
                                    message: "has already voted for this work"
  }

end
