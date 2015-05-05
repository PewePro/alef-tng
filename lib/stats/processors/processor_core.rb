# encoding: utf-8
module Stats
  module Processors
    class ProcessorCore

      MAX_ROWS = 10000  # only for styling ranges, etc.

      ROUNDING = 2

      # stubs for when no sheet_name/sheet_comment is given in a stat processor
      def self.sheetname
        nil
      end

      def self.sheetcomment
        nil
      end

      def self.sheetsplit
        nil
      end

      def self.sheet_name(sheetname)
        create_method("sheetname", sheetname)
      end

      def self.sheet_comment(comment)
        create_method("sheetcomment", comment)
      end

      def self.sheet_split(split)
        create_method("sheetsplit", split)
      end

      private

      # stores *value* in class instance variable named *name* and creates/overrides acessor method *name*
      def self.create_method(name, value)
        class_eval(%Q{
          @#{name} = #{value.inspect}
          def self.#{name}
            @#{name}
          end
        })
      end

    end

  end

end
