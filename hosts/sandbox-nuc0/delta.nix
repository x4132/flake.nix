{
  lib,
  stdenv,
  requireFile,
  autoPatchelfHook,
  makeWrapper,
  vulkan-loader,
  libglvnd,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "delta-editor";
  version = "0.1.1-nightly.20260821.3";

  # Nightly tarball isn't publicly fetchable. The build uses the copy staged
  # in the nix store; the original is kept in ~/src. For a newer nightly,
  # drop the tarball there, run
  #   nix-store --add-fixed sha256 ~/src/delta-linux-x86_64.tar.gz
  # and update `sha256` + `version` below.
  src = requireFile {
    name = "delta-linux-x86_64.tar.gz";
    sha256 = "42a05fb6347e2bbd7ad8d3e451b297a6e0c3c5bb1bb798f77519bb299cf8725e";
    message = ''
      Run: nix-store --add-fixed sha256 ~/src/delta-linux-x86_64.tar.gz
    '';
  };

  sourceRoot = "Delta";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  # libvulkan, libEGL, and libwayland-* are dlopened at runtime, invisible to autoPatchelf
  runtimeLibs = lib.makeLibraryPath [
    vulkan-loader
    libglvnd
    wayland
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin lib share $out/

    wrapProgram $out/bin/delta \
      --prefix LD_LIBRARY_PATH : "$runtimeLibs"

    substituteInPlace $out/share/applications/dev.zed.Delta.desktop \
      --replace-fail "Exec=delta" "Exec=$out/bin/delta"

    runHook postInstall
  '';

  meta = {
    description = "Delta editor (Zed-based), packaged from the vendor binary tarball";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "delta";
  };
}
