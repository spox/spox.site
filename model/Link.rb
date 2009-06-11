module Models
    # attributes:
    # url
    # title
    # description
    # score
    class Link < Sequel::Model
        many_to_many :tags, :class => 'Models::Tag'
        def before_destroy
            remove_all_tags
        end
    end
end