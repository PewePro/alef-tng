course = Course.create!(name: 'PSI')

setup = Setup.create!(name: 'PSI 2015', first_week_at: '2015-09-21 00:00:00.00000', week_count: 12, course_id: course.id)

weeks = Week.create!([
  {setup_id: setup.id, number: 1},
  {setup_id: setup.id, number: 2},
  {setup_id: setup.id, number: 3},
  {setup_id: setup.id, number: 4},
])

concepts = Concept.create!([
  {course_id: course.id, pseudo: false, name: 'Diagram prípadov použitia'},
  {course_id: course.id, pseudo: false, name: 'Diagram toku údajov'},
  {course_id: course.id, pseudo: false, name: 'Softvérové inžinierstvo'},
  {course_id: course.id, pseudo: false, name: 'Diagram aktivít'}
])

weeks[0].concepts << [concepts[0],concepts[1]]
weeks[1].concepts << [concepts[2],concepts[1]]
weeks[2].concepts << [concepts[3],concepts[1],concepts[0]]
weeks[3].concepts << [concepts[3]]

users = User.create!([
  {login: 'student1', role: User::ROLES[:STUDENT], first_name: 'Peter', last_name: 'Studentovic', password: 'student1', type: 'LocalUser'},
  {login: 'student2', role: User::ROLES[:STUDENT], first_name: 'Roman', last_name: 'Studentovic', password: 'student2', type: 'LocalUser'},
  {login: 'teacher1', role: User::ROLES[:TEACHER], first_name: 'Fero', last_name: 'Ucitelovic', password: 'teacher1', type: 'LocalUser'},
  {login: 'administrator1', role: User::ROLES[:ADMINISTRATOR], first_name: 'Lubos', last_name: 'Adminovic', password: 'administrator1', type: 'LocalUser'},
  {login: 'xpriezvisko', aisid: 12345, role: User::ROLES[:STUDENT], first_name: 'Igor', last_name: 'AISovic', password: '', type: 'LdapUser'}
])

SetupsUser.create!([
      {setup_id: setup.id, user_id: users[0].id, is_valid: true, is_tracked: true},
      {setup_id: setup.id, user_id: users[1].id, is_valid: true, is_tracked: true},
      {setup_id: setup.id, user_id: users[2].id, is_valid: true, is_tracked: true}
])

single_choice_questions = SingleChoiceQuestion.create!([
  {lo_id: 'Výber jazyka 1', question_text: 'Aké základné otázky si kladie manažér pri výbere programovacieho jazyka pre projekt?'},
  {lo_id: 'Diagram toku údajov 1', question_text: 'Akou technikou si pomáhame pri riešení problému zložitosti pri diagramoch tokov údajov?'},
  {lo_id: 'Testovanie 1', question_text: 'Aký je rozdiel medzi technikami testovania čierna skrinka (black-box) a biela skrinka (white-box) testovaním?'},
  {lo_id: 'UML diagram 1', question_text: 'Aký UML diagram je zobrazený na obrázku? (uveďte slovenský aj anglický názov diagramu) '}
])

multi_choice_questions = MultiChoiceQuestion.create!([
  {lo_id: 'Modelovanie softvéru 4', question_text: 'Model na obrázku prestavuje:'},
  {lo_id: 'Údržba a ďalší vývoj softvéru', question_text: 'Vyznač čo platí:'},
  {lo_id: 'Verifikácia a validácia', question_text: 'Cieľom verifikácie a validácie je mimo iného preukázanie požadovaných vlastností, ako sú správnosť, spoľahlivosť, efektívnosť, prenosnosť, bezpečnosť a ďalšie. Čo sa však týka samotnej správnosti:'},
  {lo_id: 'Štrukturálne testovanie 1', question_text: 'Čo platí o štrukturálnom testovaní?'}
])

evaluator_questions = EvaluatorQuestion.create!([
  {lo_id: 'Výber jazyka 2', question_text: 'Cena vývojového prostredia je jedna zo základných otázok rozhodovania manažéra.'},
  {lo_id: 'Diagram prípadov použitia 2', question_text: 'Digram prípadu použitia predstavuje dynamický model.'},
  {lo_id: 'Testovanie 2', question_text: 'Štrukturálne testovanie vychádza zo štruktúry programu'},
  {lo_id: 'Verifikácia a validácia 2', question_text: 'Cieľom verifikácie je preukázanie platnosti vlastností programu.'}
])

