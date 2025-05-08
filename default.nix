{
  pkgs ? import <nixpkgs> {}
}:

pkgs.stdenv.mkDerivation {
  pname = "doas-keepenv";
  version = "1.0";

  src = pkgs.fetchurl {
    url = "https://github.com/stas-badzi/doas-keepenv/archive/refs/tags/1.0.tar.gz";
    sha256 = "sha256-qviS2bepd19EUb0eFVHfsUsk3NsocL9q9LUk4KQhvic=";
  };

  buildInputs = [
    #pkgs.doas either way it requires manual setup, so having it as a dependecy doesn't help
  ];

  nativeBuildInputs = [
    pkgs.makeWrapper
  ];

  buildPhase = ''

  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 doas-keepenv $out/bin
    wrapProgram $out/bin/doas-keepenv --prefix PATH : "${
      pkgs.lib.makeBinPath [
        pkgs.coreutils
      ]
    }:/run/wrappers/bin/doas"
    # add the doas suid wrappper instead of literal doas
  '';

  meta = {
    description = "A bash script for running the doas command while keeping environment variables";
    homepage = "https://github.com/stas-badzi/doas-keepenv";
    mainProgram = "doas-keepenv";
    license = pkgs.lib.licenses.mit;
    #maintainers = with pkgs.lib.maintainers; [ stasbadzi ];
    platforms = pkgs.lib.platforms.linux;
  }; 
  
  allowSubstitutes = true;
  preferLocalBuild = false;
}
