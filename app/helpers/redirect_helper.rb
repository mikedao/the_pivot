module RedirectHelper
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    if request.post? && request.referer ==
       new_user_url(message: "You Must Signup or Login to Lend Money")
      session[:forwarding_url] = pending_loan_path
    else
      session[:forwarding_url] = request.referer
    end
  end
end
