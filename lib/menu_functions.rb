require File.expand_path("../config/environment", __dir__)
require 'colorize'

def display_menu
    puts "\n=== LinkSaver - Gerenciamento de Contatos ===".cyan
    puts "1. Adicionar contato".green
    puts "2. Listar contatos".green
    puts "3. Buscar contato".green
    puts "4. Editar contato".green
    puts "5. Deletar contato".green
    puts "6. Exportar para CSV".green
    puts "7. Sair".yellow
    print "Escolha uma opção (1-7): ".cyan
  end
  
  def valid_number?(input)
    input.match?(/\A\d+\z/)
  end
  
  def add_contact
    print "Nome: ".cyan
    name = gets.chomp.strip
    if name.empty?
      puts "Erro: O nome não pode ser vazio.".red
      return
    end
  
    if Contact.exists?(name: name)
      print "Já existe um contato com o nome '#{name}'. Deseja continuar? (s/n): ".yellow
      return unless gets.chomp.downcase == 's'
    end
  
    print "Telefone (8-15 dígitos, opcional): ".cyan
    phone_input = gets.chomp.strip.gsub(/\D/, '')
    phone = if phone_input.empty?
              ""
            elsif phone_input.length.between?(8, 15)
              mid = phone_input.length / 2
              "#{phone_input[0...mid]}-#{phone_input[mid..-1]}"
            else
              puts "Aviso: Telefone inválido (mantido como digitado).".yellow
              phone_input
            end
  
    print "E-mail (opcional): ".cyan
    email = gets.chomp.strip
    if Contact.exists?(email: email) && !email.empty?
      print "Já existe um contato com o e-mail '#{email}'. Deseja continuar? (s/n): ".yellow
      return unless gets.chomp.downcase == 's'
    end
  
    begin
      contact = Contact.new(name: name, phone: phone, email: email)
      if contact.save
        puts "Contato adicionado: #{contact.name} - #{contact.phone} - #{contact.email}".green
      else
        puts "Erro ao adicionar: #{contact.errors.full_messages.join(', ')}".red
      end
    rescue ActiveRecord::ActiveRecordError => e
      puts "Erro no banco de dados ao adicionar contato: #{e.message}. Tente novamente.".red
    end
  end
  
  def list_contacts
    contacts = Contact.order(:name)
    if contacts.empty?
      puts "Nenhum contato cadastrado ainda. Adicione um com a opção 1!".yellow
    else
      puts "\nLista de contatos (Total: #{contacts.count}):".cyan
      puts ("-" * 100).cyan
      contacts.each do |contact|
        name_display = contact.name.length > 20 ? "#{contact.name[0..16]}..." : contact.name
        puts "ID: #{contact.id.to_s.rjust(3)} | Nome: #{name_display.ljust(20)} | Telefone: #{contact.phone.ljust(15)} | E-mail: #{contact.email}".green
      end
      puts ("-" * 100).cyan
    end
  end
  
  def search_contact
    puts "\nEscolha o campo para buscar:".cyan
    puts "1. Nome".green
    puts "2. Telefone".green
    puts "3. E-mail".green
    print "Digite o número do campo (1-3, ou deixe em branco para cancelar): ".cyan
    field_input = gets.chomp.strip
  
    if field_input.empty?
      puts "Busca cancelada.".red 
      return
    end
  
    unless valid_number?(field_input) && (1..3).include?(field_input.to_i)
      puts "Erro: Escolha um número válido entre 1 e 3.".red
      return
    end
  
    field = case field_input.to_i
            when 1 then :name
            when 2 then :phone
            when 3 then :email
            end
  
    print "Digite o termo para buscar no campo '#{field}' (ou deixe em branco para cancelar): "
    search_term = gets.chomp.strip
    if search_term.empty?
      puts "Busca cancelada.".yellow
      return
    end
  
    results = Contact.where("#{field} LIKE ?", "%#{search_term}%")
    if results.empty?
      puts "Nenhum contato encontrado com '#{search_term}' no campo '#{field}'.".green
    else
      puts "\nResultados da busca por '#{search_term}' no campo '#{field}' (Total: #{results.count}):".green
      puts "-" * 50
      results.each do |contact|
        name_display = contact.name.length > 20 ? "#{contact.name[0..16]}..." : contact.name
        puts "ID: #{contact.id.to_s.rjust(3)} | Nome: #{name_display.ljust(20)} | Telefone: #{contact.phone.ljust(15)} | E-mail: #{contact.email}".cyan
      end
      puts "-" * 50
    end
  end
  
  def edit_contact
    contacts = Contact.all
    if contacts.empty?
      puts "Nenhum contato cadastrado para editar.".red
      return
    end
  
    list_contacts
    print "Digite o ID do contato para editar (ou deixe em branco para cancelar): ".green
    id_input = gets.chomp.strip
    if id_input.empty?
      puts "Edição cancelada.".red
      return
    end
  
    unless valid_number?(id_input)
      puts "Erro: Digite um número válido para o ID.".red
      return
    end
  
    id = id_input.to_i
    contact = Contact.find_by(id: id)
    if contact.nil?
      puts "Erro: Contato com ID #{id} não encontrado.".red
      return
    end
  
    puts "\nEditando: #{contact.name} - #{contact.phone} - #{contact.email}"
    print "Novo nome (deixe em branco para manter '#{contact.name}'): ".cyan
    name_input = gets.chomp.strip
    new_name = name_input.empty? ? contact.name : name_input
  
    if new_name != contact.name && Contact.exists?(name: new_name)
      print "Já existe um contato com o nome '#{new_name}'. Deseja continuar? (s/n): ".yellow
      return unless gets.chomp.downcase == 's'
    end
  
    print "Novo telefone (deixe em branco para manter '#{contact.phone}', 8-15 dígitos): ".cyan
    phone_input = gets.chomp.strip.gsub(/\D/, '')
    new_phone = if phone_input.empty?
      contact.phone
    elsif phone_input.length.between?(8, 15)
      mid = phone_input.length / 2
      "#{phone_input[0...mid]}-#{phone_input[mid..-1]}"
    else
      puts "Aviso: Telefone inválido (mantido como digitado).".yellow
      phone_input
    end
  
    print "Novo e-mail (deixe em branco para manter '#{contact.email}'): ".cyan
    email_input = gets.chomp.strip
    new_email = email_input.empty? ? contact.email : email_input
  
    if new_email != contact.email && !new_email.empty? && Contact.exists?(email: new_email)
      print "Já existe um contato com o e-mail '#{new_email}'. Deseja continuar? (s/n): ".yellow
      return unless gets.chomp.downcase == 's'
    end
  
    puts "\nAlterações propostas:".cyan
    puts "Nome: #{new_name}".green
    puts "Telefone: #{new_phone}".green
    puts "E-mail: #{new_email}".green
    print "Confirmar alterações? (s/n): ".yellow
    return puts "Edição cancelada." unless gets.chomp.downcase == 's'
  
    begin
      contact.update(name: new_name, phone: new_phone, email: new_email)
      if contact.errors.any?
        puts "Erro ao atualizar: #{contact.errors.full_messages.join(', ')}".red
      else
        puts "Contato atualizado com sucesso: #{contact.name} - #{contact.phone} - #{contact.email}".yellow
      end
    rescue ActiveRecord::ActiveRecordError => e
      puts "Erro no banco de dados ao atualizar contato: #{e.message}. Tente novamente.".red
    end
  end
  
  def delete_contact
    contacts = Contact.all
    if contacts.empty?
      puts "Nenhum contato cadastrado para deletar.".yellow
      return
    end
  
    list_contacts
    print "Digite o ID do contato para deletar (ou deixe em branco para cancelar): ".cyan
    id_input = gets.chomp.strip
    if id_input.empty?
      puts "Exclusão cancelada.".yellow
      return
    end
  
    unless valid_number?(id_input)
      puts "Erro: Digite um número válido para o ID.".red
      return
    end
  
    id = id_input.to_i
    contact = Contact.find_by(id: id)
    if contact.nil?
      puts "Erro: Contato com ID #{id} não encontrado.".red
      return
    end
  
    puts "\nContato a ser deletado: #{contact.name} - #{contact.phone} - #{contact.email}".cyan
    print "Tem certeza que deseja deletar este contato? (s/n): ".yellow
    return puts "Exclusão cancelada." unless gets.chomp.downcase == 's'
  
    begin
      contact.destroy
      puts "Contato '#{contact.name}' (ID: #{id}) deletado com sucesso!".green
    rescue ActiveRecord::ActiveRecordError => e
      puts "Erro no banco de dados ao deletar contato: #{e.message}. Tente novamente.".red
    end
  end
  
  def export_to_csv
    contacts = Contact.all
    if contacts.empty?
      puts "Nenhum contato para exportar.".yellow
      return
    end
  
    require 'date'
    default_filename = "contatos_#{Date.today.strftime('%d-%m-%Y')}.csv"
    print "Digite o nome do arquivo para exportar (padrão: '#{default_filename}', pressione Enter para usar o padrão): ".cyan
    filename_input = gets.chomp.strip
    filename = filename_input.empty? ? default_filename : "#{filename_input}.csv"
  
    begin
      require 'csv'
      file_path = File.expand_path(filename)
      CSV.open(file_path, "w") do |csv|
        csv << ["Nome", "Telefone", "E-mail"]
        contacts.each do |contact|
          csv << [contact.name, contact.phone, contact.email]
        end
      end
      puts "Contatos exportados com sucesso para: #{file_path}".green
    rescue Errno::EACCES
      puts "Erro: Permissão negada para criar o arquivo '#{file_path}'. Tente outro nome ou verifique as permissões.".red
    rescue Errno::ENOSPC
      puts "Erro: Sem espaço em disco para salvar '#{file_path}'. Libere espaço e tente novamente.".red
    rescue StandardError => e
      puts "Erro inesperado ao exportar: #{e.message}. Tente novamente.".red
    end
  end
