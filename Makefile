REGISTRY ?= ghcr.io/lazypower
IMAGE    ?= fusion
TAG      ?= latest
ARCHS    ?= amd64,arm64

KEY_PRIV  = melange.rsa
KEY_PUB   = melange.rsa.pub
PACKAGES  = ./packages

.PHONY: all keygen package image push clean

all: package image

keygen: $(KEY_PRIV)

$(KEY_PRIV):
	melange keygen

package: $(KEY_PRIV)
	melange build melange.yaml \
		--arch $(ARCHS) \
		--signing-key $(KEY_PRIV)

image: $(KEY_PUB)
	apko build apko.yaml \
		$(REGISTRY)/$(IMAGE):$(TAG) \
		$(IMAGE).tar \
		--keyring-append $(KEY_PUB)

push: image
	docker load < $(IMAGE).tar
	docker push $(REGISTRY)/$(IMAGE):$(TAG)

clean:
	rm -rf $(PACKAGES) $(IMAGE).tar sbom-*.json
