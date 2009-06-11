module Models
    # attributes:
    # title
    # description
    # rss
    # website
    # public
    class Project < Sequel::Model
        many_to_many :tags, :class => 'Models::Tag'
        def before_destroy
            remove_all_tags
        end
    end
end