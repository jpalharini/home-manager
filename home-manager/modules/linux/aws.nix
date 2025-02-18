{ pkgs, ... }:

let
  scripts = {
    aws-profile = (pkgs.writeShellScript "aws-profile" ''
      export AWS_REGION=us-east-1
      export AWS_PROFILE=$1
      eval "$(aws configure export-credentials --profile $1 --format env)"
    '');
  };
in {
  home.packages = [
    pkgs.awscli2
    pkgs.awslogs
  ];

  programs.zsh.shellAliases = {
    awsp = "source ${scripts.aws-profile}";
  };
}
