class AdminLinksController < Controller
    map '/admin/links'
    before_all{ require_authentication }
    
    def index
        redirect_referer
    end
    
    def edit(id)
        @link = Models::Link[id.to_i]
        unless(@link)
            flash[:error] = 'Failed to locate link requested'
            redirect_referer
        end
    end
    
    def process(action, id=nil)
        case action
            when 'create'
                do_create
            when 'edit'
                do_edit
            when 'delete'
                do_delete(id)
            else
                flash[:error] = 'Unknown command received'
                redirect_referer
        end
    end
    
    private

    def do_create
        begin
            link = Models::Link.new
            link.url = request[:url]
            link.title = request[:title]
            link.description = request[:description]
            link.save
            request[:tags].split.each do |t|
                tag = Models::Tag.find_or_create(:name => t)
                link.add_tag(tag) unless link.tags.include?(tag)
            end
            flash[:success] = 'New link has been added.'
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered while saving: #{boom}"
            redirect('/admin')
        end
    end
    
    def do_edit
        begin
            link = Models::Link[request[:lid].to_i]
            raise 'Failed to locate link to modify' unless link
            link.url = request[:url]
            link.title = request[:title]
            link.description = request[:description]
            link.save_changes
            link.remove_all_tags
            request[:tags].split.each do |t|
                tag = Models::Tag.find_or_create(:name => t)
                link.add_tag(tag)
            end
            flash[:success] = 'Link has been modified'
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered during modification: #{boom}"
            redirect('/admin')
        end
    end
    
    def do_delete(id)
        record = Models::Link[id.to_i]
        if(record)
            record.destroy
            flash[:success] = 'Link was successfully deleted'
        else
            flash[:error] = 'Invalid link identification given. Delete failed.'
        end
        redirect('/admin')
    end
end