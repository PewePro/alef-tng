require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# task which convert ALEF questions in docbook format to database
task :convert_ALEF_questions => :environment do

  files = Dir.glob("xml_files/**")
  files.each do |file|
    # Here the program become two:
    # One executes the block, other continues the loop
    fork do
      # open file
      @doc = Nokogiri::XML(File.open(file))
      question = @doc.at('//alef:question') #question_type

      if question['type'] == "single-choice"  || question['type'] == "multi-choice"
        description = @doc.at('//alef:description') #question_text
        #lo = LearningObject.create!( question_type: question['type'].to_s, question_text: description.content )

        @doc.xpath('*//alef:choice').each do |node|
          if node['correct'] == "true"
            node_bool = true
            puts "next is true"
          else
            node_bool = false
          end
          #Answer.create!( learning_object_id: lo.id, answer_text: node.content, is_correct: node_bool )
          puts node.content
        end

        puts description.content + ' ; ' + question['type']
      elsif question['type'] == "answer-validator"

        description = @doc.at('//alef:description') #question_text

        @doc.xpath('*//alef:answer').each do |node|
          #lo = LearningObject.create!( question_type: question['type'].to_s, question_text: description.content )

          if node['correct'] == "true"
            node_bool = true
            puts "next is true"
          else
            node_bool = false
          end
          #Answer.create!( learning_object_id: lo.id, answer_text: node.content, is_correct: node_bool )
          puts node.content
        end

        puts description.content + ' ; ' + question['type']

      end
    end
  end
  # We need to wait for all processes to get to this point
  # Before continue, because if the main program dies before
  # its children, they are killed immediately.
  Process.waitall
end

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
