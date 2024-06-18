{
  name = "auth";
  nodes.machine1 = { ... }: { };

  testScript = ''
    start_all()
    machine1.succeed("sleep 10")
  '';
}
