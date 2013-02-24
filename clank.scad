outer=45;
aspect=1.1;
rjoint=5;
joint_fudge=0.15;
filament_diam=3;
filament_adj=0.2;
r_eye=12;

joint_gap=2*rjoint-3;
r_hole=(filament_diam+filament_adj)/2;

front_plate=1;
back_plate=2;
limbs_plate=3;
eye_plate=4;
arms_plate=5;
legs_plate=6;

plate=front_plate;

if( plate == front_plate ) {
    rotate( a=[0,0,45] ) front();
}
if( plate == back_plate ) {
    rotate( a=[0,0,45] ) back();
}
if( plate == limbs_plate ) {
    intersection() {
        union() {
            stem();
            translate([ 40,-20, 0]) leg();
            translate([ 40, 20, 0]) leg();
            translate([ 20,-20, 0]) shoulder();
            translate([ 20, 20, 0]) shoulder();
            translate([-20,-20, 0]) arm();
            translate([-20, 20, 0]) arm();
        }
        translate([0,0,50]) cube([100,100,100], center=true );
    }
}
if( plate == eye_plate ) {
    intersection() {
        translate([0,0,0.75*r_eye]) eye( r_eye );
        translate([0,0,50]) cube([100,100,100], center=true );
    }
}
if( plate == arms_plate ) {
    intersection() {
        union() {
            translate([0,-20, 0]) arm();
            translate([0, 20, 0]) arm();
            translate([ 20, 0, 0]) shoulder();
            translate([-20, 0, 0]) shoulder();
        }
        translate([0,0,50]) cube([100,100,100], center=true );
    }
}
if( plate == legs_plate ) {
    intersection() {
        union() {
            translate([0,-20, 0]) leg();
            translate([0, 20, 0]) leg();
        }
        translate([0,0,50]) cube([100,100,100], center=true );
    }
}

//
// front half of the body
module front() {
    side=2*outer+10;
    intersection() {
        body();
        translate([0,0,side/2]) cube([side,side,side], center=true );
    }
}

//
// back half of the body
module back() {
    rotate(a=[0,180])
    intersection() {
        body();
        translate([0,0,-50]) cube([100,100,100], center=true );
    }
}

//
// Core + eye-hole
module body() {
    // aspect, outer, joint_gap, r_eye
    thick=9;
    sep=5;
    difference() {
        union() {
            scale([1,aspect,1]) core( outer, thick, sep, joint_gap );
            translate([0,0,thick]) cylinder( r=r_eye+2, h=2, center=true );
        }
        translate([0,0,sep]) sphere( r=r_eye+0.2 );
    }
}

//
// the outer ring and inside of the body
module core( outer, thick, sep, jgap ) {
    dratio=0.1;
    face=0.8*outer;
    ring=(outer-face)/2 + face;
    ltheta=7;
    langle=19;
    stem_scale=1.1;
    difference() {
        union() {
            cylinder( h=thick, r=outer, center=true );
            cylinder( h=thick+2, r=face+1, center=true );
            translate([0,0, sep]) scale([1,1,dratio]) sphere( r=face );
            translate([0,0,-sep]) scale([1,1,dratio]) sphere( r=face );
            translate([0,0, thick/2]) bolts( ring );
            translate([0,0,-thick/2]) bolts( ring );
        }

        // hole for stem
        translate([0,outer+5,0]) rotate(a=[90,0,0]) scale([stem_scale,stem_scale,1]) stem_shaft();
        // Attach arms here
        translate([ outer,0,0]) limb_hole( joint_gap, thick, rjoint );
        translate([-outer,0,0]) mirror([1,0,0]) limb_hole( jgap, thick, rjoint );
        // Attach legs here
        rotate([0,0,-(90-langle)]) translate([outer+1,0,0]) rotate([0,0,-ltheta]) limb_hole( jgap, thick, rjoint );
        rotate([0,0,-(90+langle)]) translate([outer+1,0,0]) rotate([0,0, ltheta]) limb_hole( jgap, thick, rjoint );
    }
}

//
// Shape to subtract from body for holes where limbs attach
module limb_hole( jgap, thick, rjoint ) {
    cube([jgap*2,jgap,thick*3], center=true);
    translate([-jgap/2,0,0]) sphere( r=rjoint, $fn=20 );
}

