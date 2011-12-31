module Timetrap
  module Formatters
    require File.join( 'formatters', 'text' )

    class Factor < Text
      def initialize entries
        entries.map! do |e|
          factor = 1
          if e.note =~ /\bf(actor)?:([\d\.]+)\b/
            factor = $2.to_f + 2
          end
          e.duration = (e.end_or_now.to_i - e.start.to_i) * factor
          e
        end
        super
      end
    end
  end
end
