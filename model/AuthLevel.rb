module Models
    # Attributes:
    # name
    class AuthLevel < Sequel::Model
        many_to_many :users, :class => 'Models::User'
    end
end