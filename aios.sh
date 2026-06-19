#!/usr/bin/env bash

podman run \
	 --rm -it --name emacs-ai-os \
	--network host -v ~/.emacs.d:/root/.emacs.d:Z \
	-v ~/.ssh:/root/.ssh:ro,Z \
	silex/emacs:30-alpine
