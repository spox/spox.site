class LinksController < Controller
    map '/links'

    def out(id)
        link = Models::Link[id.to_i]
        unless(link)
            flash[:error] = 'Failed to redirect to requested URL'
            redirect_referer
        end
        link.score += 1
        link.save
        redirect(link.url)
    end

    def tagout(tag)
        tag = Models::Tag.filter(:name => tag).first
        if(tag && !tag.links.empty?)
            out(tag.links[0].pk)
        else
            flash[:error] = 'Failed to find requested link'
            redirect_referer
        end
    end
    
    def index
        redirect('/links/list')
    end

    def list(start=1)
        start = start.to_i
        @links = Models::Link.order(:title.desc).paginate(start, 5)
        if(@links.count < 1)
            flash[:notice] = 'No further links available'
            redirect('/links/list') unless start == 1
        end
        @back = start - 1
        @back = 1 if @back < 1
        @forward = start + 1
    end

    def view(id)
        @link = Models::Link[id.to_i]
        unless(@link)
            flash[:error] = 'Invalid link identification received'
            redirect_referer
        end
    end 
end