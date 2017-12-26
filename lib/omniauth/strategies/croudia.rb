require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Croudia < OmniAuth::Strategies::OAuth2
      option :name, 'croudia'
      option :client_options, {
        site: 'https://api.croudia.com',
      }

      uid { raw_info['id'] }

      info do
        {
          id: raw_info['id'],
          id_str: raw_info['id_str'],
          name: raw_info['name'],
          screen_name: raw_info['screen_name'],
          profile_image_url_https: raw_info['profile_image_url_https'],
          cover_image_url_https: raw_info['cover_image_url_https'],
          created_at: raw_info['created_at'],
          description: raw_info['description'],
          location: raw_info['location'],
          url: raw_info['url']
        }
      end

      extra do
        {raw_info: raw_info}
      end

      def raw_info
        @raw_info ||= JSON.parse(access_token.get('/account/verify_credentials.json').body) || {}
      end

      def token_params
        options.token_params.merge(options_for('token')).merge(client_id: options.client_id, client_secret: options.client_secret)
      end
    end
  end
end
