class CookTime
  attr_reader :interval, :hours, :minutes

  def initialize(interval)
    if interval.nil? || interval.empty?
      interval = '00:00'
    end
    # strip off seconds and leading zeros
    # turn into HH:MM format (hours may be > 99)
    hh_mm = /\A0*(\d*):0*(\d*)/
    match = interval.match(hh_mm)
    @interval, @hours, @minutes = match ? match[0..2] : ['00:00', '0', '0']
    @hours = '0' if hours.empty?
    @minutes = '0' if minutes.empty?
  end

  def form_hh_mm
    "#{hours} h #{minutes} m"
  end

  def to_s
    @interval
  end

  def ==(other)
    return nil if ![String, CookTime].include? other.class
    if other.instance_of? String
      interval == other
    elsif other.instance_of? CookTime
      interval == other.interval
    end
  end

  def blank?
    non_zero = /[1-9]+/
    !hours.match?(non_zero) && !minutes.match(non_zero)
  end
end
