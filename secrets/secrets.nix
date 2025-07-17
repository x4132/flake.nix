let
  msvc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxUsNTDUEJnl77EpewLRm+HyAZH8Sgi2Q99NexHXRWV";

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzKbg6Gy9d7lTa9j247RLEAF8ITgw8KYrCf0+nu3xwo";
in
{
  "microbin.age".publicKeys = [
    msvc
    system1
  ];

  "miniflux.age".publicKeys = [
    msvc
    system1
  ];
}
