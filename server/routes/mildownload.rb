class MainApp
  namespace '/api/mildownload' do
    helpers do
      def extract_video_id(url)
        m = %r{^https://www.mildom.com/playback/[0-9]{8}/([0-9]{8}-[0-9a-z]{20})}.match(url)
        unless m
          logger.warn "Invalid URL: #{url}"
          halt 400
        end
        m.captures[0]
      end

      def timestamp
        Time.now.gmtime.strftime('%FT%T.%LZ')
      end

      def timestamp2
        Time.now.gmtime.strftime('%s%L')
      end

      def get_playback_detail(archive_url)
        video_id = extract_video_id(archive_url)
        query = {
          v_id: video_id,
          # timestamp: timestamp,
          # __guest_id: 'pc-gp-550e8400-e29b-41d4-a716-446655440000',
          # __location: 'Japan|Tokyo',
          # __country: 'Japan',
          # __cluster: 'aws_japan',
          __platform: 'web',
          # __la: 'ja',
          # __pcv: 'v2.12.16',
          # sfr: 'pc',
          # accessToken: '550e8400-e29b-41d4-a716-446655440000',
          # __fc: 'Japan',
        }
        query = URI.encode_www_form(query)
        uri = URI::HTTPS.build({
          host: 'cloudac.mildom.com',
          path: '/nonolive/videocontent/playback/getPlaybackDetail',
          query: query,
        })
        get_json(uri)
      end

      def download(m3u8, output)
        cmd = [
          'youtube-dl',
          '-o', output,
          m3u8,
        ]
        system(*cmd, exception: true)
      end

      def cut_video(src, dist, start_t, end_t)
        cmd = [
          'ffmpeg',
          '-i', src,
          '-c', 'copy',
        ]
        cmd.push('-ss', start_t.to_s) if start_t
        cmd.push('-to', end_t.to_s) if end_t
        cmd.push(dist)
        system(*cmd, exception: true)
      end
    end

    get '/fetchinfo' do
      halt 400 unless params[:url]
      res = get_playback_detail(params[:url])
      content = res['body']['playback']
      logger.info "Fetch: #{params[:url]}"
      logger.info "Title: #{content['title']}, Author: #{content['author_info']['login_name']}"
      json content
    end

    get '/download' do
      halt 400 unless params[:m3u8] || params[:m3u8].ends_with('m3u8')
      halt 400 unless params[:vid]

      ext = 'mp4'
      filename = "/tmp/#{timestamp2}-#{params[:vid]}"
      download(params[:m3u8], "#{filename}.raw.#{ext}")

      s = params[:start].to_i
      e = params[:end].to_i
      start_t = s == -1 ? nil : s
      end_t = e == -1 ? nil : e
      cut_video("#{filename}.raw.#{ext}", "#{filename}.#{ext}", start_t, end_t)

      send_file "#{filename}.#{ext}", type: ext.to_sym
    end
  end
end
