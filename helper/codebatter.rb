require 'htmlentities'
module Ramaze
    module Helper
        module Codebatter
            def code_insert(id)
                coder = HTMLEntities.new
                code = Models::Code[id]
                output = nil
                if(code)
                    output = coder.encode(code.code)
                else
                    output = 'Error: Failed to find requested code item'
                end
                return "<pre>#{output}</pre>"
            end
        end
    end
end