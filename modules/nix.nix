{ pkgs, lib, inputs, ...}:
{
  nix = {
    package = pkgs.nixFlakes;
    maxJobs = lib.mkDefault 16;
    autoOptimiseStore = true;
    trustedUsers = [ "root" "vasy" "@wheel" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # Set nixpkgs channel to follow flake
    nixPath = lib.mkForce [ "nixpkgs=/etc/self/nixos/compat" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

}
