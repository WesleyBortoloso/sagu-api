ActiveRecord::Base.connection.execute('DELETE FROM classrooms_teachers')

Event.destroy_all
Schedule.destroy_all
Authorization.destroy_all
Occurrency.destroy_all
Orientation.destroy_all

User.destroy_all
Classroom.destroy_all
classroom = Classroom.create!(
  name: 'Math 101',
  grade: '10th Grade',
  year: Date.current,
  external_id: 12_345
)

teacher = Teacher.create!(
  email: 'teacher@example.com',
  password: 'password',
  name: 'Jane Doe',
  document: '123456789',
  extra_info: { external_id: 987 }
)

classroom.teachers << teacher

staff = Staff.create!(
  email: 'staff@example.com',
  password: 'password',
  name: 'John Smith',
  document: '987654321',
  extra_info: { role: 'Coordinator', department: 'Science' }
)

student = Student.create!(
  email: 'student@example.com',
  password: 'password',
  name: 'Alice Student',
  document: '111222333',
  extra_info: { enrollment: 'STU123', external_id: 555, situation: 'active' },
  classroom: classroom
)

parent = Parent.create!(
  email: 'parent@example.com',
  password: 'password',
  name: 'Bob Parent',
  document: '444555666'
)

occurrency = Occurrency.create!(
  title: 'Disciplinary Issue',
  description: 'Student was disruptive',
  kind: 0,
  status: 0,
  severity: 1,
  student: student,
  relator: teacher,
  responsible: staff
)

orientation = Orientation.create!(
  title: 'Academic Guidance',
  description: 'Discussed academic performance',
  area: 'Counseling',
  status: 'Scheduled',
  student: student,
  parent: parent,
  relator: staff,
  responsible: teacher
)

Authorization.create!(
  date: Date.current,
  description: 'Field Trip Approval',
  status: 1,
  student: student,
  parent: parent
)

Schedule.create!(
  starts_at: Date.tomorrow,
  subject: 'Parent Meeting',
  area: 1,
  status: 0,
  student: student,
  parent: parent,
  relator: staff
)

Event.create!(
  description: 'Occurrency opened',
  eventable: occurrency,
  author: teacher,
  metadata: { action: 'opened', severity: 'low' }
)

Event.create!(
  description: 'Orientation scheduled',
  eventable: orientation,
  author: staff,
  metadata: { scheduled_for: Date.tomorrow }
)

Rails.logger.debug('Seeds created successfully!')
