class CodesController < Controller
    map '/codes'
    
    def index
        redirect('/')
    end

    def view(id)
        @code = Models::Code[id.to_i]
        unless(@code)
            flash[:error] = 'Invalid link identification received'
            redirect_referer
        end
        @id = @code.pk
    end 
end