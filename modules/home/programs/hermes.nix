{ hermes-agent, ... }:
{
  imports = [ hermes-agent.homeManagerModules.default ];

  programs.hermes-agent.enable = true;
}