module stem_shaft() {
    height=8;
    radius=1.5;
    union() {
        translate([0,0,height/2]) cylinder( r=radius, h=height, center=true, $fn=10 );
        translate([0,0,1.25*height]) cylinder( r1=radius, r2=2*radius, h=0.75*height, center=true, $fn=10 );
    }
}

//
// Ring of bolts that close the body
module bolts( r_ring ) {
    num=7;
    r_bolt=3;
    for( i = [0 : num-1] ) {
        rotate( a=[0,0,(i+0.5)*360/num] )
        translate([0,r_ring,0])
        sphere( r=r_bolt, center=true, $fn=20 );
    }
}

module eye(r) {
    r_iris=r/2;
    r_pupil=r/6;
    difference() {
        sphere( r=r );
        translate([0,0,r-r/24]) cylinder( h=r/6, r=r_iris, center=true );
        translate([0,0,r-r/12]) cylinder( h=r/3, r=r_pupil, center=true, $fn=30 );
    }
}

//
// stem and winding knob
module stem() {
    t_knob=3;
    r_knob=5;
    union() {
        translate([0,0,t_knob/2]) cylinder( r=r_knob, h=t_knob, center=true );
        stem_shaft();
    }
}

//
// arm and hand
module arm() {
    // outer, rjoint, r_hole
    length=outer/2;
    width=1.4*rjoint;
    peg_depth=10;
    difference() {
         union() {
            translate([0,0,length/2]) cube( [width, width, length], center=true );
            translate([0,0,length+0.25*rjoint]) hand( rjoint/2 );
        }
         cylinder( h=peg_depth, r=r_hole, center=true, $fn=8 );
         // force more material in this area
         for(a=[45,135,225,315]) {
            rotate(a=[0,0,a]) translate([0.4*width,0,0]) cylinder( h=peg_depth, r=0.2, center=true, $fn=8 );
        }
    }
}

module shoulder() {
    // rjoint, joint_fudge, r_hole
    peg_depth=10;
    difference() {
        translate([0,0,0.80*rjoint]) sphere( r=rjoint+joint_fudge, center=true, $fn=20 );
        cylinder( h=peg_depth, r=r_hole, center=true, $fn=8 );
    }
}

module hand( rwrist ) {
    thick=1.5;
    union() {
        //wrist
        sphere( r=rwrist, center=true, $fn=20 );
        //hand-cylinder
        translate([0,0,rwrist*1.5]) rotate([0,90,90])
            cylinder( h=rwrist*2, r=0.75*rwrist, center=true, $fn=10 );
        //fingers
        translate([0, rwrist-0.75,0.25*rwrist]) rotate([0,15,0]) finger( 0.75*rwrist, thick, 3*rwrist );
        translate([0,-rwrist+0.75,0.25*rwrist]) rotate([0,15,0]) finger( 0.75*rwrist, thick, 3*rwrist );
        translate([0,0,0.25*rwrist]) rotate([0,15,180]) finger( 0.75*rwrist, thick, 3*rwrist );
    }
}

module finger( base, thick, length ) {
    translate([0,0,length/2]) rotate([90,0,0]) linear_extrude( height=thick, convexity=5, center=true )
        polygon( points=[[-base/2,0], [-base/2,length], [base/2,0]], paths=[[0,1,2]] );
}

//
// Includes hip and foot.
module leg() {
    //outer, rjoint, joint_fudge
    length=outer/2;
    upper=0.6*length;
    lower=1.1*(length-upper);
    width=1.1*rjoint;
    foot=1.3*rjoint;
    ankle_thk=4;

    difference() {
        union() {
            //hip
            translate([0,0,1+1.6*rjoint+length]) sphere( r=rjoint+joint_fudge, center=true, $fn=20 );
            translate([0,0,1+length-upper/2+0.80*rjoint]) rotate([0,0,45]) cylinder( h=upper, r2=width, r1=0.75*width, center=true, $fn=4 );
            //knee
            translate([0,0,1+rjoint/2+lower/1.1]) sphere( r=rjoint/2, center=true, $fn=20 );
            //ankle/foot
            translate([0,     0,1+lower/2]) cube( [foot,ankle_thk,lower], center=true );
            translate([0,foot-2,        1]) cube( [foot, 2*foot, 2], center=true );
        }
    }
}
