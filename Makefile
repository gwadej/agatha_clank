# Makefile for the Agatha's Clank project

STLS=\
	clank-front.stl \
	clank-back.stl \
	clank-limbs.stl \
	clank-eye.stl

EXTRAS=\
	clank-arms.stl \
	clank-legs.stl

clank: $(STLS)

extra: $(EXTRAS)

all: clank extra

clobber:
	rm $(STLS) $(EXTRAS)

clank-front.stl: clank.scad
	openscad -o $@ -D'plate=1' $<

clank-back.stl: clank.scad
	openscad -o $@ -D'plate=2' $<

clank-limbs.stl: clank.scad
	openscad -o $@ -D'plate=3' $<

clank-eye.stl: clank.scad
	openscad -o $@ -D'plate=4' $<

clank-arms.stl: clank.scad
	openscad -o $@ -D'plate=5' $<

clank-legs.stl: clank.scad
	openscad -o $@ -D'plate=6' $<
