class Timetrap::Formatters::Pay
  attr_accessor :output
  include Timetrap::Helpers

  def initialize entries
    paym = Timetrap::Config['pay_rate'].match(/\A(\D*)([\d\.]+)(\D*)\Z/)
    pay_rate = 0
    if paym.nil?
      format_pay = lambda {|pay| ''}
    else
      pay_rate = paym.captures[1].to_f
      pay_length = (
        Math::log10(18*5*4*pay_rate).ceil + # Unlikely to earn more than this in a month
        paym.captures[0].length + # Prefix length
        paym.captures[2].length + # Suffix length
        2 ) # Decimal point + place
      pay_lengthf = '%%%ds' % pay_length
      pay_format = paym.captures[0] + '%.1f' + paym.captures[2]
      format_pay = lambda {|pay| pay_lengthf % [ pay_format % pay ]}
    end
    cpay = lambda {|time| (pay_rate * time)/3600}

    self.output = ''
    sheets = entries.inject({}) do |h, e|
      h[e.sheet] ||= []
      h[e.sheet] << e
      h
    end
    gpay = 0;
    (sheet_names = sheets.keys.sort).each do |sheet|
      self.output <<  "Timesheet: #{sheet}\n"
      id_heading = Timetrap::CLI.args['-v'] ? 'Id' : '  '
      self.output <<  "#{id_heading}  Day                Start      End        Duration " << pay_lengthf % "Pay" << "\n"
      last_start = nil
      from_current_day = []
      spay = 0
      tpay = 0;
      sheets[sheet].each_with_index do |e, i|
        from_current_day << e
        pay = cpay.call(e.duration)
        spay += pay
        tpay += pay
        gpay += pay
        self.output <<  "%-4s%16s%11s -%9s%10s  %s\n" % [
          (Timetrap::CLI.args['-v'] ? e.id : ''),
          format_date_if_new(e.start, last_start),
          format_time(e.start),
          format_time(e.end),
          format_duration(e.duration),
          format_pay.call(pay)
        ]

        nxt = sheets[sheet].to_a[i+1]
        if nxt == nil or !same_day?(e.start, nxt.start)
          self.output <<  "%52s  %s\n" % [format_total(from_current_day), format_pay.call(spay)]
          spay = 0
          from_current_day = []
        else
        end
        last_start = e.start
      end
      self.output <<  "    %s\n" % ('-'*(50+pay_length))
      self.output <<  "    Total%43s  %s\n" % [format_total(sheets[sheet]), format_pay.call(tpay)]
      self.output <<  "\n" unless sheet == sheet_names.last
    end
    if sheets.size > 1
      self.output <<  "%s\n" % ('-'*(4+50+pay_length))
      self.output <<  "Grand Total%41s  %s\n" % [format_total(sheets.values.flatten), format_pay.call(gpay)]
    end
  end
end
