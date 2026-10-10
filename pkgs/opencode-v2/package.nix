# opencode v2, vendored from nixpkgs PR #569770 and owned locally.
#
# Manual bump procedure:
#   1. Set `version` below to the new v2 tag.
#   2. Update `src.hash` (e.g. `nix-prefetch-github anomalyco opencode --rev vX.Y.Z`).
#   3. Update the per-platform `outputHash` from upstream `nix/hashes.json`
#      at that tag (it matches this node_modules derivation).
#   4. `opencode-desktop` follows automatically (inherits version/src/node_modules).
{
  lib,
  stdenv,
  bun,
  darwin,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  models-dev,
  nodejs,
  ripgrep,
  sysctl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}: let
  platform = stdenv.hostPlatform;
  bunCpu =
    if platform.isAarch64
    then "arm64"
    else "x64";
  bunOs =
    if platform.isLinux
    then "linux"
    else "darwin";

  node_modules = finalAttrs:
    stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

      impureEnvVars =
        lib.fetchers.proxyImpureEnvVars
        ++ [
          "GIT_PROXY_COMMAND"
          "SOCKS_SERVER"
        ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
        bun install \
          --cpu="${bunCpu}" \
          --os="${bunOs}" \
          --filter '!./' \
          --filter './packages/cli' \
          --filter './packages/desktop' \
          --filter './packages/app' \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress

        bun --bun ./nix/scripts/canonicalize-node-modules.ts
        bun --bun ./nix/scripts/normalize-bun-binaries.ts

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        find . -type d -name node_modules -exec cp -R --parents {} $out \;

        runHook postInstall
      '';

      # NOTE: Required else we get errors that our fixed-output derivation references store paths
      dontFixup = true;

      # Keep in sync with upstream nix/hashes.json at the pinned version.
      outputHash =
        {
          x86_64-linux = "sha256-6+0Lqv+/nZL4+9QF2SVh21VqMhicCnt84lUvlxoQxjc=";
          aarch64-linux = "sha256-tmKG8kZUa6w6PlX1dKeeNY4dYH6wPV4gBs6ynbvLwz4=";
          aarch64-darwin = "sha256-Khb55UlgZo39zOQ7OCkJXJ8Zottv7SQy3D8N8nlOn/I=";
        }
        .${
          stdenv.hostPlatform.system
        } or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "opencode";
    version = "2.0.26";

    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "anomalyco";
      repo = "opencode";
      tag = "v${finalAttrs.version}";
      hash = "sha256-umhEz5um90EiBHvVZzQw+HoBFO088ZI1g7Ost9BUxhM=";
    };

    postPatch =
      # Relax Bun version check to be a warning instead of an error
      ''
        substituteInPlace packages/script/src/index.ts \
          --replace-fail \
          'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
          'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
      '';

    nativeBuildInputs =
      [
        bun
        installShellFiles
        nodejs
        makeWrapper
        writableTmpDirAsHomeHook
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        darwin.sigtool
      ];

    configurePhase = ''
      runHook preConfigure

      cp -R ${finalAttrs.passthru.node_modules}/. .
      patchShebangs node_modules
      patchShebangs packages/*/node_modules

      runHook postConfigure
    '';

    env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
    env.OPENCODE_DISABLE_MODELS_FETCH = true;
    env.OPENCODE_VERSION = finalAttrs.version;
    env.OPENCODE_CHANNEL = "prod";
    env.NODE_OPTIONS = "--max-old-space-size=4096";

    buildPhase = ''
      runHook preBuild

      cd ./packages/cli
      bun --bun ./script/build.ts --single --skip-install

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 dist/cli-*/bin/opencode $out/bin/opencode
      wrapProgram $out/bin/opencode \
        --prefix PATH : ${
        lib.makeBinPath (
          [
            ripgrep
          ]
          ++ lib.optionals stdenv.hostPlatform.isDarwin [
            sysctl
          ]
        )
      } \
        --set OPENCODE_DISABLE_AUTOUPDATE true \
        --run '
          # nixpkgs previously built OpenCode with OPENCODE_CHANNEL=stable. "stable"
          # is no longer an upstream channel, so it caused OpenCode to store its database
          # as opencode-stable.db. After switching to the upstream production channel,
          # OpenCode would normally use opencode.db instead, making existing sessions
          # appear to be lost. Keep using the legacy database until the user migrates
          # it, unless they explicitly configured OPENCODE_DB or disabled this workaround.

          data_home="''${XDG_DATA_HOME:-$HOME/.local/share}"
          legacy="$data_home/opencode/opencode-stable.db"
          canonical="$data_home/opencode/opencode.db"

          if [ -z "''${OPENCODE_DB:-}" ] \
            && [ -z "''${NIXPKGS_OPENCODE_DISABLE_LEGACY_DB_WORKAROUND:-}" ] \
            && [ -e "$legacy" ] \
            && [ ! -e "$canonical" ]; then
            export OPENCODE_DB="opencode-stable.db"

            # Only show migration guidance when stderr is attached to a terminal.
            # Non-interactive uses such as `opencode web`, services, or scripts
            # should continue starting normally with the legacy database selected.
            if [ -t 2 ]; then
              echo "Detected legacy nixpkgs OpenCode database at $legacy." >&2
              echo "Continuing to use it for compatibility." >&2
              echo "See https://github.com/NixOS/nixpkgs/pull/558549 for migration instructions." >&2
              echo "Set NIXPKGS_OPENCODE_DISABLE_LEGACY_DB_WORKAROUND=1 to disable this workaround." >&2
            fi
          fi
        '

      runHook postInstall
    '';

    postInstall =
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        codesign --force --sign - $out/bin/.opencode-wrapped
      ''
      + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        installShellCompletion --cmd opencode \
          --bash <($out/bin/opencode --completions bash) \
          --zsh <($out/bin/opencode --completions zsh) \
          --fish <($out/bin/opencode --completions fish)
      '';

    dontStrip = true;

    nativeInstallCheckInputs = [
      versionCheckHook
      writableTmpDirAsHomeHook
    ];
    doInstallCheck = true;
    versionCheckKeepEnvironment = [
      "HOME"
      "OPENCODE_DISABLE_MODELS_FETCH"
    ];
    versionCheckProgramArg = "--version";

    passthru = {
      node_modules = node_modules finalAttrs;
    };

    meta = {
      description = "AI coding agent built for the terminal";
      homepage = "https://github.com/anomalyco/opencode";
      changelog = "https://github.com/anomalyco/opencode/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        delafthi
        DuskyElf
        graham33
      ];
      sourceProvenance = with lib.sourceTypes; [fromSource];
      platforms = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
      ];
      mainProgram = "opencode";
    };
  })
