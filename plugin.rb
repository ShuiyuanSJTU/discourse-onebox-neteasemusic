# name: discourse-onebox-neteasemusic
# about: 为 Discourse Onebox 增加了网易云支持
# version: 0.1.0
# authors: pangbo13
# url: https://github.com/pangbo13/discourse-onebox-neteasemusic

require_relative "../../lib/onebox"

Onebox = Onebox

class Onebox::Engine::NeteasemusicOnebox
    include Onebox::Engine
    matches_regexp(/^https?:\/\/music\.163\.com\/(#\/)?(album|song)(\?id=|\/)([0-9]+)(&.*)?\/?$/)
    always_https

    def item_type
        uri_s = uri.to_s
        if uri_s.match(/song/)
            return 2
        elsif uri_s.match(/album/)
            return 1
        end
        nil
    rescue
        nil
    end

    def item_id
        uri_s = uri.to_s
        if uri_s.match(/\?id=/)
            match = uri_s.match(/\?id=([0-9]+)/)
            return match[1]
        else
            match = uri_s.match(/(album|song)\/([0-9]+)/)
            return match[2]
        end
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
            src="//music.163.com/outchain/player?type=1&id=#{item_id}&auto=0&height=430">
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
            src="//music.163.com/outchain/player?type=2&id=#{item_id}&auto=0&height=66">
            </iframe>
            HTML
        end
    end

    def placeholder_html
        to_html
    end
end
