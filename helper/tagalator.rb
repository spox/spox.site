module Ramaze
    module Helper
        module Tagalator
            def cloudy(num=50)
                result = DB["select count(*) as count, tag_id from (select tag_id from codes_tags union all select tag_id from links_tags union all select tag_id from notes_tags union all select tag_id from projects_tags) group by tag_id order by count desc limit #{num}"]
                tags = []
                result.each{|t| tags << t}
                return tags
            end
        end
    end
end