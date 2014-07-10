module DockerEcho
  class API < Grape::API
    format :json

    helpers do
      def config
        env['config'] || {}
      end

      def docker_server
        config['docker_server'] || '127.0.0.1'
      end

      def docker_port
        config['docker_port'] || 2375
      end

      def docker_gateway
        config['docker_gateway']
      end

      def worker_image
        config['worker_image'] || 'docker_echo_worker'
      end

      def docker_init!
        if ENV['DOCKER_HOST']
          Docker.url = ENV['DOCKER_HOST']
        else
          Docker.url = "tcp://#{docker_server}:#{docker_port}"
        end
      end

      def container_info(container)
        info = container.json
        # c_info = info['Config'] || {}
        n_info = info['NetworkSettings'] || {}
        s_info = info['State'] || {}

        port_info = nil
        if n_info['Ports']
          n_info['Ports'].keys.each do |port|
            m = port.match(/^([0-9]+)/)
            port_info = m[1] if m
            break if port_info
          end
        end

        {
          id: info['Id'],
          ipaddr: n_info['IPAddress'],
          port: port_info,
          running: s_info['Running']
        }
      end

      def create_worker
        docker_init!

        container = Docker::Container.create({
          'Image' => worker_image
        })

        container_info(container)
      rescue => e
        puts "ERR: #{self.class} - #{__method__} - #{e.inspect}"
        {}
      end

      def start_worker(worker_info)
        docker_init!

        container = Docker::Container.get(worker_info[:id])

        unless container_info(container)[:running]
          container.start
          sleep 0.5 # XXX wait worker listen start
          container = Docker::Container.get(worker_info[:id])
        end

        container_info(container)
      rescue => e
        puts "ERR: #{self.class} - #{__method__} - #{e.inspect}"
        {}
      end

      def stop_worker(worker_info)
        docker_init!

        container = Docker::Container.get(worker_info[:id])
        if container_info(container)[:running]
          container.stop
          sleep 0.5 # XXX wait worker down
          container = Docker::Container.get(worker_info[:id])
        end

        container_info(container)
      rescue => e
        puts "ERR: #{self.class} - #{__method__} - #{e.inspect}"
        {}
      end

      def worker_list(options = {})
        docker_init!

        cons = Docker::Container.all(options)

        workers = []
        cons.each do |c|
          image = c.info['Image'] || ''
          next unless image.start_with?("#{worker_image}:")

          workers.push(container_info(c))
        end

        workers
      rescue => e
        puts "ERR: #{self.class} - #{__method__} - #{e.inspect}"
        []
      end

      def pick_worker
        w_list = worker_list({ all: true })
        if w_list.size > 0
          start_worker(w_list[0])
        else
          start_worker(create_worker)
        end
      end

      def worker_url(worker_info = nil)
        worker_info = pick_worker unless worker_info

        # for devel
        worker_info[:ipaddr] = docker_gateway if docker_gateway

        "http://#{worker_info[:ipaddr]}:#{worker_info[:port]}"
      end

      def call_worker_api(api_name, params = {}, options = {})
        worker_info = pick_worker
        conn = Faraday.new({ url: worker_url(worker_info) }) do |faraday|
          faraday.request :url_encoded
          faraday.response :json
          faraday.adapter Faraday.default_adapter
        end

        res = {}
        case options[:method]
        when :POST
          res = conn.post("/#{api_name}", params)
        else
          res = conn.get("/#{api_name}", params)
        end

        # for devel
        stop_worker(worker_info) unless docker_gateway # XXX

        {
          worker: worker_url(worker_info),
          res: res.body
        }
      rescue => e
        {
          worker: worker_url(worker_info),
          error: e.inspect
        }
      end
    end

    get '/workers_running' do
      {
        workers: worker_list
      }
    end

    get '/workers_all' do
      {
        workers: worker_list({ all: true })
      }
    end

    get '/create_worker' do
      create_worker
      {
        workers: worker_list
      }
    end

    get '/' do
      {
        request: 'root',
        time: Time.now,
        name: 'DockerEchoWorker'
      }
    end

    get :ping do
      call_worker_api('ping', {})
    end

    post :ping do
      call_worker_api('ping', {}, { method: :POST })
    end

    get :echo do
      call_worker_api('echo', params)
    end

    post :echo do
      call_worker_api('echo', params, { method: :POST })
    end
  end
end
