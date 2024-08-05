default:
    just format
    just run

switch:
    just format
    just diff
    just commit

run:
    nix run .

format:
    stylua .

diff:
    #!/usr/bin/env bash
    set -euxo pipefail

    if ! git diff --quiet || ! git diff --quiet --cached; then
        git diff -U0
        git diff --cached -U0
    else
        echo "No changes detected."
    fi

commit:
    #!/usr/bin/env bash
    set -euxo pipefail

    if ! git diff --quiet || ! git diff --quiet --cached; then
        gen=$(darwin-rebuild --list-generations | grep current)
        git commit -am "$gen"
        git push --quiet
    else
        echo "No changes to commit."
    fi