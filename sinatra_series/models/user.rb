class User < ActiveRecord::Base
  validates :email, uniqueness: true
  def to_json
    super(except: :password)
  end
end
