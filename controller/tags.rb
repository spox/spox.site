class TagsController < Controller
    map '/tags'

    def index
        redirect('/tags/cloud')
    end

    def cloud
        @tags = cloudy(50)
        if(@tags.count < 1)
            flash[:error] = 'No tags found'
            redirect_referer
        end
        @size = @tags[0][:count].to_f
        @max_size = 5.to_f
        @tags = @tags.sort_by{rand}
    end

    def all
        if(Models::Tag.all.count < 1)
            flash[:error] = 'No tags found'
            redirect_referer
        end
    end

    def view(tag)
        @tag = Models::Tag.filter(:name => tag).first
        unless(@tag)
            flash[:error] = "Failed to find any information for tag: #{tag}"
            redirect_referer
        end
    end
    
end