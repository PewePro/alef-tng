course = Course.where(name: 'Course One').first
if course
  course.update(name: 'PSI')
else
  course = Course.create!(name: 'PSI')
end

setup = Setup.create!(name: 'PSI 2015', first_week_at: '2015-02-18 00:00:00.00000', week_count: 0, course_id: course.id)

users = User.create!([
 {login: 'student1', role: User::ROLES[:STUDENT], first_name: 'Peter', last_name: 'Studentovic', password: 'student1', type: 'LocalUser'},
 {login: 'student2', role: User::ROLES[:STUDENT], first_name: 'Roman', last_name: 'Studentovic', password: 'student2', type: 'LocalUser'}
])



