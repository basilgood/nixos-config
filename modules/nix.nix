{ pkgs, lib, inputs, ...}:
{
  nix = {
    package = pkgs.nixFlakes;
    settings.max-jobs = lib.mkDefault 16;
    settings.auto-optimise-store = true;
    settings.trusted-users = [ "root" "vasy" "@wheel" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # Set nixpkgs channel to follow flake
    nixPath = lib.mkForce [ "nixpkgs=/etc/self/nixos/compat" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

}
