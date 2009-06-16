# Default url mappings are:
#  a controller called Main is mapped on the root of the site: /
#  a controller called Something is mapped on: /something
# If you want to override this, add a line like this inside the class
#  map '/otherurl'
# this will force the controller to be mounted on: /otherurl

class MainController < Controller
    # the index action is called automatically when no other action is specified
    def index
        redirect('/logs/list')
    end

    def home
        redirect('/logs/list')
    end

    def error(e='Unknown')
        flash[:error] = Ramaze::Helper::CGI::url_decode(e)
        redirect_referer
    end

    def about
        tag = Models::Tag.filter(:name => 'aboutpage').first
        if(tag && !tag.notes.empty?)
            redirect("/logs/view/#{tag.notes[0].pk}")
        else
            redirect("/error/#{Ramaze::Helper::CGI::url_encode('Page Not Found')}")
        end
    end

    def do_login
        if(process_authentication(request[:username], request[:password]))
            redirect('/admin')
        else
            redirect("/error/#{Ramaze::Helper::CGI::url_encode('Invalid credentials supplied')}")
        end
    end

end
