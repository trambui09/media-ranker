class User < ApplicationRecord

  has_many :votes
  has_many :works, through: :votes

  # a user must have an uid
  # validates :uid, presence: true

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = auth_hash["provider"]
    user.username = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]

    # note that the user has not been saved
    # we'll choose to do the saving outside of this method
    return user
  end

end
