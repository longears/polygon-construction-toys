
// CONSTANTS

sides = 5;
is_rounded = 1;
show_axis_line = 0;



sidelen = 50;

pad_offset = sidelen * 0.22;

tall = 6;
thick = 3;




// TRIGONOMETRY

PI = 3.14159265359;

inner_angle = 360 / (sides * 2);
outer_angle = 90 - inner_angle;

echo("sides = ",sides);
echo("inner_angle = ",inner_angle);
echo("outer_angle = ",outer_angle);

minrad = sidelen * tan(outer_angle)/2;
maxrad = sidelen / (2*cos(outer_angle));

echo("minrad = ",minrad);
echo("maxrad = ",maxrad);


/*
// for sides = 3

nub_rad = (tall-1.5)/2;
nub_min_rad = nub_rad * 0.4;
nub_protrusion_male = 0.37;
nub_protrusion_female = 0.45;
nub_clearance = 0.25; // shift paired pads apart a bit

stick_in_dist_center_pad = 4.5;
stick_in_dist_outer_pad = 4.07;
stick_in_dist_inner_pad = 6.5;
diagonal_strut_length = 17.32;
diagonal_strut_spin_offset = 0;
*/


// for sides = 5

nub_rad = (tall-1.5)/2;
nub_min_rad = nub_rad * 0.4;
nub_protrusion_male = 0.45;
nub_protrusion_female = 0.45;
nub_clearance = 0.25; // shift paired pads apart a bit

stick_in_dist_center_pad = 5 + 35 * 0 + 9 * 0;
stick_in_dist_outer_pad =  7 + 35 * 0 + 9 * 0;
stick_in_dist_inner_pad =  5;
outer_frame_pct = 0.79;
diagonal_strut_length = (maxrad * outer_frame_pct - 2 - 6) * 0;
diagonal_strut_spin_offset = 10;
diagonal_strut_backoffset = -7;
circle_outer_rad = minrad * 0.85;
circle_faces = 32;

show_preview = 1;






module polygon() {

// circle
difference() {
	cylinder(h=tall,  r=circle_outer_rad,center=true,$fn=circle_faces);
	cylinder(h=tall*2,r=circle_outer_rad-thick,center=true,$fn=circle_faces);
}

for (i=[1:sides]) {
	rotate([0,0,i*360/sides]) {
		translate([-minrad,0,0]) {
			// axis line
			if(show_axis_line == 1) {
				color("cyan") translate([-0.5,-sidelen/2,-0.5]) cube([1,sidelen,1]);
			}


			// diagonal strut
			if(diagonal_strut_length > 0) {
				translate([minrad + diagonal_strut_backoffset,-thick/2 + diagonal_strut_spin_offset,-tall/2]) cube([diagonal_strut_length - diagonal_strut_backoffset,thick,tall]);
			}

			intersection() {
				// rounding the edges
				if (is_rounded == 1) {
					union() {
						// cylinder
						translate([0,sidelen/2,0]) rotate([90,0,0]) cylinder(h=sidelen,r=tall/2,$fn=32);
						// long box
						translate([0,-sidelen/2,-tall/2]) cube([sidelen,sidelen,tall]);
					}
				}
				// the pads themselves
				union() {

					// center pad
					translate([-tall/2,-thick/2 + pad_offset,-tall/2]) {
						difference() {
							cube([tall+stick_in_dist_center_pad,thick,tall]);
							// inner nub
							color("red") translate([tall/2,nub_protrusion_female-0.001,tall/2]) rotate([90,0,0]) cylinder(h=nub_protrusion_female,r1=nub_min_rad,r2=nub_rad,$fn=16);
							// inner nub
							color("orange") translate([tall/2,thick+0.001,tall/2]) rotate([90,0,0]) cylinder(h=nub_protrusion_female,r1=nub_rad,r2=nub_min_rad,$fn=16);
						}
					}

					// outer pad
					translate([-tall/2,-thick/2 - pad_offset-thick - nub_clearance,-tall/2]) {
						cube([tall+stick_in_dist_outer_pad,thick,tall]);
						color("green") translate([tall/2,thick+nub_protrusion_male-0.001,tall/2]) rotate([90,0,0]) cylinder(h=nub_protrusion_male,r1=nub_min_rad,r2=nub_rad,$fn=16);
					}
					// inner pad
					translate([-tall/2,-thick/2 - pad_offset+thick + nub_clearance,-tall/2]) {
						cube([tall+stick_in_dist_inner_pad,thick,tall]);
						color("cyan") translate([tall/2,0.001,tall/2]) rotate([90,0,0]) cylinder(h=nub_protrusion_male,r1=nub_rad,r2=nub_min_rad,$fn=16);
					}

				}
			}
		}
	}
}

}



polygon();


if(show_preview == 1) {
for (i=[1:sides]) {
	rotate([0,0,-360/5 * i]) {
		translate([-minrad,0,0]) {
			rotate([0,-180-116.57,180]) {
				translate([minrad,0,0]) {
				polygon();
				}
			}
		}
	}
}
}



