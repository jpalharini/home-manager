{ config, ... }:

{
  services.espanso = {
    enable = true;
    matches = {
      global_vars = [
        {
          name = "fname";
          type = "echo";
          params = { echo = "Joao"; };
        }
        {
          name = "lname";
          type = "echo";
          params = { echo = "Palharini"; };
        }
        {
          name = "rua";
          type = "echo";
          params = { echo = "Rua Eduardo de Brito"; };
        }
      ];
      base = {
        matches = [
          {
            trigger = ";numail";
            replace = "joao.palharini@nubank.com.br";
          }
          {
            trigger = ";pmail";
            replace = "joao@gmajp.com";
          }
          {
            trigger = ";rua";
            replace = "{{rua}}"
          }
          {
            trigger = ";ruan";
            replace = "{{rua}}, 1674"
          }
          {
            trigger = ";ap";
            replace = "Ap 201";
          }
          {
            trigger = ";ccname";
            replace = "{{fname}} P B {{lname}}";
          }
          {
            trigger = ";name";
            replace = "{{fname}} {{lname}}";
          }
          {
            trigger = ";fullname";
            replace = "{{fname}} Pedro Berton {{lname}}";
          }
        ];
    };
  };
}
