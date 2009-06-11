class LogsController < Controller
    map '/logs'
    helper :textmatter
    
    def index
        redirect('/')
    end
    
    def list(start=1)
        start = start.to_i
        @notes = Models::Note.order(:created.desc).paginate(start, 5)
        if(@notes.count < 1)
            flash[:notice] = 'No further logs available'
            redirect('/logs/list') unless start == 1
        end
        @back = start - 1
        @back = 1 if @back < 1
        @forward = start + 1
    end
    
    def view(id)
        @log = Models::Note[id.to_i]
        unless(@log)
            flash[:error] = 'Invalid log identification received'
            redirect_referer
        end
    end
    
    def search(term)
    end
    
end