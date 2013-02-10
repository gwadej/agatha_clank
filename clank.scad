outer=45;
aspect=1.1;
stem_radius=3;

rotate( a=[0,0,45] ) {
    front();
    //back();
}

module front() {
    side=2*outer+10;
    intersection() {
        body();
        translate([0,0,side/2]) cube([side,side,side], center=true );
    }
}

module back() {
    mirror([0,0,1])
    intersection() {
        body();
        translate([0,0,-50]) cube([100,100,100], center=true );
    }
}

module body() {
    union() {
        scale([1,aspect,1]) core();
        translate([0,0,5]) eye();
    }
}

module core() {
    sep=5;
    dratio=0.1;
    face=36;
    thick=9;
    ring=(outer-face)/2 + face;
    bite=9;
    difference() {
        union() {
            cylinder( h=thick, r=outer, center=true );
            cylinder( h=thick+1, r=face+1.5, center=true );
            translate([0,0, sep]) scale([1,1,dratio]) sphere( r=face );
            translate([0,0,-sep]) scale([1,1,dratio]) sphere( r=face );
            translate([0,0, thick/2]) bolts( ring );
            translate([0,0,-thick/2]) bolts( ring );
        }
        stem_hole( outer );
        // Attach arms here
        translate([ outer,0,0]) limb_hole( bite, thick );
        translate([-outer,0,0]) mirror([1,0,0]) limb_hole( bite, thick );
        // Attach legs here
        rotate([0,0,-67]) translate([ outer,0,0]) limb_hole( bite, thick );
        rotate([0,0,-112]) translate([ outer,0,0]) limb_hole( bite, thick );
    }
}

module limb_hole( bite, thick ) {
    cube([bite*2,bite,thick*3], center=true);
    translate([-bite/2,0,0]) sphere( r=(bite+2)/2, $fn=20 );
}

module stem_hole(offset) {
    translate([0,offset,0]) rotate(a=[90,0,0]) cylinder( h=6, r=stem_radius, center=true );
}

module bolts( ring ) {
    num=16;
    diam=2.5;
    for( i = [0 : num-1] ) {
        rotate( a=[0,0,(i+0.5)*360/num] )
        translate([0,ring,0])
        sphere( r=diam, center=true, $fn=20 );
    }
}

module eye() {
    diam=12;
    scale([1,aspect,1]) difference() {
        union() {
            sphere( r=diam );
            translate([0,0,4]) cylinder( r=diam, h=2, center=true );
        }
        translate([0,0,diam-0.5]) cylinder( h=2, r=5.5, center=true );
        translate([0,0,diam-1]) cylinder( h=3.5, r=2, center=true, $fn=30 );
    }
}
