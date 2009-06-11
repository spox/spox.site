module Models
    class Tag < Sequel::Model
        many_to_many :notes, :class => 'Models::Note'
        many_to_many :links, :class => 'Models::Link'
        many_to_many :projects, :class => 'Models::Project'
        many_to_many :codes, :class => 'Models::Code'
        def before_destroy
            remove_all_notes
            remove_all_links
            remove_all_projects
            remove_all_codes
        end
        def find_or_create(args)
            args[:name].downcase! if args[:name]
            super
        end
        def name=(n)
            n.downcase!
            super
        end
    end
end