class ApplicationController < ActionController::Base
  # Deviseによるサインイン後のリダイレクト先を定義（User/Adminで場合分け）
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      root_path
    elsif resource.is_a?(Admin)
      admin_root_path 
    else
      super
    end
  end
end