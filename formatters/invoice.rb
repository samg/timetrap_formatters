module Timetrap
  module Formatters
    class Timetrap::Formatters::Invoice
      def initialize(entries)
        @company  = escape_for_latex(Timetrap::Config['company']) || 'INSERT COMPANY'
        @address1 = escape_for_latex(Timetrap::Config['address1']) || 'ADDRESS 1'
        @address2 = escape_for_latex(Timetrap::Config['address2']) || 'ADDRESS 2'
        @phone    = escape_for_latex(Timetrap::Config['phone']) || 'PHONE'
        @email    = escape_for_latex(Timetrap::Config['email']) || 'EMAIL'
        @rate     = Timetrap::Config['rate'] || '50.00'

        @events  = entries.inject({}) do |h, e|
          @report_start ||= e.start
          @report_start = e.start if e.start < @report_start

          @report_end ||= e.end_or_now
          @report_end = e.end_or_now if e.end_or_now > @report_end

          sheet = escape_for_latex(e.sheet)
          note  = escape_for_latex(e.note)
          start = e.start.strftime("%d/%m/%Y")

          h[sheet] ||= {}
          h[sheet][start] ||= {}
          h[sheet][start][note] ||= 0
          h[sheet][start][note] += e.duration

          h
        end
      end

      def output
        puts header
        (@events.keys.sort).each do |sheet|
          puts '\\large \feetype{%s}' % [sheet.upcase] unless 1 == @events.keys.length

          dates = @events[sheet].keys.sort_by { |date| d,m,y = date.split('/'); [y,m,d] }

          dates.each do |date|
            puts '\feetype{\emph{%s}}' % [Time.parse(date).strftime("%B %d, %Y")]
            notes = @events[sheet][date].keys.sort

            notes.each do |note|
              puts '\\tab \hourrow{%s}{%.2f}' % [note, (@events[sheet][date][note]) / 3600.0]
            end
          end

          puts '\subtotal'
        end
        puts footer
      end

      protected
      def header
        <<-END.gsub(/^ {10}/, '')
          \\documentclass{invoice}

          \\def \\tab {\\hspace*{3ex}}

          \\begin{document}

          \\hfil{\\Huge\\bf #{@company}}\\hfil
          \\bigskip\\break
          \\hrule
          #{@address1} \\hfill #{@phone} \\\\
          #{@address2} \\hfill #{@email} \\\\

          {\\bf Date:} \\today \\hfill {\\bf Invoice Date:} #{@report_start.strftime("%B %d, %Y")} --- #{@report_end.strftime("%B %d, %Y")} \\\\

          {\\bf Invoice To:} \\\\
          \\tab INSERT CONTACT \\\\
          \\tab INSERT COMPANY \\\\

          \\hourlyrate{#{@rate}}

          \\begin{invoiceTable}
        END
      end

      def footer
        <<-END.gsub(/^ {10}/, '')
          \\end{invoiceTable}

          \\end{document}
        END
      end

      def escape_for_latex value
        replacements = [ ['\\', '\textbackslash'], ['~', '\textasciitilde'], ['#', '\\#']]
        replacements.each { |replacement| value.sub!(replacement[0], replacement[1]) }
        value
      end
    end
  end
end
