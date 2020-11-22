module Authentication
  def authenticate!
    unless current_user?
      session[:original_request] = request.path_info
      redirect '/sign_in'
    end
  end

  def current_user
    if session[:user_id].present?
      @current_user ||= User.find_by(id: session[:user_id])
    else
      @current_user = nil
    end
  end

  # @param [User, nil] user
  def current_user=(user)
    if user.nil?
      session[:user_id] = nil
    else
      session[:user_id] = user.id.to_s
    end
  end

  def current_user?
    current_user.present?
  end
end