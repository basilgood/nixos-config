inputs: final: prev:
let inherit (final) callPackage;
in {
  klog = callPackage ./klog.nix { };
  bartib = callPackage ./bartib.nix { };
}
