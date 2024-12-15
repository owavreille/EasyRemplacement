class ContractGenerator
  def initialize(event)
    @event = event
    @user = event.user
    @doctor = event.doctor
    @site = event.site
  end

  def generate
    template = load_template
    replace_variables(template)
  end

  private

  def load_template
    File.read(Rails.root.join('public', 'contrat.html'))
  end

  def replace_variables(template)
    replacements = {
      'user.title' => @user.title.to_s,
      'user.last_name' => @user.last_name.to_s,
      'user.first_name' => @user.first_name.to_s,
      'user.email' => @user.email.to_s,
      'user.phone' => @user.phone.to_s,
      'user.address' => @user.address.to_s,
      'user.postal_code' => @user.postal_code.to_s,
      'user.city' => @user.city.to_s,
      'user.siret_number' => @user.siret_number.to_s,
      'user.license_number' => @user.license_number.to_s,
      'doctor.title' => @doctor.title.to_s,
      'doctor.first_name' => @doctor.first_name.to_s,
      'doctor.last_name' => @doctor.last_name.to_s,
      'doctor.rpps' => @doctor.rpps.to_s,
      'doctor.email' => @doctor.email.to_s,
      'doctor.phone' => @doctor.phone.to_s,
      'site.name' => @site.name.to_s,
      'site.address' => @site.address.to_s,
      'site.postal_code' => @site.postal_code.to_s,
      'site.city' => @site.city.to_s,
      'event.start_date' => @event.start_time.strftime("%d/%m/%Y").to_s,
      'event.end_date' => @event.end_time.strftime("%d/%m/%Y").to_s,
      'event.start_time' => @event.start_time.strftime("%H:%M").to_s,
      'event.end_time' => @event.end_time.strftime("%H:%M").to_s,
      'event.reversion' => @event.reversion.to_s
    }

    content = template.dup
    replacements.each do |key, value|
      content.gsub!(key, value)
    end

    add_signatures(content)
  end

  def add_signatures(content)
    content.gsub!('doctor.signature', doctor_signature)
    content.gsub!('user.signature', user_signature)
    content
  end

  def doctor_signature
    if @doctor.signature.attached?
      "<img src='#{url_for(@doctor.signature)}' alt='Signature du médecin' width='300' height='300'>"
    else
      'Aucune signature disponible'
    end
  end

  def user_signature
    if @user.signature.attached?
      "<img src='#{url_for(@user.signature)}' alt='Signature de l\'utilisateur' width='300' height='300'>"
    else
      'Aucune signature disponible'
    end
  end
end