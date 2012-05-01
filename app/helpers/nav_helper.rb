module NavHelper

  def main_navigation
    if request.subdomain.empty?
      if current_user
        nav_array_home_user
      else
        nav_array_home_guest
      end
    elsif current_user && current_user.admin?
      nav_array_admin
    elsif current_user
      nav_array_user
    else
      nav_guest
    end
  end

  def nav_array_home_user
    { 
      "Browse All Stores" => polutropon_path,
      "View/Edit Profile" => profile_path,      
      "Logout" => logout_path,
    }
  end

  def nav_array_home_guest
    { 
      "Browse All Stores" => polutropon_path,
      "Login or Signup" => login_path
    }
  end

  def nav_array_admin
    {
      "Browse All Stores" => polutropon_path,
      "Cart (#{@cart.products.size if @cart})" => cart_path,
      "Sales" => sales_path,
      "Admin Dashboard" => admin_dashboard_path,
      "My Orders" => my_orders_orders_path,
      "Profile" => profile_path,
      "Logout" => logout_path
    }
  end

  def nav_array_user
    {
      "Browse All Stores" => polutropon_path,
      "Cart (#{@cart.products.size if @cart})" => cart_path,
      "Sales" => sales_path,
      "My Orders" => my_orders_orders_path,
      "Profile" => profile_path,
      "Logout" => logout_path
    }
  end

  def nav_guest
    {
      "Browse All Stores" => polutropon_path,
      "#{current_tenant.name} Products" => root_path,
      "Cart (#{@cart.products.size if @cart})" => cart_path,
      "Sales" => sales_path,
      "Login or Signup" => login_path
    }
  end

  def admin_navigation
    {
      "Browse All Stores" => polutropon_path,
      "Products"    => admin_products_path,
      "Orders"      => admin_orders_path,
      "Categories"  => admin_categories_path,
      "Users"       => admin_users_path,
      "Sales"       => admin_sales_path
    }
  end
end