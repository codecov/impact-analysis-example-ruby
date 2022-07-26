module TimerHelper
  def format_time(time)
    run_rand() if rand_run
    time.strftime('%Y-%m-%d--%H:%M:%S')
  end

  def rand_run(value=0.2)
    rand() <= value
  end
end
