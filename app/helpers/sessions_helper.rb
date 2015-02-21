module SessionsHelper
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    if request.post? && request.referer =~ /users\/new/
      session[:forwarding_url] = pending_loan_path
    else
      session[:forwarding_url] = request.referer if request.post?
    end
  end
end
