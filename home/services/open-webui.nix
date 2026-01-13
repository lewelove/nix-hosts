{ config, pkgs, ... }:

{
  # services.ollama = {
  #   enable = true;
  #   package = pkgs.ollama-cuda;
  # };

  # services.open-webui = {
  #   enable = true;
  #   port = 8080;
  #   host = "127.0.0.1";
  #
  #   environment = {
  #     OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
  #     WEBUI_AUTH = "False";
  #     ANONYMIZED_TELEMETRY = "False";
  #     DO_NOT_TRACK = "True";
  #     # RAG_EMBEDDING_ENGINE = "cpu"; 
  #   };
  # };
}
