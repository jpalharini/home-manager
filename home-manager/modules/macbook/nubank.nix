{ config, lib, pkgs, ... }:

let
  scripts = {
    aws-profile = (pkgs.writeShellScriptBin "aws-profile" ''
      new_profile=$1

      if [[ $new_profile == 'datomic' ]]; then
        export AWS_PROFILE=bubbagumpshrimp
        export AWS_REGION=us-east-1
        creds=$(grep -A2 '\[bubbagumpshrimp\]' $HOME/.aws/credentials | tail -2)
        access_key_id=$(echo -n $creds | head -1 | awk '{print $3}')
        secret_access_key=$(echo -n $creds | tail -1 | awk '{print $3}')
        export AWS_ACCESS_KEY_ID=$access_key_id
        export AWS_SECRET_ACCESS_KEY=$secret_access_key
      else
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_REGION
        export AWS_PROFILE=$new_profile
      fi
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
    scripts.aws-profile
  ];

  programs.zsh = {
    initExtra = lib.mkAfter ''
      source $HOME/.nurc
    '';

    shellAliases = {
      awsp = "source aws-profile";
      awsr = ''
        nu aws shared-role-credentials refresh --account-alias=br \
        && nu codeartifact login maven \
        && ${scripts.bubba-codeartifact-refresh}
      '';
      awsweb = "nu aws shared-role-credentials web-console --account-alias=br";
    };
  };

}
