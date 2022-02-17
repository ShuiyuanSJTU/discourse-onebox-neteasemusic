# name: discourse-onebox-neteasemusic
# about: 为 Discourse Onebox 增加了网易云支持
# version: 0.1.2
# authors: pangbo13
# url: https://github.com/pangbo13/discourse-onebox-neteasemusic

require_relative "../../lib/onebox"

Onebox = Onebox

class Onebox::Engine::NeteasemusicOnebox
    include Onebox::Engine
    matches_regexp(/^https?:\/\/music\.163\.com\/(#\/)?(album|song)(\?id=|\/)([0-9]+)(&.*)?\/?$/)
    always_https

    def uri_s
        @@uri_s ||= uri.to_s

    def item_type
        return @@item_id if @@item_id
        if uri_s.match(/song/)
            @@item_id = 2
        elsif uri_s.match(/album/)
            @@item_id = 1
        end
        @@item_id
    rescue
        nil
    end

    def item_id
        return @@item_id if @@item_id
        if uri_s.match(/\?id=/)
            @@item_id = uri_s.match(/\?id=([0-9]+)/)[1]
        else
            @@item_id = uri_s.match(/(album|song)\/([0-9]+)/)[2]
        end
        @@item_id
    rescue
        nil
    end

    def to_html
        case item_type
        when 1
            <<-HTML
            <iframe 
            frameborder="no" 
            border="0" 
            marginwidth="0" 
            marginheight="0" 
            width=330 
            height=450 
            src="https://music.163.com/outchain/player?type=1&id=#{item_id}&auto=0&height=430">
            </iframe>
            HTML
        when 2
            <<-HTML
            <iframe 
            frameborder="no" 
            border="0" 
            marginwidth="0" 
            marginheight="0" 
            width=330 
            height=86 
            src="https://music.163.com/outchain/player?type=2&id=#{item_id}&auto=0&height=66">
            </iframe>
            HTML
        end
    end

    def placeholder_html
        to_html
    end
end
