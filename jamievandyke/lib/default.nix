{
  lib,
  pkgs,
  jamievandyke,
  ...
}: rec {
  nivSources = import "${jamievandyke}/nix/sources.nix";
  nivGoModule = {
    name,
    moduleOpts ? (meta: opts: opts),
  }: let
    src = nivSources."go-${name}";
    meta =
      {
        inherit name;
        description = name;
        version = src.version or src.rev;
      }
      // src;
  in (pkgs.buildGoModule (moduleOpts meta rec {
    inherit (meta) version;
    inherit src meta;
    pname = meta.name;
    name = "${pname}-${version}";
    vendorSha256 = meta.vendorSha256 or lib.fakeSha256;
  }));
  nivGoAutoMod = name:
    (nivGoModule {
      inherit name;
      moduleOpts = meta: opts:
        opts
        // {
          proxyVendor = true;
          doCheck = false;
          overrideModAttrs = old: {
            buildPhase = ''
              go mod init ${
                meta.go_module or "github.com/${meta.owner}/${meta.repo}"
              }
              ${old.buildPhase}
            '';
            installPhase = ''
              ${old.installPhase}
              cp go.mod $out
            '';
          };
        };
    })
    .overrideAttrs (old: {
      buildPhase = ''
        cp vendor/go.mod .
        ${old.buildPhase}
      '';
    });
  nivFishPlugin = name: {
    inherit name;
    src = nivSources."fish-${name}";
  };
  jamievandykeLink = path: lib.mds.mkOutOfStoreSymlink "/Users/jamievandyke/a/git/fearoffish/nixpkgs/${path}";
  nivApp = name:
    lib.mds.installNivDmg {
      inherit name;
      src = nivSources."${name}App";
    };
}
