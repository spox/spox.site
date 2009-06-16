require 'digest/sha1'
module Models
    # User model holds user information for
    # user's of the site:
    # username
    # email
    # name
    # password
    class User < Sequel::Model
        many_to_many :auth_levels, :class => 'Models::AuthLevel'
        one_to_many :notes, :class => 'Models::Note'

        def password=(pass)
            pass = Digest::SHA1.hexdigest(pass)
            super(pass)
        end

        def valid_password?(pass)
            password == Digest::SHA1.hexdigest(pass)
        end
    end
end