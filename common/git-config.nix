{ signingKey }:
{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;

    config = {
      user = {
        name = "0x41*32";
        email = "31595285+x4132@users.noreply.github.com";
        signingkey = signingKey;
      };

      gpg.format = "ssh";
      commit.gpgsign = true;
      push.autosetupremote = true;
      pull.rebase = true;

      safe.directory = "/etc/nixos";
    };
  };
}
