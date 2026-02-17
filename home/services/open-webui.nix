{ config, pkgs, ... }:

{
  services.open-webui = {
    enable = true;
    port = 8080;
    host = "127.0.0.1";

    environment = {
      # --- OpenRouter Integration ---
      # This tells Open WebUI to use OpenRouter as the primary OpenAI provider
      OPENAI_API_BASE_URL = "https://openrouter.ai/api/v1";
      
      # It is recommended to enter the KEY in the Web UI (Settings > Connections) 
      # so it's not plain text in your nix store, but you can hardcode it here:
      # OPENAI_API_KEY = "sk-or-v1-your-key-here";

      # --- Privacy & Optimization ---
      WEBUI_AUTH = "False"; # Set to True if you want a login screen
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      NLTK_DATA = "/var/lib/open-webui/nltk_data";
      
      # Optional: If you don't use local models, you can disable the internal Ollama connection
      ENABLE_OLLAMA_API = "False";
    };
  };

  # Open the port in the firewall if you want to access it from other devices
  # networking.firewall.allowedTCPPorts = [ 8080 ];
}
