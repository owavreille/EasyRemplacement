namespace :db do
    desc "Création d'un compte Administrateur"
    task create_admin: :environment do
      puts "Entrer l'email de l'Administrateur :"
      email = STDIN.gets.chomp
  
      puts "Entrer le mot de passe :"
      password = STDIN.gets.chomp
  
      User.create!(
        email: email,
        password: password,
        admin: true
      )
      puts "Le compte administrateur a bien été créé !"
    end
  end
  