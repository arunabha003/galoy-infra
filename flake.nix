{
  description = "Dev shell for galoy-infra";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Pin to a specific commit that has fly 7.11.2
    nixpkgs-fly.url = "github:nixos/nixpkgs/23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-fly,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      pkgs-fly = import nixpkgs-fly {inherit system;};
    in
      with pkgs; {
        devShells.default = mkShell
          {
            nativeBuildInputs = [
              alejandra
              opentofu
              ytt
              (azure-cli.withExtensions [azure-cli.extensions.ssh])
              jq
              awscli
              pkgs-fly.fly
            ];

            shellHook = ''
              # Read Azure profile and set subscription ID
              if [ -f ~/.azure/azureProfile.json ]; then
                export ARM_SUBSCRIPTION_ID=$(jq -r '.subscriptions[0].id' ~/.azure/azureProfile.json)
                echo "Set ARM_SUBSCRIPTION_ID to $ARM_SUBSCRIPTION_ID"
              else
                echo "Warning: ~/.azure/azureProfile.json not found, do az login"
              fi
            '';
          };

        formatter = alejandra;
      });
}
