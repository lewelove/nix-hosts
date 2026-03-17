{ pkgs, username, ... }:

{
  # We define this inside home-manager.users so it runs as YOUR user
  home-manager.users.${username} = {
    systemd.user.services.open-webui = {
      Unit = {
        Description = "Open WebUI User Service";
        After = [ "network.target" ];
      };

      Service = {
        # Create the data directory in your home folder before starting
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/open-webui";

        # Environment configuration
        Environment = [
          "PORT=8080"
          "HOST=127.0.0.1"
          
          # CRITICAL: Tell it to store data in your home directory, not root
          "DATA_DIR=%h/.local/share/open-webui"
          
          # Fixes the specific NLTK/HuggingFace read-only errors by using your cache dir
          "NLTK_DATA=%h/.local/share/open-webui/nltk_data"
          "HF_HOME=%h/.cache/huggingface"
          "SENTENCE_TRANSFORMERS_HOME=%h/.cache/sentence_transformers"
          
          # App Config
          "WEBUI_AUTH=False"
          "ANONYMIZED_TELEMETRY=False"
          "DO_NOT_TRACK=True"
          "SCARF_NO_ANALYTICS=True"
          
          # Connections
          "OPENAI_API_BASE_URL=https://openrouter.ai/api/v1"
          "ENABLE_OLLAMA_API=False" 
        ];

        ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
        
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
