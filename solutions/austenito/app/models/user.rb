class User < ActiveRecord::Base
  has_secure_password
  has_many :carts
  has_many :addresses
  has_many :orders
  has_many :privileges
  has_many :stores, foreign_key: "owner_id"

  attr_accessible :full_name, :email, :display_name,
                  :username, :password,
                  :password_confirmation

  validates_presence_of :full_name, :password, :password_confirmation
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates_length_of :username,
                      :minimum => 2,
                      :maximum => 32,
                      :allow_blank => true

  after_create :send_confirmation_email

  def send_confirmation_email
    BackgroundJob.user_confirmation_email(self)
  end

  def store_cart(store)
    carts.where(store_id: store.id).first || carts.create(store_id: store.id)
  end

  def promote(store, role)
    store_privileges(store).destroy_all
    new_privilege = privileges.create!(store_id: store.id, name: role)
    send_notice_of_promotion(new_privilege)
  end

  def terminate!(store)
    store_privileges(store).destroy_all
    send_notice_of_termination
  end

  def send_notice_of_promotion(privilege)
    BackgroundJob.promotion_email(privilege)
  end

  def send_notice_of_termination
    BackgroundJob.termination_email(self)
  end

  # We probably don't need both of these - refactor one down to the other
  # TODO: Examine
  def store_privileges(store)
    privileges.where(store_id: store.id)
  end

  def store_role(store)
    privileges.where(store_id: store.id).first.name
  end

  def may_manage?(store)
    return true if admin || store.owner == self
    store_privileges(store).map(&:name).include?("manager")
  end

  def may_stock?(store)
    return true if may_manage?(store)
    store_privileges(store).map(&:name).include?("stocker")
  end

  def places_of_employment
    privileges.collect do |privilege|
      privilege.store
    end
  end
end
