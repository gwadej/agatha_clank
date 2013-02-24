agatha_clank
============

OpenScad file for creation of the STL files for a 3D model based on Agatha's little Clank
from [Girl Genius](http://girlgeniusonline.com/).

The resulting model has poseable arms and legs. The model's eye can be positioned to look
in various directions. Finally, the winding knob on the top will turn. With a little practice
you should be able to stand the little clank.

The Model
---------

The model consists of 4 STL files and the OpenSCAD file used to create them.

* clank-front.stl
* clank-back.stl
* clank-limbs.stl
* clank-eye.stl

Print one of each of these to have all of the parts needed to assemble the clank model.

You can generate each of the STL files using the clank.scad file. The variable _plate_
controls which STL file will be generated. There are also two extra STLs that are subsets
of the clank-limbs.stl objects.

Assembly
--------

The clank-limbs.stl file should be printed with 0.30mm thickness, 1 shell, and 60% infill.
All other plates are printed with 0.30mm thickness, 2 shells, and 35% infill.

Assembly of the model is not 100% obvious until you've done it once. Print all of the
pieces and clean up the parts, if necessary.

1. From the clank-limbs.stl, take the round shoulder objects and the arms (long rectangles
   pinchers on the end).
2. Cut two pieces of 3mm filament a little less than 1cm long.
3. Apply a small amount of acetone or glue to the filament and the openings on the arm and
   shoulder.
4. Use the filament to attach the shoulder to the arm.
5. Repeat for the other arm.
6. Carefully smooth out any droopy stuff in the cavity in the back piece.
7. Place the flat part of the eye (the part without the hole) in the cavity in back piece.
8. Push the front piece on over the eye until the eye snaps into the front piece and the
   back and front are flat together.
9. Separate the back and front.
10. Place the cone part of the stem into the cavity in the top of the back.
11. Brush acetone or glue on the flat portions of the back and front. Be careful not to
    get any on or too close to the eye or stem.
12. Line up the front and back. Stick them together and hold until the joint sets.
13. Brush a little acetone or glue around the joint being careful not to get any on the
    stem or into the gaps where the arms and legs go.
14. After everything is dry, snap the arms and legs into the appropriate holes.
15. Enjoy.
