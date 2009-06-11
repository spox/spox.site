require 'remarkably/engines/html'
module Ramaze
    module Helper
        module Remarkabatter
            def rmab(string)
                engine = ::Remarkably::Engines::HTML.new
                return engine.instance_eval(string).to_s
            end
        end
    end
end