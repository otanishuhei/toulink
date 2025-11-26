class ApplicationController < ActionController::Base
  # Deviseによるリダイレクト先を定義（User/Adminで場合分け）
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_root_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path
    else
      root_path
    end
  end
end
