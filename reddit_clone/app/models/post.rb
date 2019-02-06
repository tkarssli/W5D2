# == Schema Information
#
# Table name: posts
#
#  id         :bigint(8)        not null, primary key
#  title      :string           not null
#  url        :string
#  content    :string
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord
  validates :title, :author_id, presence: true

  def sub_ids=(sub_ids)
    self.post_subs.each do |post_sub|
      post_sub.destroy
    end
    sub_ids.map(&:to_i).each do |sub_id|
      p = PostSub.new(post_id: self.id, sub_id: sub_id)
      p.save
    end
  end

  belongs_to :author,
    foreign_key: :author_id,
    class_name: :User

  has_many :post_subs,
    foreign_key: :post_id,
    class_name: :PostSub

  has_many :subs,
    through: :post_subs, 
    source: :sub

  has_many :comments

  
end
