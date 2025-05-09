class Student::GenerateReport < BaseInteraction
  attr_reader :student

  def call
    fetch_student!
    generate_pdf!
    attach_report!
    student
  end

  private

  def fetch_student!
    @student = Student.includes(:occurrencies, :orientations, :conditions).find(params[:student_id])
  rescue ActiveRecord::RecordNotFound
    error!({ error: 'Student not found', detail: "ID #{params[:student_id]} is invalid" }, 404)
  end

  def attach_report!
    io = StringIO.new(@pdf_content.dup)
    io.set_encoding('BINARY') if io.respond_to?(:set_encoding)
    io.rewind

    student.report_file.attach(
      io: io,
      filename: "relatorio_aluno_#{student.id}.pdf",
      content_type: 'application/pdf'
    )

    raise ActiveStorage::IntegrityError, "Erro ao anexar o PDF do relatório" unless student.report_file.attached?
  end

  def generate_pdf!
    logo_path = Rails.root.join("public/logo_sagu_extended.png")
    font_path = Rails.root.join("public/fonts")
  
    pdf = Prawn::Document.new(top_margin: 80, bottom_margin: 50)
  
    pdf.font_families.update(
      "Nunito" => {
        normal: font_path.join("Nunito-Regular.ttf"),
        bold: font_path.join("Nunito-Bold.ttf"),
        italic: font_path.join("Nunito-Italic.ttf")
      }
    )
    pdf.font "Nunito"
  
    pdf.image logo_path, width: 250, position: :center
  
    pdf.fill_color "14532D"
    pdf.text "Relatório do Estudante", size: 28, style: :bold, align: :center
    pdf.fill_color "000000"
    pdf.move_down 40
  
    pdf.text "Nome do Estudante", size: 12, style: :bold, align: :center
    pdf.text student.name, size: 11, align: :center
    pdf.move_down 20
  
    pdf.text "Matrícula", size: 12, style: :bold, align: :center
    pdf.text student.enrollment || "-", size: 11, align: :center
    pdf.move_down 20
  
    pdf.text "Situação", size: 12, style: :bold, align: :center
    pdf.text student.situation&.humanize || "-", size: 11, align: :center
    pdf.move_down 120
  
    pdf.text "Emitido em: #{Time.zone.now.strftime("%d de %B de %Y")}", size: 10, align: :center, style: :italic
  
    pdf.start_new_page
    render_student_info_card(pdf)
  
    render_section(pdf, "Ocorrências", %w[Data Título Descrição Status], student.occurrencies.map { |o|
      [o.created_at.strftime("%d/%m/%Y"), o.title, o.description.truncate(50), o.status]
    })
  
    render_section(pdf, "Orientações", %w[Data Título Área Status], student.orientations.map { |o|
      [o.created_at.strftime("%d/%m/%Y"), o.title, o.area, o.status]
    })
  
    render_section(pdf, "Atendimentos", %w[Data Assunto Área Status], student.schedules.map { |s|
      [s.starts_at.strftime("%d/%m/%Y %H:%M"), s.subject, s.area, s.status]
    })
  
    render_section(pdf, "Autorizações", %w[Data Descrição Status], student.authorizations.map { |a|
      [a.date.strftime("%d/%m/%Y"), a.description, a.status]
    })
  
    render_section(pdf, "Condições Especiais", %w[Nome Categoria], student.conditions.map { |c|
      [c.name, c.category]
    })
  
    pdf.number_pages "Página <page> de <total>", at: [pdf.bounds.right - 100, 0], size: 9
    pdf.draw_text "Gerado em: #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", at: [0, 0], size: 9
  
    @pdf_content = pdf.render
  end

  def render_section(pdf, title, headers, rows)
    return if rows.empty?

    pdf.move_down 30
    pdf.fill_color "14532D"
    pdf.text title, size: 14, style: :bold, align: :center
    pdf.fill_color "000000"
    pdf.move_down 6

    pdf.stroke_color "22C55E"
    pdf.stroke_horizontal_rule
    pdf.move_down 12

    table_data = [headers] + rows

    pdf.table(table_data,
      header: true,
      width: pdf.bounds.width,
      cell_style: {
        size: 9,
        padding: [6, 4, 6, 4],
        borders: []
      },
      row_colors: ["F9FAFB", "FFFFFF"]
    ) do
      row(0).font_style = :bold
      row(0).background_color = "F3F4F6"
      row(0).borders = [:bottom]
      row(0).border_width = 1
      row(0).border_color = "E5E7EB"
    end
  end
  

  def render_section_title(pdf, title)
    pdf.move_down 20
    pdf.fill_color "14532D"
    pdf.text title, size: 12, style: :bold
    pdf.stroke_color "22C55E"
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    pdf.fill_color "000000"
  end

  def render_table_section(pdf, title, headers, rows, title_color, header_bg, row_alt)
    return if rows.empty?
  
    pdf.move_down 20
    pdf.text title, size: 12, style: :bold, color: title_color
    pdf.move_down 8
  
    pdf.table([headers] + rows, header: true, width: pdf.bounds.width,
      cell_style: { size: 9, padding: [6, 4, 6, 4] },
      row_colors: [row_alt, "FFFFFF"]) do
        row(0).font_style = :bold
        row(0).background_color = header_bg
    end
  end

  def render_student_info_card(pdf)
    pdf.move_down 20
    pdf.fill_color "14532D"
    pdf.text "Informações Gerais do Estudante", size: 14, style: :bold, align: :center
    pdf.stroke_color "22C55E"
    pdf.stroke_horizontal_rule
    pdf.move_down 12
    pdf.fill_color "000000"
  
    pdf.bounding_box([pdf.bounds.left, pdf.cursor], width: pdf.bounds.width) do
      pdf.stroke_color "D1D5DB"
      pdf.stroke_bounds
      pdf.move_down 12
  
      data = [
        ["Nome:", student.name],
        ["Matrícula:", student.enrollment],
        ["Situação:", student.situation&.humanize],
        ["Sala:", student.classroom&.name ? "#{student.classroom.name} (#{student.classroom.grade} - #{student.classroom.year.year})" : "-"],
        ["Responsável:", student.parent&.name || "-"],
        ["CPF:", student.document],
        ["Email:", student.email],
        ["Gênero:", student.gender&.capitalize || "-"],
        ["Nascimento:", student.birthdate&.strftime("%d/%m/%Y") || "-"],
        ["Necessidades Especiais:", student.special_needs.any? ? student.special_needs.map(&:name).join(", ") : "-"]
      ]
  
      left_col, right_col = data.each_slice((data.size / 2.0).ceil).to_a
  
      rows = left_col.each_with_index.map do |left, i|
        right = right_col[i]
        [
          "<b>#{left[0]}</b> #{left[1]}",
          right ? "<b>#{right[0]}</b> #{right[1]}" : ""
        ]
      end
  
      pdf.table(rows,
        cell_style: {
          borders: [],
          inline_format: true,
          size: 10,
          padding: [6, 4, 6, 4]
        },
        column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2]
      )
  
      pdf.move_down 10
    end
  end
end
