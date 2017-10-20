class CookTime
  attr_reader :interval, :hours, :minutes

  def initialize(interval)
    if interval.nil? || interval.empty?
      interval = '00:00'
    end
    # strip off seconds and leading zeros
    # turn into HH:MM format (hours may be > 99)
    hh_mm = /\A0*(\d*):0*(\d*)/
    @interval, @hours, @minutes = interval.match(hh_mm)[0..2]
    @hours = '0' if hours.empty?
    @minutes = '0' if minutes.empty?
  end

  def form_hh_mm
    "#{hours} h #{minutes} m"
  end

  def to_s
    @interval
  end
end
