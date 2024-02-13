#!/usr/bin/env bash
VENV_PATH="$HOME/.local/share/tnk_venv"

if ! [[ -d "$VENV_PATH" ]]; then
  echo "Creating $VENV_PATH dir"
  python3 -m venv "$VENV_PATH"
  source "$VENV_PATH/bin/activate"
  echo "Installing packages"
  pip install -r ./requirements.txt
  deactivate
  echo "Done."
fi

export BLOCK_FORMAT=1
source "$VENV_PATH/bin/activate"
python __main__.py "$@"