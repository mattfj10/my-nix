{
  virtualbox,
  writers,
}:
writers.writeDashBin "vboxmanage" ''
  ${virtualbox}/bin/VBoxManage "$@"
''
