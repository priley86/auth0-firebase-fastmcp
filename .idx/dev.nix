# To learn more about how to use Nix to configure your environment
# see: https://firebase.google.com/docs/studio/devnix-reference
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "unstable";
  
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.python313
    pkgs.uv
    pkgs.pipx
  ];
  
  # Sets environment variables in the workspace
  env = {
    # Set Python to use Python 3.13 from nix
    PYTHON = "${pkgs.python313}/bin/python3";
    
    # Increase UV HTTP timeout for slower network connections
    UV_HTTP_TIMEOUT = "120";
    
    # MCP Server URL (uses Firebase Studio's $WEB_HOST for dynamic URL)
    MCP_SERVER_URL = "https://3001-$WEB_HOST";
  };
  
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "ms-python.python"
      "ms-python.vscode-pylance"
    ];
    
    # Enable previews
    previews = {
      enable = true;
      previews = {
        # MCP Server preview on port 3001
        web = {
          command = ["uv" "run" "python" "-m" "src.server"];
          manager = "web";
          env = {
            PORT = "3001";
          };
        };
      };
    };
    
    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # Copy environment file
        copy-env = "cp .env.example .env";
        
        # Install dependencies using uv
        install-deps = "uv sync";
        
        # Open editors for the following files by default, if they exist:
        default.openFiles = [ 
          ".idx/dev.nix" 
          "README.md" 
          "src/server.py"
          "src/tools.py"
        ];
      };
      
      # Runs when the workspace is (re)started
      onStart = {
        # Start the MCP server
        start-server = "uv run python -m src.server";
      };
    };
  };
}
