class AdminProjectsController < Controller
    map '/admin/projects'
    before_all{ require_authentication }
    
    def index
        redirect_referer
    end
    
    def edit(id)
        @project = Models::Project[id.to_i]
        unless(@project)
            flash[:error] = 'Failed to locate project requested'
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
            project = Models::Project.new
            project.title = request[:title]
            project.description = request[:description]
            project.rss = request[:rss]
            project.website = request[:website]
            project.public = !request[:public].nil?
            project.user_id = session[:user]
            project.save
            request[:tags].split.each do |t|
                tag = Models::Tag.find_or_create(:name => t)
                project.add_tag(tag)
            end
            flash[:success] = 'New project has been added.'
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered while saving: #{boom}"
            redirect('/admin')
        end
    end
    
    def do_edit
        begin
            project = Models::Project[request[:pid].to_i]
            raise 'Failed to locate project to modify' unless project
            project.title = request[:title]
            project.description = request[:description]
            project.rss = request[:rss]
            project.website = request[:website]
            project.public = !request[:public].nil?
            project.save_changes
            project.remove_all_tags
            request[:tags].split.each do |t|
                tag = Models::Tag.find_or_create(:name => t)
                project.add_tag(tag) unless project.tags.include?(tag)
            end
            flash[:success] = 'Project has been modified'
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered during modification: #{boom}"
            redirect('/admin')
        end
    end
    
    def do_delete(id)
        record = Models::Project[id.to_i]
        if(record)
            record.destroy
            flash[:success] = 'Project was successfully deleted'
        else
            flash[:error] = 'Invalid project identification given. Delete failed.'
        end
        redirect('/admin')
    end
end