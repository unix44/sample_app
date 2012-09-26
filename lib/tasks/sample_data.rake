namespace :db do
    desc "Fill database with sample data"
    task :populate => :environment do
        Rake::Task['db:reset'].invoke
        admin = User.create!(
                :name                   => "Artem A.",
                :email                  => "artem@mail.ru",
                :password               => "qwerty",
                :password_confirmation  => "qwerty"
            )
        admin.toggle!( :admin )

        99.times do |n|
            name = Faker::Name.name
            email = "example-#{n + 1}@mail.net"
            password = "passwd"
            User.create(
                    :name                   => name,
                    :email                  => email,
                    :password               => password,
                    :password_confirmation  => password
                )
        end
    end
end