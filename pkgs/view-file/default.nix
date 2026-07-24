{
  fetchurl,
  writeShellScriptBin,
}:
let
  file = fetchurl {
    hash = "sha256-DiTRoQA4g+80ALiVecQKegZAYyVjk3llm6+qegkGc44=";
    url = "https://dl.emu-land.net/roms/bios_images/psx2/Sony%20PlayStation%202%20BIOS%20%28U%29%28v1.6%29%282002-03-19%29%5BSCPH39004%5D.zip";
  };
in
writeShellScriptBin "view-file" ''
  cp ${file} "$HOME/Downloads/filename"
''
