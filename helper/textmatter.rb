module Ramaze
    module Helper
        module Textmatter
            def slice_and_dice(string, words=150)
                string = string.split[0..words].join(' ')
                return tag_closer(string)
            end
            def tag_closer(string)
                tags = []
                string.scan(/<([^>]+)>/im).each do |tag|
                    tag = tag[0]
                    tag.downcase!
                    tag.strip!
                    next if tag =~ /\/$/
                    if(tag =~ /^\/(.+)/)
                        tag = $1
                        tags.delete_at(tags.index(tag)) if tags.index(tag)
                    else
                        tags << tag
                    end
                end
                tags.each do |tag|
                    string << "</#{tag}>"
                end
                return string
            end
        end
    end
end