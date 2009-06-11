class AdminCodesController < Controller
    map '/admin/codes'
    before_all{ require_authentication }
    
    def index
        redirect_referer
    end
    
    def edit(id)
        @code = Models::Code[id.to_i]
        unless(@code)
            flash[:error] = 'Failed to locate code block requested'
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
            code = Models::Code.new
            code.summary = request[:summary]
            code.code = request[:code]
            code.user_id = session[:user]
            code.save
            request[:tags].split.each do |t|
                tag = Models::Tag.find_or_create(:name => t)
                code.add_tag(tag) unless code.tags.include?(tag)
            end
            flash[:success] = "New code has been added. Reference ID: #{code.pk}"
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered while saving: #{boom}"
            redirect('/admin')
        end
    end
    
    def do_edit
        begin
            code = Models::Code[request[:cid].to_i]
            raise 'Failed to locate code to modify' unless code
            code.summary = request[:summary]
            code.code = request[:code]
            code.save_changes
            code.remove_all_tags
            request[:tags].split.each do |t|
                tag = Models::Tag.find_or_create(:name => t)
                code.add_tag(tag)
            end
            flash[:success] = 'Code has been modified'
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered during modification: #{boom}"
            redirect('/admin')
        end
    end
    
    def do_delete(id)
        record = Models::Code[id.to_i]
        if(record)
            record.destroy
            flash[:success] = 'Code was successfully deleted'
        else
            flash[:error] = 'Invalid code identification given. Delete failed.'
        end
        redirect('/admin')
    end
end