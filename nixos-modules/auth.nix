{ config, lib, pkgs, ... }:

let
  cfg = config.auth;
in
{
  options = {
    auth = {
      enable = lib.mkEnableOption "auth";
      env-file = lib.mkOption {
        type = lib.types.str;
      };
      vhost = lib.mkOption {
        type = lib.types.str;
      };
      listen_http = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0:9000";
      };
      listen_metrics = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0:9300";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.authentik = {
      enable = true;
      environmentFile = cfg.env-file;
      settings = {
        listen = {
          listen_http = cfg.listen_http;
          listen_metrics = cfg.listen_metrics;
        };

      };
    };

    services.nginx.virtualHosts.${cfg.vhost} = {
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://${config.auth.listen_http}/";
      };
    };

    services.prometheus.scrapeConfigs = [{ job_name = "authentik"; static_configs = [{ targets = [ cfg.listen_metrics ]; }]; }];
  };
}
