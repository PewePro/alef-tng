module Stats
  class StatsComputer

    STATS_PROCESSORS = [ Processors::StudentActivity, ]

    #COLORS = { red: "FFB00000", green: "FF00B000" , yellow: "FFB0B000"}

    def self.save_stats(setup, filename, week)

      s = Axlsx::Package.new
      s.workbook do |workbook|
        splitter_styles = add_splitter_styles(workbook)   # styles from ALEF

        STATS_PROCESSORS.each do |sprocessor|
          workbook.add_worksheet(:name => sprocessor.sheetname) do |worksheet|

            (header, table) = sprocessor.process(setup, week)

            add_data(worksheet, splitter_styles, header, table)

          end
        end
      end

      s.serialize(filename)
    end

    private

    def self.add_splitter_styles(workbook)
      right_splitters = []
      workbook.styles do |s|
        right_splitters[0] =  s.add_style :border => { :style => :thick, :color =>"FF808080", :edges => [:right] }
        right_splitters[1] = s.add_style :border => { :style => :thick, :color => "FF000000", :edges => [:right]}
      end

      return right_splitters
    end

    def self.add_data(worksheet, splitters, header, table)
      # add data
      header = [header] unless header[0].is_a? Array

      (header + table).each do |row|
        worksheet.add_row row
      end

      # style columns
      style_vector = splitters

      style_vector.andand.each_with_index do |style, index|
        worksheet.col_style index, style if style
      end
    end

  end
end
