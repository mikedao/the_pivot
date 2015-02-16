class StaticPagesController < ApplicationController
  def choose
    session[:tenant_id] = nil
  end
end
