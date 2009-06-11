class AdminUsersController < Controller
    map '/admin/users'
    before_all{ require_authentication }
    
    def index
        redirect_referer
    end
    
    def edit(id)
        @user = Models::User[id.to_i]
        unless(@user)
            flash[:error] = 'Failed to locate user requested'
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
    # username
    # email
    # name
    # password
    def do_create
        begin
            raise 'Passwords do not match' unless request[:password] == request[:checkpass]
            user = Models::User.new
            user.username = request[:username]
            user.email = request[:email]
            user.name = request[:name]
            user.password = request[:password]
            user.save
            flash[:success] = 'New user has been added.'
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered while saving: #{boom}"
            redirect_referer
        end
    end
    
    def do_edit
        begin
            raise 'Passwords do not match' unless request[:password] == request[:checkpass]
            user = Models::User[request[:uid].to_i]
            user.username = request[:username]
            user.email = request[:email]
            user.name = request[:name]
            user.password = request[:password] unless request[:password].empty?
            user.save_changes
            flash[:success] = 'User has been modified'
            redirect('/admin')
        rescue Object => boom
            flash[:error] = "Error encountered during modification: #{boom}"
            redirect_referer
        end
    end
    
    def do_delete(id)
        record = Models::User[id.to_i]
        if(record)
            record.destroy
            flash[:success] = 'User was successfully deleted'
        else
            flash[:error] = 'Invalid user identification given. Delete failed.'
        end
        redirect('/admin')
    end
end