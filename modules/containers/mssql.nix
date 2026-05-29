{
  flake.modules.homeManager.mssql = {config, ...}: {
    sops.secrets.mssql = {};

    services.podman.containers.mssql = {
      image = "mcr.microsoft.com/mssql/server:2025-latest";
      environment = {
        TZ = "Europe/Copenhagen";
        ACCEPT_EULA = "Y";
        MSSQL_PID = "Evaluation";
      };
      environmentFile = [config.sops.secrets.mssql.path];
      ports = ["1433:1433"];
    };
  };
}
