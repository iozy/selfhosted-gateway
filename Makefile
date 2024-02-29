.PHONY: docker link setup gateway ci

docker:
	docker build -t iozy/gateway-link:latest ./src/gateway-link/
	docker build -t iozy/gateway-client:latest ./src/client-link/
	docker build -t iozy/gateway-cli:latest ./src/create-link/

setup:
	docker network create rpgw

link:
	docker run -e SSH_AGENT_PID=$$SSH_AGENT_PID -e SSH_AUTH_SOCK=$$SSH_AUTH_SOCK -v $$SSH_AUTH_SOCK:$$SSH_AUTH_SOCK --rm -it fractalnetworks/gateway-cli:latest $(GATEWAY) $(FQDN) $(EXPOSE)

link-macos:
	docker run -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" --rm -it fractalnetworks/gateway-cli:latest $(GATEWAY) $(FQDN) $(EXPOSE)

link-ci:
	./ci/create-link-ci.sh gateway-sshd app.example.com nginx:80
