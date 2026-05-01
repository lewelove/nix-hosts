{
  description = "Vellum Core Toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    lib = {
      mkAlbum = { 
        pname, 
        src, 
        metadata ? null, 
        metadataString ? null, 
        cover ? null, 
        ops ? "cp -r ./* $out/" 
      }:
        let
          unwrap = s: if builtins.isString s && builtins.substring 0 1 s == "/" 
                      then /. + s 
                      else s;

          realSrc = builtins.path {
            name = pname;
            path = unwrap src;
          };

          realMetadata = if metadata != null 
                         then builtins.path { name = "${pname}-metadata"; path = unwrap metadata; } 
                         else null;

          realCover = if cover != null 
                      then builtins.path { name = "${pname}-cover"; path = unwrap cover; } 
                      else null;

          # Explicitly extract extension from the original path string/literal
          coverExt = if cover != null then 
                       let 
                         base = builtins.baseNameOf (unwrap cover);
                         match = builtins.match ".*\\.([^.]+)$" base;
                       in if match != null then builtins.elemAt match 0 else "img"
                     else "";
        in
        pkgs.stdenv.mkDerivation {
          name = pname;
          src = realSrc;

          metadataPath = realMetadata;
          metadataContent = metadataString;
          coverPath = realCover;
          ext = coverExt;

          buildInputs = [ pkgs.flac pkgs.shntool pkgs.ffmpeg ];
          
          passAsFile = if metadataString != null then [ "metadataContent" ] else [];
          
          buildPhase = ''
            mkdir -p $out
            
            ${ops}
            
            if [ -n "$metadataPath" ]; then
              cp "$metadataPath" "$out/metadata.toml"
            elif [ -f "$metadataContentPath" ]; then
              cp "$metadataContentPath" "$out/metadata.toml"
            fi

            if [ -n "$coverPath" ]; then
              cp "$coverPath" "$out/cover.$ext"
            fi
          '';

          installPhase = "true";
        };
    };
  };
}
