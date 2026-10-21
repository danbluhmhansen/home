# Helix, built from the helix-editor/helix flake with a patched set of
# tree-sitter grammars.
#
# The flake builds its grammars from the revisions pinned in `languages.toml`.
# The pinned Perl grammar (72a08a49) vendors its own copy of `bsearch`, which
# stopped compiling against glibc 2.44: in C23 mode glibc defines `bsearch` as
# a macro expanding to `_Generic`, so the vendored definition turns into
# `void *_Generic(...)` and fails to parse.
#
# tree-sitter-perl#220 fixed this upstream by renaming the vendored function
# to `tsp_bsearch`, but Helix still pins the pre-fix revision. Until that pin
# moves, drop the vendored copy and let the grammar use the libc
# implementation instead, the same way nixpkgs handles its own
# `tree-sitter-perl` package.
#
# The workaround deliberately fails the build once the pinned grammar stops
# vendoring `bsearch`, so that it gets removed instead of silently rotting.
#
# The workaround is applied to the grammar build, not to a copy of the Helix
# sources, so that evaluating this configuration for a foreign platform does
# not need to build anything.
{
  callPackage,
  lib,
  helixSource,
  helixRev,
}: let
  # Upstream's grammars.nix reads its language list from ./languages.toml,
  # which only resolves while the file sits next to it. The patched copy lives
  # in the store on its own, so point it at the file in the flake's source.
  languagesToml = "${helixSource}/languages.toml";

  # The workaround itself, applied while unpacking every grammar. It only
  # touches the Perl grammar, the only one vendoring its own `bsearch`.
  #
  # `grep` for the vendored definition rather than for the file: once upstream
  # renames it to `tsp_bsearch`, the file is still there but the clash with
  # glibc is gone, and the build has to fail so this workaround gets removed.
  bsearchWorkaround = ''
    postPatch = lib.optionalString (grammar.name == "perl") '''
      if ! grep -q 'void \*bsearch(' src/bsearch.c 2>/dev/null; then
        echo "helix: the pinned Perl grammar no longer vendors its own bsearch." >&2
        echo "helix: the glibc 2.44 workaround in pkgs/helix/package.nix is obsolete." >&2
        echo "helix: Remove it once Helix pins a fixed tree-sitter-perl revision." >&2
        exit 1
      fi

      rm src/bsearch.c
      substituteInPlace src/tsp_unicode.h \
        --replace-fail '#include "bsearch.c"' ""
    ''';
  '';

  grammarsSource = builtins.readFile "${helixSource}/grammars.nix";

  patchedGrammarsSource = let
    patched =
      lib.replaceStrings [
        "builtins.readFile ./languages.toml"
        "      SHARED_LIB = grammar.name + stdenv.hostPlatform.extensions.sharedLibrary;"
      ] [
        "builtins.readFile ${languagesToml}"
        ''
          ${bsearchWorkaround}

          SHARED_LIB = grammar.name + stdenv.hostPlatform.extensions.sharedLibrary;
        ''
      ]
      grammarsSource;
  in
    if !(lib.hasInfix "builtins.readFile /nix/store/" patched && lib.hasInfix "postPatch = lib.optionalString" patched)
    then throw "pkgs/helix/package.nix: upstream changed grammars.nix, the workaround needs to be updated"
    else patched;

  patchedGrammars = callPackage (builtins.toFile "helix-grammars.nix" patchedGrammarsSource) {};

  # Upstream's default.nix picks its grammars up with `callPackage
  # ./grammars.nix`; hand it the patched ones instead.
  grammarsCallPackage = f: args:
    if toString f == "${helixSource}/grammars.nix"
    then patchedGrammars
    else callPackage f args;
in
  callPackage "${helixSource}/default.nix" {
    gitRev = helixRev;
    callPackage = grammarsCallPackage;
  }
