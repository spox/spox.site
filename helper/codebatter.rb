require 'uv'
require 'htmlentities'
module Ramaze
    module Helper
        module Codebatter
            SYN_LANGS=Uv.syntaxes.map{|x| x.downcase}
            def code_insert(id)
                coder = HTMLEntities.new
                code = Models::Code[id]
                output = nil
                if(code)
                    lang = nil
                    code.tags.each{|t| lang = t.name if SYN_LANGS.include?(t.name.downcase)}
                    output = lang.nil? ? "<pre>#{coder.encode(code.code)}</pre>" : Uv.parse(code.code, 'xhtml', 'ruby', true, 'lazy')
                else
                    output = '<pre>Error: Failed to find requested code item</pre>'
                end
                return output
            end
        end
    end
end