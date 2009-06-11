require 'rexml/document'
require 'open-uri'

class ProjectsController < Controller
    map '/projects'
    
    def view(id)
        @project = Models::Project[id.to_i]
        unless(@project)
            flash[:error] = 'Failed to find project'
            redirect_referer
        end
        unless(@project.rss.empty?)
            @stats = []
            doc = REXML::Document.new(open(@project.rss))
            doc.elements.each('rss/channel/item') do |item|
                @stats << {:text => item.elements['title'].text, :link => item.elements['link'].text}
            end
            @stats = @stats.slice(0..4)
        end
    end
    
end