answers = Answer.create!([
  {learning_object_id: single_choice_questions[0].id, answer_text: 'ci jazyk bude vyhovovat zlozitosti navrhu, ci sa mu bude dat lahko porozumiet ak v nom budeme implementovat, ci bude vyhovovat zakaznikovi, ci jazyk obsahuje tie prvky ktore manazer potrebuje', is_correct: true},
  {learning_object_id: single_choice_questions[0].id, answer_text: 'skusenosti programatora, vhodnost jazyka pre aplikaciu, rozsah, rozsirenost,  poziadavky pre zakaznika, pouzitelnost, existujuce kniznice, cena, buduca  strategia - dolezite pre udrzbu systemu', is_correct: false},
  {learning_object_id: single_choice_questions[0].id, answer_text: 'cena vyvojoveho prostredia  - dostupnost kniznic pre dany programovaci jazyk  - poziadavky zakaznika  - orientovanie programatora v danom prog. jakyku  - vynalozeny cas na spravenie projektu v tomto prog. jazyku  - vykonnost programovacieho jazyka  - produktivita prog. jazyka', is_correct: false},
  {learning_object_id: single_choice_questions[1].id, answer_text: 'Brainstorming, interview,  metoda DELPHI', is_correct: true},
  {learning_object_id: single_choice_questions[1].id, answer_text: 'Rozdelenie na viacero urovni. Alebo rozdelenie na mensie casti tokov udajov', is_correct: false},
  {learning_object_id: single_choice_questions[1].id, answer_text: 'pouzivame metodu delphi, brainstorming a Interwiev', is_correct: false},
  {learning_object_id: single_choice_questions[2].id, answer_text: 'cierna skrinka - testovanie na zaklade vstupov a vystupov - nevidime vnutro programu, ako to prebieha  biela skrinka - pri testovani mozeme vidiet okrem vstupov a vystupov vnutro programu, co a ako prebie', is_correct: true},
  {learning_object_id: single_choice_questions[2].id, answer_text: 'cierna skrinka - testuje sa iba funkcionalne, t.j. vstupy a vystupy programu white box - testuje sa strukturalne, t.j. implementacia programu', is_correct: false},
  {learning_object_id: single_choice_questions[2].id, answer_text: 'cierna skrinka - funkcionalne testovanie - testuje sa ci system splna pozadovane funkcie biela skrinka - strukturalne testovanie - zamerane na riadenie a udaje v systeme - na zaklade zdrojovych kodov', is_correct: false},
  {learning_object_id: single_choice_questions[3].id, answer_text: 'model pripadov pouzitia', is_correct: true},
  {learning_object_id: single_choice_questions[3].id, answer_text: 'diagram toku údajov', is_correct: false},
  {learning_object_id: single_choice_questions[3].id, answer_text: 'diagram činností', is_correct: false},
  {learning_object_id: multi_choice_questions[0].id, answer_text: 'dynamický model', is_correct: true},
  {learning_object_id: multi_choice_questions[0].id, answer_text: 'statický model', is_correct: false},
  {learning_object_id: multi_choice_questions[1].id, answer_text: 'Etapy procesu údržby sú: identifikácia problému alebo požiadavka na zmenu, analýza, návrh, implementácia, regresné testovanie, akceptačné testovanie a odovzdanie.', is_correct: true},
  {learning_object_id: multi_choice_questions[1].id, answer_text: 'Riadenie údržby je dôležité. Zmeny musia byť dokumentované, prebieha analýza a plánovanie', is_correct: false},
  {learning_object_id: multi_choice_questions[1].id, answer_text: 'Reštrukturalizácia dokáže upratať neštrukturalizovaný nemodulárny neporiadok na štruktúrovaný modulárny systém.', is_correct: false},
  {learning_object_id: multi_choice_questions[2].id, answer_text: 'správnosť je nevyhnutná a postačuje', is_correct: true},
  {learning_object_id: multi_choice_questions[2].id, answer_text: 'správnosť je nevyhnutná, no sama o sebe nepostačuje', is_correct: true},
  {learning_object_id: multi_choice_questions[2].id, answer_text: 'správnosť nie je nevyhnutná a nepostačuje', is_correct: true},
  {learning_object_id: multi_choice_questions[3].id, answer_text: 'Ide o druh dynamického testovania, preto sa vyžaduje vykonanie programu.', is_correct: true},
  {learning_object_id: multi_choice_questions[3].id, answer_text: 'Matematická verifikácia, ktorá využíva znalosť štruktúry programu, je jedným z typov štrukturálneho testovania.', is_correct: false},
  {learning_object_id: multi_choice_questions[3].id, answer_text: 'Vychádza sa z vnútornej štruktúry programu.', is_correct: true}
])

single_choice_questions[0].concepts << [concepts[1],concepts[2]]
single_choice_questions[1].concepts << [concepts[3],concepts[1]]
single_choice_questions[2].concepts << [concepts[0],concepts[1],concepts[3]]
single_choice_questions[3].concepts << [concepts[2]]
multi_choice_questions[0].concepts << [concepts[3],concepts[1]]
multi_choice_questions[1].concepts << [concepts[3],concepts[1]]
multi_choice_questions[2].concepts << [concepts[2],concepts[1],concepts[0]]
multi_choice_questions[3].concepts << [concepts[0]]
evaluator_questions[0].concepts << [concepts[0],concepts[1]]
evaluator_questions[1].concepts << [concepts[0],concepts[2]]
evaluator_questions[2].concepts << [concepts[2],concepts[1],concepts[0]]
evaluator_questions[3].concepts << [concepts[2]]

UserVisitedLoRelation.create!([
  {setup_id: setup.id, user_id: users[0].id, learning_object_id: single_choice_questions[0].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[0].id, learning_object_id: single_choice_questions[1].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[0].id, learning_object_id: single_choice_questions[1].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[0].id, learning_object_id: single_choice_questions[2].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[0].id, learning_object_id: multi_choice_questions[0].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[0].id, learning_object_id: multi_choice_questions[1].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[0].id, learning_object_id: evaluator_questions[3].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[1].id, learning_object_id: single_choice_questions[0].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[1].id, learning_object_id: single_choice_questions[1].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[1].id, learning_object_id: single_choice_questions[2].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[1].id, learning_object_id: single_choice_questions[2].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[1].id, learning_object_id: multi_choice_questions[3].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[1].id, learning_object_id: multi_choice_questions[1].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[1].id, learning_object_id: evaluator_questions[2].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[2].id, learning_object_id: single_choice_questions[2].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[2].id, learning_object_id: single_choice_questions[3].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[2].id, learning_object_id: single_choice_questions[1].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[2].id, learning_object_id: multi_choice_questions[2].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[2].id, learning_object_id: multi_choice_questions[1].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[2].id, learning_object_id: evaluator_questions[3].id, interaction: '??'},
  {setup_id: setup.id, user_id: users[2].id, learning_object_id: evaluator_questions[3].id, interaction: '??'}
])