namespace :db do
    desc "Fill database with sample data"
    task :populate => :environment do
        Rake::Task['db:reset'].invoke
        make_users
        make_microposts
        make_relationships
    end
end

def make_users
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

def make_microposts
    User.all( :limit => 6 ).each do |user|
        50.times do
            user.microposts.create!( :content => Faker::Lorem.sentence( 10 ) )
        end
    end
end

def make_relationships
    users = User.all
    user  = users.first
    following = users[1..50]
    followers = users[3..40]
    following.each { |followed| user.follow!( followed ) }
    followers.each { |follower| follower.follow!( user ) }
end