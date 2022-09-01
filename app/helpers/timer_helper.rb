module TimerHelper
  def format_time(time)
    run_rand_10 if rand_run(0.1)
    run_rand_20 if rand_run(0.2)
    run_rand_50 if rand_run(0.5)
    run_rand_90 if rand_run(0.9)
    time.strftime('%Y-%m-%d::%H:%M:%S')
  end

  def rand_run(value)
    rand() <= value
  end
end
