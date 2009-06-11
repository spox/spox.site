module Models
    # attributes:
    # code
    # summary
    # created
    # user_id
    class Code < Sequel::Model
        many_to_many :tags, :class => 'Models::Tag'
        def before_create
            values[:created] = Time.now
        end
        def before_destroy
            remove_all_tags
        end
    end
end