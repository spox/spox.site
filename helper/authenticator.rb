module Ramaze
    module Helper
        module Authenticator
            def logged_in?
                session[:user] && !session[:user].nil?
            end
            def require_authentication
                unless(logged_in?)
                    flash[:error] = 'Access denied'
                    redirect('/login')
                end
            end
            def process_authentication(user, pass)
                model = Models::User.filter(:username => user).first
                if(model && model.valid_password?(pass))
                    session[:user] = model.pk
                    return true
                end
                return false
            end
            def unauthenticate
                session[:user] = nil
            end
        end
    end
end