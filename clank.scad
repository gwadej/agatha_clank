outer=45;
aspect=1.1;
rjoint=5;
joint_gap=2*rjoint-3;
joint_fudge=0.15;
filament_diam=3;
filament_adj=0.2;
r_hole=(filament_diam+filament_adj)/2;
r_eye=12;

front_plate=1;
back_plate=2;
limbs_plate=3;
eye_plate=4;
arms_plate=5;
legs_plate=6;

plate=arms_plate;

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

module front() {
    side=2*outer+10;
    intersection() {
        body();
        translate([0,0,side/2]) cube([side,side,side], center=true );
    }
}

module back() {
    rotate(a=[0,180])
    intersection() {
        body();
        translate([0,0,-50]) cube([100,100,100], center=true );
    }
}

module body() {
    thick=9;
    sep=5;
    difference() {
        union() {
            scale([1,aspect,1]) core( outer, thick, sep );
            translate([0,0,thick]) cylinder( r=r_eye+2, h=2, center=true );
        }
        translate([0,0,sep]) sphere( r=r_eye+0.2 );
    }
}

module core( outer, thick, sep ) {
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
        translate([ outer,0,0]) limb_hole( joint_gap, thick );
        translate([-outer,0,0]) mirror([1,0,0]) limb_hole( joint_gap, thick );
        // Attach legs here
        rotate([0,0,-(90-langle)]) translate([outer+1,0,0]) rotate([0,0,-ltheta]) limb_hole( joint_gap, thick );
        rotate([0,0,-(90+langle)]) translate([outer+1,0,0]) rotate([0,0, ltheta]) limb_hole( joint_gap, thick );
    }
}

module limb_hole( joint_gap, thick ) {
    cube([joint_gap*2,joint_gap,thick*3], center=true);
    translate([-joint_gap/2,0,0]) sphere( r=rjoint, $fn=20 );
}

module stem_shaft() {
    stem_height=8;
    stem_radius=1.5;
    union() {
        translate([0,0,stem_height/2]) cylinder( r=stem_radius, h=stem_height, center=true, $fn=10 );
        translate([0,0,1.25*stem_height]) cylinder( r1=stem_radius, r2=2*stem_radius, h=0.75*stem_height, center=true, $fn=10 );
    }
}

module bolts( ring ) {
    num=7;
    diam=3;
    for( i = [0 : num-1] ) {
        rotate( a=[0,0,(i+0.5)*360/num] )
        translate([0,ring,0])
        sphere( r=diam, center=true, $fn=20 );
    }
}

module eye(r) {
    difference() {
        sphere( r=r );
        translate([0,0,r-0.5]) cylinder( h=2, r=5.5, center=true );
        translate([0,0,r-1]) cylinder( h=3.5, r=2, center=true, $fn=30 );
    }
}

module stem() {
    w_thick=3;
    union() {
        translate([0,0,w_thick/2]) cylinder( r=5, h=w_thick, center=true );
        stem_shaft();
    }
}

module arm() {
    length=outer/2;
    width=1.4*rjoint;
    difference() {
         union() {
            translate([0,0,length/2]) cube( [width, width, length], center=true );
            translate([0,0,length+0.25*rjoint]) hand( rjoint/2 );
        }
         cylinder( h=10, r=r_hole, center=true, $fn=8 );
    }
}

module shoulder() {
    difference() {
        translate([0,0,0.80*rjoint]) sphere( r=rjoint+joint_fudge, center=true, $fn=20 );
        cylinder( h=10, r=r_hole, center=true, $fn=8 );
    }
}

module hand( rwrist ) {
    union() {
        sphere( r=rwrist, center=true, $fn=20 );
        translate([0,0,rwrist*1.5]) rotate([0,90,90])
            cylinder( h=rwrist*2, r=0.75*rwrist, center=true, $fn=10 );
        translate([0, rwrist-0.75,0.25*rwrist]) rotate([0,15,0]) finger( 0.75*rwrist, 1.5, 3*rwrist );
        translate([0,-rwrist+0.75,0.25*rwrist]) rotate([0,15,0]) finger( 0.75*rwrist, 1.5, 3*rwrist );
        translate([0,0,0.25*rwrist]) rotate([0,15,180]) finger( 0.75*rwrist, 1.5, 3*rwrist );
    }
}

module finger( base, thick, length ) {
    translate([0,0,length/2]) rotate([90,0,0]) linear_extrude( height=thick, convexity=5, center=true )
        polygon( points=[[-base/2,0], [-base/2,length], [base/2,0]], paths=[[0,1,2]] );
}

module leg() {
    length=outer/2;
    upper=0.6*length;
    lower=1.1*(length-upper);
    width=1.1*rjoint;
    foot=1.3*rjoint;
    difference() {
        union() {
            translate([0,0,1+1.6*rjoint+length]) sphere( r=rjoint+joint_fudge, center=true, $fn=20 );
            translate([0,0,1+length-upper/2+0.80*rjoint]) rotate([0,0,45]) cylinder( h=upper, r2=width, r1=0.75*width, center=true, $fn=4 );
            translate([0,0,1+rjoint/2+lower/1.1]) sphere( r=rjoint/2, center=true, $fn=20 );
            translate([0,0,1+lower/2]) cube( [foot,4,lower], center=true );
            translate([0,foot-2,1]) cube( [foot, 2*foot, 2], center=true );
        }
    }
}
