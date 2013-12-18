module VagrantPlugins
  module VCenter
    module Action
      class DisconnectvCenter
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_vcenter::action::disconnect_vCenter")
        end

        def call(env)
          begin
           @logger.info("Disconnecting from vCenter ...")

          config = env[:machine].provider_config

#          begin
            # Avoid recreating a new session each time.
            if !config.vcenter_cnx
              @logger.info("Session not open, impossible to disconnect")
            else
              config.vcenter_cnx.close
              @logger.info("Succesfully disconnected from vCenter...")
            end

            @app.call env

          rescue Exception => e
            #raise a properly namespaced error for Vagrant
            raise Errors::vCenterError, :message => e.message
          end
        end
      end
    end
  end
end