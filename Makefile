.DEFAULT_GOAL = update

.PHONY: update
update:
	home-manager --extra-experimental-features "nix-command flakes" switch \
		--flake ./home/#"${PROFILE_NAME}"

.PHONY: clean
clean:
	nix-collect-garbage -d

