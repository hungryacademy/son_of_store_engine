class UserMailer < ActionMailer::Base
  default from: "storeengine@gmail.com"

  def order_confirmation(user, order)
    @user = user
    @order = order
    mail(:to => @user.email,
      :subject => "Your #{order.store.name} Order #{order.id}")
  end

  def status_confirmation(user, order)
    @user = user
    @order = order
    status = order.current_status
    mail(:to => @user.email,
      :subject => "Your #{order.store.name} Order #{order.id} is now #{status}")
  end

  def declined_store_notice(user, store_name, store_description,
                            store_slug)
    @user = user
    @store_name = store_name
    @store_description = store_description
    @store_slug = store_slug
    mail(:to => @user.email,
      :subject => "Your Store Proposal for #{store_name} has been declined")
  end

  def approved_store_notice(store)
    @user = store.owner
    @store = store
    mail(:to => @user.email,
      :subject => "Your Store Proposal for #{store.name} has been approved" )
  end

  def promotion_notice(permission)
    @user = User.find(permission["user_id"])
    @store = Store.find(permission["store_id"])
    @role = permission["name"]
    mail(:to => @user.email,
      :subject => "Your new job, should you choose to accept it is #{@role}." )
  end

  def invitation(email, privilege, store)
    @email = email
    @privilege = privilege
    @store_name = Store.find_by_id(store["id"]).name
    mail(:to => @email,
      :subject => "#{store["name"]} wants you to sign up to be a #{privilege}!")
  end

  def user_confirmation(user)
    @email = user["email"]
    mail(:to => @email,
      :subject => "Welcome to SOSE, #{user["name"]}!" )
  end

  def termination_notice(user)
    @email = user["email"]
    mail(:to => @email,
      :subject => "Sorry, #{user["name"]} - you are the weakest link." )
  end
end
