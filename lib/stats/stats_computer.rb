module Stats
  class StatsComputer

    STATS_PROCESSORS = [ Processors::StudentActivity, ]

    #COLORS = { red: "FFB00000", green: "FF00B000" , yellow: "FFB0B000"}

    def self.save_stats(setup, filename)

      s = Axlsx::Package.new
      s.workbook do |workbook|
        splitter_styles = add_splitter_styles(workbook)   # styles from ALEF

        STATS_PROCESSORS.each do |sprocessor|
          workbook.add_worksheet(:name => sprocessor.sheetname) do |worksheet|

            (header, table, splitter_columns, merge_cells) = sprocessor.process(setup)

            add_data(worksheet, splitter_styles, header, table, splitter_columns, merge_cells)
            freeze_split(worksheet, sprocessor.sheetsplit)

          end
        end
      end

      s.serialize(filename)
    end

    private

    # freezes 'worksheet' on 'where' (e.g. "D2")
    def self.freeze_split(worksheet, where)
      return unless where

      worksheet.sheet_view.pane do |pane|
        pane.top_left_cell = where
        pane.state = :frozen_split
        pane.x_split = where[/[A-Z]+/][0].ord - 'A'.ord
        pane.y_split = where[/[0-9]+/].to_i - 1
        pane.active_pane = :bottom_right
      end
    end

    def self.add_splitter_styles(workbook)
      right_splitters = []
      workbook.styles do |s|
        right_splitters[0] =  s.add_style :border => { :style => :thick, :color =>"FF808080", :edges => [:right] }
        right_splitters[1] = s.add_style :border => { :style => :thick, :color => "FF000000", :edges => [:right]}
      end

      return right_splitters
    end

    def self.add_data(worksheet, splitters, header, table, splitter_columns = nil, merge_cells = nil)
      # add data
      header = [header] unless header[0].is_a? Array

      (header + table).each do |row|
        worksheet.add_row row
      end

      # style columns
      style_vector = splitter_columns.andand.map do |x|
        if x.nil?
          nil
        else
          splitters[x]
        end
      end

      style_vector.andand.each_with_index do |style, index|
        worksheet.col_style index, style if style
      end

      # merge cells
      merge_cells.andand.each do |x1, y1, x2, y2|
        worksheet.merge_cells "#{Axlsx::cell_r(x1,y1)}:#{Axlsx::cell_r(x2,y2)}"
      end
    end

  end
end
