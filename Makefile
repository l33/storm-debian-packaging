DOCKER_IMAGE:=storm-packaging
DOCKER_CONTAINER:=storm-packaging

all:
	cd storm-deb-packaging && \
	dpkg-buildpackage -rfakeroot
	mkdir -p target
	mv apache-storm_* storm*.deb target

clean:
	rm -rf target downloads \
	storm-deb-packaging/build \
	storm-deb-packaging/debian/apache-storm \
	storm-deb-packaging/orig \
	storm-deb-packaging/debian/files \
	storm-deb-packaging/apache-storm-*/ \
	storm-deb-packaging/debian/storm/

docker_image: Dockerfile
	docker inspect -f {{.Id}} --type=image $(DOCKER_IMAGE) >/dev/null 2>&1 || \
	docker build -t $(DOCKER_IMAGE) .

docker_build: docker_image
	docker run -ti --name $(DOCKER_CONTAINER) -v $(shell pwd):/app $(DOCKER_IMAGE) make

docker_clean: clean
	docker inspect -f {{.Id}} --type=container $(DOCKER_CONTAINER) >/dev/null 2>&1 && \
	docker rm -f $(DOCKER_IMAGE) || true
	docker inspect -f {{.Id}} --type=image $(DOCKER_IMAGE) >/dev/null 2>&1 && \
	docker rmi $(DOCKER_IMAGE) || true
