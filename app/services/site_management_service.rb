class SiteManagementService
  def self.create_site(params)
    Site.transaction do
      site = Site.create!(params)
      create_mailing_list(site)
      site
    end
  end

  def self.update_site(site, params)
    Site.transaction do
      site.update!(params)
      update_mailing_list(site)
      site
    end
  end

  def self.can_destroy?(site)
    !site.events.exists? && !site.mailing_lists.exists?
  end

  private

  def self.create_mailing_list(site)
    mailing_list_name = "Mailing List #{site.name}"
    generic_text = generate_generic_text(site)
    
    site.mailing_lists.create!(
      name: mailing_list_name,
      text: generic_text
    )
  end

  def self.update_mailing_list(site)
    mailing_list = site.mailing_lists.first
    return unless mailing_list

    mailing_list.update(
      name: "Mailing List #{site.name}",
      text: generate_generic_text(site)
    )
  end

  def self.generate_generic_text(site)
    "Vous recevez ce mail parce que vous êtes inscrit à la mailing list. " \
    "Voici les prochaines disponibilités du site #{site.name}. " \
    "Modifiez vos préférences directement sur votre compte."
  end
end