class Item < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category, optional: true
  has_many :images, dependent: :destroy
  has_many :comments
  accepts_nested_attributes_for :images, allow_destroy: true
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks

# アイテム出品、編集のバリデーション
  validates :title,              presence: true, length: { maximum: 40 }       # 商品名。文字あるか。文字数40以下。
  validates :content,            presence: true, length: { maximum: 1000 }     # 商品の説明。文字かるか。文字数1000以下。
  validates :price,              numericality: {greater_than_or_equal_to: 300} # 値段。300円以上。
  validates :price,              numericality: {less_than_or_equal_to: 9999999}# 値段。9999999以上。
  validates :status_id,          numericality: {only_interger: true}           # 商品状態。数値のあるか。
  validates :delivery_method_id, numericality: {only_interger: true}           # 配達方法。
  validates :prefecture_id,      numericality: {only_interger: true}           # 配達元の地域。
  validates :delivery_days_id,   numericality: {only_interger: true}           # 配達までの日数。
  validates :delivery_charge_id, numericality: {only_interger: true}           # 配達料の負担。
  validates :images,             presence: true                                # 写真。
  validates :category_id,        numericality: {only_interger: true}           # カテゴリー。

  # t.string "title", null: false
  # t.text "content", null: false
  # t.integer "price", null: false
  # t.integer "status_id"
  # t.integer "delivery_method_id"
  # t.integer "prefecture_id", null: false
  # t.integer "delivery_days_id", null: false
  # t.integer "delivery_charge_id", null: false
  # t.bigint "category_id"
  # t.bigint "seller_id"
  # t.bigint "buyer_id"
  # t.datetime "created_at", null: false
  # t.datetime "updated_at", null: false
  # t.index ["buyer_id"], name: "index_items_on_buyer_id"
  # t.index ["category_id"], name: "index_items_on_category_id"
  # t.index ["seller_id"], name: "index_items_on_seller_id"

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :delivery_charge
  belongs_to_active_hash :delivery_days
  belongs_to_active_hash :delivery_method
  belongs_to_active_hash :status
  
  def self.search(search)
    return Item.all unless search
    Item.where('title LIKE(?)', "%#{search}%")
  end
end
