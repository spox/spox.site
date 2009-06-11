class AdminNotesController < Controller
    map '/admin/notes'
    before_all{ require_authentication }
    
    def index
        redirect_referer
    end
    
    def create
        # nothing needed here #
    end
    
    def edit(id)
        @note = Models::Note[id.to_i]
        unless(@note)
            flash[:error] = 'Requested note is not found'
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
            note = Models::Note.new
            note.title = request[:title]
            note.content = request[:content]
            note.user_id = session[:user]
            note.save
            request[:tags].split.each do |t|
                tag = Models::Tag.find_or_create(:name => t)
                note.add_tag(tag) unless note.tags.include?(tag)
            end
            flash[:success] = 'New note has been added'
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered while saving: #{boom}"
            redirect('/admin')
        end
    end
    
    def do_edit
        begin
            note = Models::Note[request[:nid].to_i]
            raise 'Failed to locate note to modify' unless note
            note.title = request[:title]
            note.content = request[:content]
            note.save_changes
            note.remove_all_tags
            request[:tags].split.each do |t|
                tag = Models::Tag.find_or_create(:name => t)
                note.add_tag(tag)
            end
            flash[:success] = 'Note has been modified'
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered during modification: #{boom}"
            redirect('/admin')
        end
    end
    
    def do_delete(id)
        record = Models::Note[id.to_i]
        if(record)
            record.destroy
            flash[:success] = 'Note was successfully deleted'
        else
            flash[:error] = 'Invalid note identification given. Delete failed.'
        end
        redirect('/admin')
    end
end