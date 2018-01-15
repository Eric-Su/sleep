all: sleep

sleep: sleep.nim
	nim c -d:release sleep.nim

docker: sleep.nim
	docker run --rm -v `pwd`:/usr/src/app -w /usr/src/app -u `id -u $$USER`:`id -g $$USER`  nimlang/nim nim c -d:release sleep.nim

clean:
	rm -rf nimcache sleep

