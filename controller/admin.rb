class AdminController < Controller
    map '/admin'
    before_all{ require_authentication }
    
    def index
    end
    
    def action
        case request[:do_this]
            when 'create log'
                redirect('/admin/notes/create')
            when 'create project'
                redirect('/admin/projects/create')
            when 'create link'
                redirect('/admin/links/create')
            when 'create code'
                redirect('/admin/codes/create')
        end
    end
    
    def logout
        unauthenticate
        redirect('/')
    end
end