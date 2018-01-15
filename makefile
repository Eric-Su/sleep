release: sleep

docker: docker_cmd = docker run --rm -v `pwd`:/usr/src/app -w /usr/src/app -u `id -u $$USER`:`id -g $$USER`  nimlang/nim
docker: sleep
	 
all: release

sleep: sleep.nim
	${docker_cmd} nim c -d:release sleep.nim

clean:
	rm -rf nimcache sleep

