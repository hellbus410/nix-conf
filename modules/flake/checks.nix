# `nix flake check`: RFC 166 formatting, static Nix linters, SOPS/secret hygiene, and host evaluations.
{
  config,
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, system, ... }:
    let
      hostChecks =
        lib.mapAttrs' (name: nixos: lib.nameValuePair "host-${name}" nixos.config.system.build.toplevel)
          (
            lib.filterAttrs (
              _: nixos: nixos.pkgs.stdenv.hostPlatform.system == system
            ) config.flake.nixosConfigurations
          );
    in
    {
      checks = hostChecks // {
        formatting =
          pkgs.runCommandLocal "check-formatting"
            {
              nativeBuildInputs = [ pkgs.nixfmt ];
            }
            ''
              find ${inputs.self} -name '*.nix' -exec nixfmt --check {} +
              touch $out
            '';

        statix =
          pkgs.runCommandLocal "check-statix"
            {
              nativeBuildInputs = [ pkgs.statix ];
            }
            ''
              statix check --config ${inputs.self}/statix.toml ${inputs.self}
              touch $out
            '';

        deadnix =
          pkgs.runCommandLocal "check-deadnix"
            {
              nativeBuildInputs = [ pkgs.deadnix ];
            }
            ''
              find ${inputs.self} -name '*.nix' ! -name '_hardware.nix' -exec deadnix --fail {} +
              touch $out
            '';

        secrets =
          pkgs.runCommandLocal "check-secrets"
            {
              nativeBuildInputs = [
                pkgs.gitleaks
                pkgs.yq-go
              ];
            }
            ''
              gitleaks dir --no-banner --redact ${inputs.self}

              while IFS= read -r -d ''' f; do
                case "$f" in
                  *.yaml|*.yml) ;;
                  *)
                    echo "ERROR: non-YAML file under secrets/: $f" >&2
                    exit 1
                    ;;
                esac
                yq -e '.sops.mac | test("^ENC\\[AES256_GCM,")' "$f" >/dev/null || {
                  echo "ERROR: missing SOPS MAC footer in $f" >&2
                  exit 1
                }
                yq -e '([del(.sops) | .. | select(kind == "scalar")] | length > 0) and ([del(.sops) | .. | select(kind == "scalar") | test("^ENC\\[AES256_GCM,")] | all_c(. == true))' "$f" >/dev/null || {
                  echo "ERROR: unencrypted scalar value found in $f" >&2
                  exit 1
                }
              done < <(find ${inputs.self}/secrets -type f -print0)

              touch $out
            '';
      };
    };
}
