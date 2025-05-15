ActiveRecord::Base.connection.execute('DELETE FROM classrooms_teachers')

Event.destroy_all
Schedule.destroy_all
Authorization.destroy_all
Occurrency.destroy_all
Orientation.destroy_all

User.destroy_all
Classroom.destroy_all

classroom_agro = Classroom.create!(
  name: '3º ano',
  grade: 'Ensino Médio Integrado',
  course: 'Técnico em Agropecuária',
  year: Date.current,
  external_id: 12_345
)

classroom_info = Classroom.create!(
  name: '3º ano',
  grade: 'Ensino Médio Integrado',
  course: 'Técnico em Informática',
  year: Date.current,
  external_id: 12_345
)

classroom_eletro = Classroom.create!(
  name: '3º ano',
  grade: 'Ensino Médio Integrado',
  course: 'Técnico em Eletroeletrônica',
  year: Date.current,
  external_id: 12_345
)

Classroom.create!(
  name: '2º ano',
  grade: 'Ensino Médio Integrado',
  course: 'Técnico em Agropecuária',
  year: Date.current,
  external_id: 12_345
)

Classroom.create!(
  name: '2º ano',
  grade: 'Ensino Médio Integrado',
  course: 'Técnico em Informática',
  year: Date.current,
  external_id: 12_345
)

Classroom.create!(
  name: '2º ano',
  grade: 'Ensino Médio Integrado',
  course: 'Técnico em Eletroeletrônica',
  year: Date.current,
  external_id: 12_345
)

Classroom.create!(
  name: '1º ano',
  grade: 'Ensino Médio Integrado',
  course: 'Técnico em Agropecuária',
  year: Date.current,
  external_id: 12_345
)

Classroom.create!(
  name: '1º ano',
  grade: 'Ensino Médio Integrado',
  course: 'Técnico em Informática',
  year: Date.current,
  external_id: 12_345
)

Classroom.create!(
  name: '1º ano',
  grade: 'Ensino Médio Integrado',
  course: 'Técnico em Eletroeletrônica',
  year: Date.current,
  external_id: 12_345
)

teacher_tiago = Teacher.create!(
  email: 'tiago@ifc.videira.com',
  password: 'password',
  name: 'Tiago Goncalves',
  document: '123456789',
  extra_info: { external_id: 987 }
)

teacher_fabio = Teacher.create!(
  email: 'fabio@ifc.videira.com',
  password: 'password',
  name: 'Fabio Pinheiro',
  document: '123456789',
  extra_info: { external_id: 987 }
)

teacher_wesley = Teacher.create!(
  email: 'wesley@ifc.videira.com',
  password: 'password',
  name: 'Wesley Bortoloso',
  document: '123456789',
  extra_info: { external_id: 987 }
)

classroom_agro.teachers << teacher_tiago
classroom_info.teachers << teacher_fabio
classroom_eletro.teachers << teacher_wesley

psychologist = Staff.create!(
  name: "Psicólogo Pedro",
  email: "psi@example.com",
  document: "22222222222",
  password: "123456",
  role: :psychologist
)

manager = Staff.create!(
  name: "Gestor Carla",
  email: "gestor@example.com",
  document: "33333333333",
  password: "123456",
  role: :manager
)

server = Staff.create!(
  name: "Servidor Lucas",
  email: "servidor@example.com",
  document: "44444444444",
  password: "123456",
  role: :server
)

student_wesley = Student.create!(
  email: 'wesleyaluno@ifc.videira.com',
  password: 'password',
  name: 'Wesley Aluno',
  document: '111222333',
  extra_info: { enrollment: 'STU123', external_id: 555, situation: 'active' },
  classroom: classroom_agro
)

student_bruno = Student.create!(
  email: 'brunoaluno@ifc.videira.com',
  password: 'password',
  name: 'Bruno Aluno',
  document: '111222333',
  extra_info: { enrollment: 'STU123', external_id: 555, situation: 'active' },
  classroom: classroom_info
)

student_felipe = Student.create!(
  email: 'felipealuno@ifc.videira.com',
  password: 'password',
  name: 'Felipe Aluno',
  document: '111222333',
  extra_info: { enrollment: 'STU123', external_id: 555, situation: 'active' },
  classroom: classroom_eletro
)

parent_wesley = Parent.create!(
  email: 'paiwesley@example.com',
  password: 'password',
  name: 'Pai Wesley',
  document: '444555666'
)

parent_bruno = Parent.create!(
  email: 'paibruno@example.com',
  password: 'password',
  name: 'Pai Bruno',
  document: '444555666'
)

student_wesley.update(parent: parent_wesley)
student_bruno.update(parent: parent_bruno)

occ_public_teacher = Occurrency.create!(
  title: "Indisciplina em sala",
  description: "Aluno interrompe aula",
  kind: :discipline,
  severity: :medium,
  status: :open,
  student: student_felipe,
  relator: teacher_tiago,
  responsible: teacher_fabio,
  private: false
)

occ_private_psi = Occurrency.create!(
  title: "Acompanhamento psicológico",
  description: "Discussão sobre ansiedade",
  kind: :health,
  severity: :high,
  status: :open,
  student: student_wesley,
  relator: psychologist,
  responsible: psychologist,
  private: true
)

orientation = Orientation.create!(
  title: 'Acompanhamento com as tarefas',
  description: 'É necessário acompanhar o aluno nas tarefas diárias',
  area: 'academic',
  status: 'open',
  student: student_bruno,
  parent: parent_bruno,
  relator: server,
  responsible: teacher_tiago
)

Authorization.create!(
  date: Date.current,
  description: 'Field Trip Approval',
  status: 'pending',
  student: student_wesley,
  parent: parent_wesley
)

Schedule.create!(
  starts_at: Date.tomorrow.beginning_of_day + 15.hours,
  subject: 'Encontro com o pai',
  area: 'academic',
  status: 'waiting',
  student: student_bruno,
  parent: parent_bruno,
  relator: server
)

Announcement.create!(
  title: "Reunião com responsáveis",
  content: "Haverá uma reunião com os pais e responsáveis no dia 15/05 às 19h no auditório.",
  date: Date.new(2025, 5, 15)
)

Announcement.create!(
  title: "Semana de provas",
  content: "As provas do 2º bimestre começam na próxima segunda-feira. Fiquem atentos ao cronograma.",
  date: Date.new(2025, 5, 13)
)

Announcement.create!(
  title: "Atenção ao uso dos laboratórios",
  content: "Por favor, garantir que todos os equipamentos estejam desligados após o uso.",
  date: Date.new(2025, 5, 12)
)

tea = Condition.find_or_create_by!(name: 'TEA', category: 'special_need')
defi = Condition.find_or_create_by!(name: 'Deficiência Visual', category: 'special_need')
bols = Condition.find_or_create_by!(name: 'Bolsa 100%', category: 'scholarship')
Condition.find_or_create_by!(name: 'Bolsa Transporte', category: 'scholarship')

student_bruno.conditions << tea
student_felipe.conditions << defi


Rails.logger.debug('Seeds created successfully!')
