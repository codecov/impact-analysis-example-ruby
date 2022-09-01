require "rails_helper"

describe TimerHelper do
  describe "time format" do
    it "returns correctly formatted time" do
      100.times do
        current_time = Time.now()
        expect(helper.format_time(current_time)).to eql(current_time.strftime('%Y-%m-%d:%H:%M:%S'))
      end
    end
  end
end
