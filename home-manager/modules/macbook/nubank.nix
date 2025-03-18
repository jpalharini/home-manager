{ config, lib, pkgs, ... }:

let
  scripts = {
    aws-profile = (pkgs.writeShellScript "aws-profile" ''
      if [[ $1 == 'datomic' || $1 == 'bubbagumpshrimp' ]]; then
        export AWS_REGION=us-east-1
      else
        export AWS_REGION=sa-east-1
      fi
      export AWS_PROFILE=$1
      eval "$(aws configure export-credentials --profile $1 --format env)"
    '');
    bubba-codeartifact-refresh = (pkgs.writeShellScript "bubba-codeartifact-refresh" ''
      codeartifact_token=$(aws codeartifact get-authorization-token --profile bubbagumpshrimp --domain joao --domain-owner 155889952199 --region us-east-1 --query authorizationToken --output text)

      new_settings=$(xml ed -N m=http://maven.apache.org/SETTINGS/1.0.0 \
        --update '//m:server/m:id[text()="bubbagumpshrimp-codeartifact"]/ancestor::*[position()=1]/m:password' \
        --value "$codeartifact_token" < ~/.m2/settings.xml)

      echo "$new_settings" > ~/.m2/settings.xml
    '');
  };

in {
  home.packages = [
    pkgs.gimme-aws-creds
  ];

  programs.zsh = {
    initExtra = lib.mkAfter ''
      source $HOME/.nurc
    '';

    shellAliases = {
      awsp = "source ${scripts.aws-profile}";
      awsr = ''
        nu aws shared-role-credentials refresh --account-alias=br \
        && nu codeartifact login maven \
        && ${scripts.bubba-codeartifact-refresh}
      '';
      awsweb = "nu aws shared-role-credentials web-console --account-alias=br";
    };
  };

}
