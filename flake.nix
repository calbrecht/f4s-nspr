{
  description = "nspr-dev nix flake for firefox nightly.";

  inputs = {
    nspr-dev-src = {
      # https://kuix.de/mozilla/versions/ NSPR: NSPR_4_32_RTM
      url = https://hg.mozilla.org/projects/nspr/archive/NSPR_4_32_RTM.zip;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nspr-dev-src }:
    let
      nspr_version = "4.32";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
    in
    {
      legacyPackages."${system}" = self.overlay self.legacyPackages."${system}" pkgs;

      overlay = final: prev: {
        nspr-dev = prev.nspr.overrideAttrs (old: {
          version = nspr_version;
          src = nspr-dev-src;
          postUnpack = ''
            mkdir nspr-${nspr_version}
            mv $sourceRoot nspr-${nspr_version}/nspr
            sourceRoot=nspr-${nspr_version}
          '';
        });
      };
    };
}
