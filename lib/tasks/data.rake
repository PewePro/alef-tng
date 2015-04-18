require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pandoc-ruby'
require 'csv'

namespace :alef do
  namespace :data do
    # import questions from ALEF docbook environment
    # run:
    #   rake alef:data:import_xml['xml_dir']
    task :import_xml, [:directory] => :environment do |t, args|
      directory = args.directory + "/**"

      files = Dir.glob(directory)
      files.each do |file|
        # open file
        @doc = Nokogiri::XML(File.open(file))
        question = @doc.at('//alef:question') #question_type

        if question['type'] == "single-choice"
          question_type = "SingleChoiceQuestion"
        elsif question['type'] == "multi-choice"
          question_type = "MultiChoiceQuestion"
        elsif question['type'] == "answer-validator"
          question_type = "EvaluatorQuestion"
        end

        if question_type == "SingleChoiceQuestion"  || question_type == "MultiChoiceQuestion"
          description = @doc.at('//alef:description') #question_text

          @converted_description = PandocRuby.new(description.content, :from => :docbook, :to => :markdown)
          #puts @converted_description.convert

          lo = LearningObject.create!( type: question_type, question_text: @converted_description.convert )

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

        elsif question_type == "EvaluatorQuestion"

          description = @doc.at('//alef:description') #question_text

          @doc.xpath('*//alef:answer').each do |node|

            @converted_description = PandocRuby.new(description.content, :from => :docbook, :to => :markdown)
            #puts @converted_description.convert

            lo = LearningObject.create!( type: question_type, question_text: @converted_description.convert )

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

    ## ---------------------------------------------------------------------------------
    ## CSV IMPORT
    ## ---------------------------------------------------------------------------------
    IMPORTED_QUESTION_TYPES = {
        'single-choice' => 'SingleChoiceQuestion',
        'multi-choice' => 'MultiChoiceQuestion',
        'answer-validator' => 'EvaluatorQuestion',
        'complement' => 'Complement'
    }

    def convert_format(source_string, is_answer = false)
      is_answer ? source_string.gsub('<correct>|</correct>','') : source_string
    end

    def import_concepts(concepts_string,learning_object)
      if concepts_string.nil? || concepts_string.empty?
        puts "WARNING: '#{learning_object.external_reference}' - '#{learning_object.lo_id}' has no concepts"
        concepts_string = Concept::DUMMY_CONCEPT_NAME
      end

      concept_names = concepts_string.split(',').map{|x| x.strip}
      concept_names.each do |concept_name|
        concept = Concept.find_or_create_by(name: concept_name) do |c|
          c.course = Course.first
          c.pseudo = (concept_name == Concept::DUMMY_CONCEPT_NAME)
        end
        learning_object.link_concept(concept)
      end

      learning_object.concepts.delete(learning_object.concepts.where.not(name: concept_names))
    end

    def import_pictures(picture, pictures_dir, lo)
      picture = picture.split('/').last

      begin
        image = File.read(pictures_dir + '/' + picture)
        LearningObject.where(id: lo.id).update_all(image: image)
      rescue Errno::ENOENT => ex
        puts "IMAGE MISSING: #{picture}"
        raise
      end
    end

    # CSV structure
    # 0    1                     2                                    3                    4
    # ID,  Obrazok,              Nazov,                               Kategoria,           Do nultej verzie,
    # 510, resources/q-001pl.png, Hrany v diagrame prípadov použitia, funkcionalne_modely, y,
    # 5                 6                                 7                       8
    # Otazka,           Koncepty,                         Kapitola,               Subkapitola,
    # "Akého typu...?", "UML, diagram prípadov použitia", 07 Funkcionálne modely, 07.01 Model a diagram prípadov použitia,
    # 9              10               11
    # Typ otazky,    Spravna odpoved, "Moznosti, ak boli k dispozicii",
    # single-choice, extend;,         asociácia;<correct>extend</correct>;uses;dedenie;use;include;,
    # 12                                                     13
    # Obtiaznost (impossible/tazke/stredne/lahke/trivialne), XML
    # ,                                                      questions/psi-op-q-006pl.xml
    def import_choice_questions(file, pictures_dir)
      CSV.read(file, :headers => false).each do |row|
        external_reference = row[0]
        picture = row[1]
        question_name = row[2] || ''
        zero_version = row[4]
        question_text = convert_format(row[5])
        concept_names = row[6]
        question_type = IMPORTED_QUESTION_TYPES[row[9]]
        answers = row[11]

        # import only tagged questions
        next unless zero_version == 'y'

        lo = LearningObject.find_or_create_by(external_reference: external_reference)
        lo.update( type: question_type, lo_id: question_name, question_text: question_text )

        # TODO import answers when updating existing LO, not only upon first creation
        # ^NOTE: answer ID should be preserved whenever possible for logged relations
        if lo.answers.empty?
          answers.split(';').each do |answer|
            correct_answer = answer.include? '<correct>'
            answer_text = convert_format(answer, true)
            Answer.create!( learning_object_id: lo.id, answer_text: answer_text, is_correct: correct_answer )
          end
        end

        import_concepts(concept_names, lo)
        import_pictures(picture, pictures_dir, lo) if picture
      end
    end

    # CSV structure:
    # 0           1           2                 3           4                  5
    # ID Otazka,  ID odpoved, Do nultej verzie, Vybrať (Y), Nazvova kategoria, Nazov (specificky),
    # 1072799564, 10,         y,                Y,          diagram,           Určovanie typu diagramu,
    # 6                                          7
    # Koncepty,                                  Obtiaznost (impossible/tazke/stredne/lahke/trivialne),
    # "UML,štruktúrny diagram,diagram objektov", lahke,
    # 8               9
    # Otazka,         Image url,
    # Aký diagram..., http://alef.fiit.stuba.sk/learning_objects/resources/pic-psi-sg-q-0.png,
    # 10
    # Odpoved,
    # Object diagram (Objektovy diagram) Patri do UML.
    def import_qalo_questions(file, pictures_dir)
      CSV.read(file, :headers => false).each do |row|
        external_reference = "#{row[0]}:#{row[1]}"
        zero_version = row[2]
        question_name = row[5] || ''
        concept_names = row[6]
        question_text = convert_format(row[8])
        picture = row[9]
        answer_text = convert_format(row[10], true)
        question_type = 'EvaluatorQuestion'

        # import only tagged questions
        next unless zero_version == 'y'

        lo = LearningObject.find_or_create_by(external_reference: external_reference)
        lo.update(type: question_type, lo_id: question_name, question_text: question_text)

        Answer.find_or_create_by(learning_object_id: lo.id).update(answer_text: answer_text)

        import_concepts(concept_names, lo)
        import_pictures(picture, pictures_dir, lo) if picture
      end
    end

    # import questions from CSV files
    # run:
    #    rake alef:data:import_csv["QALO.csv","choices.csv","img_dir"]
    task :import_csv, [:qalo_csv, :choice_csv, :img_dir] => :environment do |t, args|
      import_choice_questions(args.choice_csv, args.img_dir)
      import_qalo_questions(args.qalo_csv, args.img_dir)
    end
  end
end
