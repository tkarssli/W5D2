# == Schema Information
#
# Table name: posts
#
#  id         :bigint(8)        not null, primary key
#  title      :string           not null
#  url        :string
#  content    :string
#   sub_id    :integer          not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord
  validates :title, :
   :author_id, presence: true



  belongs_to :author,
    foreign_key: :author_id,
    class_name: :User

  belongs_to :sub 

  has_many :post_subs,
    foreign_key: :post_id,
    class_name: :PostSub

  has_many :subs,
    through: :post_subs, 
    source: :sub
end
