class TimerController < ApplicationController
  def index
  end

  def time
    @time = Time.now
  end
end
