module Octopress
  module Social
    module Email
      extend self

      attr_accessor :url, :config

      DEFAULTS = {
        'share_subject'       => ':title by :author',
        'share_message'       => ':title by :author - :url',
        'share_link_text'     => 'Email',
        'share_link_title'    => 'Share via email',
        'contact_link_text'   => 'Email :author',
        'contact_link_title'  => 'Email :author',
        'address'             => nil
      }

      def set_config(site)
        @config ||= begin
          config = site['octopress_social'] || site
          DEFAULTS.merge(config['email'] || {})
        end
      end

      def contact_link_text(item)
        config['contact_link_text'].sub(':author', author(item))
      end

      def contact_link_title(item)
        config['contact_link_title'].sub(':author', author(item))
      end

      def set_url(site, item)
        @url = Social.full_url(site, item)
      end

      def author(item={})
        item['author'] || item['site']['author'] || ''
      end

      def subject(site, item)
        name = author(item)
        author_var = (name.empty? ? 'by :author' : ':author')
        ERB::Util.url_encode (item['email_share_subject'] || config['share_subject'])
          .sub(':title', item['title'] || '')
          .sub(author_var, name)
          .strip
      end

      def message(site, item)
        name = author(item)
        author_var = (name.empty? ? 'by :author' : ':author')
        ERB::Util.url_encode (item['email_share_message'] || config['share_message'])
          .sub(':title', item['title'] || '')
          .sub(author_var, name)
          .sub(':url', url)
          .strip
      end

      def email_share_link(site, item)
        %Q{<a class="email-share-link" 
          href="mailto:?subject=#{subject(site, item)}&body=#{message(site, item)}"
          title="#{config['share_link_title']}">#{config['share_link_text']}</a>}
      end

      def email_contact_link(site, item)
        %Q{<a
          class="email-contact-link"
          href="mailto:#{config['address']}"
          title="#{contact_link_title(item)}">#{contact_link_text(item)}</a>}
      end

      class Tag < Liquid::Tag
        def initialize(tag, input, tokens)
          @tag = tag.strip
          @input = input.strip
        end

        def render(context)
          site = context['site']
          item = Octopress::Social.item(context, @input)
          item['site'] = site

          Octopress::Social::Email.set_config(site)
          Octopress::Social::Email.set_url(site, item)
          Octopress::Social::Email.send(@tag, site, item).gsub(/(\s{2,}|\n)/, ' ').strip
        end
      end

    end
  end
end
