{
  runCommand,
  zip,
  ...
}:
runCommand "getchoo-modpack" {} ''
  mkdir -p "$out"
  ${zip}/bin/zip "$out"/getchoo-modpack.zip ${./files}/{*,.*}
''
