module Models
    # attributes:
    # title
    # content
    class Note < Sequel::Model
    
        many_to_many :tags, :class => 'Models::Tag'
        many_to_one :user, :class => 'Models::User'

        def Note.find_or_create(args)
            if(args.has_key?(:content))
                c = args.delete(:content)
                n = super(args)
                n.content = c
                return n
            else
                super(args)
            end
        end
        
        def save
            super
            refresh
            if(@note_cons)
                DB[:notes_contents] << {:noteid => pk, :content => @note_cons}
            end
        end

        def before_create
            values[:created] = Time.now
        end
        
        def before_save
            values[:modified] = Time.now
        end

        def before_destroy
            remove_all_tags
            DB[:notes_contents].filter(:docid => pk).delete
        end

        def content=(con)
            if(content)
                DB[:notes_contents].filter(:noteid => pk).update(:content => con)
            else
                @note_cons = con
            end
        end
    
        def content
            c = DB[:notes_contents].select(:content).where('noteid = ?', pk).first
            return c.nil? ? nil : c[:content]
        end
    end
end