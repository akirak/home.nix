# Host-specific configuration should go into this file.
{ ... }:
{
  hostname = "penguin";
  username = "akirakomamura";
  fullname = "Akira Komamura";
  email = "akira.komamura@gmail.com";
  github = {
    user = "akirak";
  };
  language = {
    base = "en";
    address = "ja";
  };
  preferences = {
    useBrowserPass = true;
    addGlobalGitIdentity = true;
  };
  platform = {
    isChromeOS = true;
    isNixOS = false;
  };
}
