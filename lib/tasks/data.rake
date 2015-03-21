require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pandoc-ruby'

# task which convert ALEF questions from docbook format to markdown format
# and save them into database
# run it this way -> rake convert_ALEF_questions["path_to_directory_with_xml_files"]
#namespace :old_alef do
 task :convert_ALEF_questions, [:directory] => :environment do |t, args|

  directory = args.directory + "/**"

  files = Dir.glob(directory)
  files.each do |file|

    puts "-------------------"
    # open file
    @doc = Nokogiri::XML(File.open(file))
    question = @doc.at('//alef:question') #question_type

    if question['type'] == "single-choice"  || question['type'] == "multi-choice"
      description = @doc.at('//alef:description') #question_text

      @converted_description = PandocRuby.new(description.content, :from => :docbook, :to => :markdown)
      #puts @converted_description.convert

      lo = LearningObject.create!( question_type: question['type'].to_s, question_text: @converted_description.convert )

      @doc.xpath('*//alef:choice').each do |node|
        if node['correct'] == "true"
          correct_answer = true
        else
          correct_answer = false
        end

        @converted_answer = PandocRuby.new(node.content, :from => :docbook, :to => :markdown)
        #puts @converted_answer.convert
        #puts "***"

        Answer.create!( learning_object_id: lo.id, answer_text: @converted_answer.convert, is_correct: correct_answer )
        #puts node.content
      end

      #puts description.content + ' ; ' + question['type']

    elsif question['type'] == "answer-validator"

      description = @doc.at('//alef:description') #question_text

      @doc.xpath('*//alef:answer').each do |node|

        @converted_description = PandocRuby.new(description.content, :from => :docbook, :to => :markdown)
        #puts @converted_description.convert

        lo = LearningObject.create!( question_type: question['type'].to_s, question_text: @converted_description.convert )

        @converted_answer = PandocRuby.new(node.content, :from => :docbook, :to => :markdown)
        #puts @converted_answer.convert
        #puts "***"

        Answer.create!( learning_object_id: lo.id, answer_text: @converted_answer.convert )
        #puts node.content
      end

      #puts description.content + ' ; ' + question['type']

    end
  end
 end
#end