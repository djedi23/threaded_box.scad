// Threaded box + cap
// Valvassori Moïse <moise.valvassori@gmail.com> -- 2022

// Dependency https://www.thingiverse.com/thing:3131126
// Copy threads-library-by-cuiso-v1.scad in the same directory

use <threads-library-by-cuiso-v1.scad>

// Cylinders quality. Remove the draft before generating the stl file
draft=true;
part_selection = 0; // [0:"Assembly",1:"Box only",2:"Cap only",3:"Printer ready"]

/* [Sizes] */
box_height = 30; // [1:200]
// Outside diameter of the box. The cap will be larger.
box_diameter = 30; // [1:200]

wall_thickness = 2;


/* [Thread] */
// Thread/ inside wall distance. Default 0.4 is my nozzle size.
thread_clearence = 0.4;
thread_height = 5; // [2:30]

/* [Grip] */
grip = false;
// Size of the "bumps"
grip_size = 2;
// 1.1 = 10% spacing.  real spacing = grip_size * grip_spacing
grip_spacing = 1.1;

/* [Holes] */
// Add a hole in the bottom of the box ?
box_hole = false;
box_hole_diameter = 3; // [1:190]
// Add a hole in the cap ?
cap_hole = false;
cap_hole_diameter = 3; // [1:190]

/* [Hidden] */
$fn=draft?30:100;
epsilon = 0.01;

cap_height = thread_height + wall_thickness;

if (part_selection == 0) {			  /* layout box + cap */
  box();
  translate([0,0,box_height - thread_height]){
    cap();
  }
 } else if (part_selection == 1) {		  /* layout box only */
  box();
 } else if (part_selection == 2) {		  /* layout cap only */
  translate([0,0,cap_height])
    rotate([180,0,0])
    cap();
 } else if (part_selection == 3) {		  /* layout box + cap ready for 3d printing */
  offset = box_diameter/2 + wall_thickness + grip_size+5;
  translate([-offset,0,cap_height])
  rotate([180,0,0])
    cap();

  translate([offset,0,0])
    box();
 }

module box () {
  difference() {
    union(){
      cylinder(d=box_diameter, h=box_height - thread_height);
      translate([0,0,box_height - thread_height]){
	thread_for_screw_fullparm(diameter=box_diameter, length=thread_height,
				  pitch=wall_thickness - thread_clearence, divs=$fn);
      }
    }
    translate([0,0, wall_thickness]){
      cylinder(d=box_diameter - wall_thickness*2, h=box_height - wall_thickness + epsilon);
    }

    if (box_hole)
      cylinder(d=box_hole_diameter, h=wall_thickness + epsilon);

  }
}


module cap (){
  d = box_diameter+ wall_thickness*2;
  difference(){
    cylinder(d=box_diameter+wall_thickness*(grip?1:2), h=cap_height );
    thread_for_nut_fullparm(diameter=box_diameter, length=thread_height,
			    pitch=wall_thickness - thread_clearence, divs=$fn,
			    usrclearance=0.5, entry=0);
    if (cap_hole)
      translate([0,0,thread_height])
	cylinder(d=cap_hole_diameter, h=wall_thickness + epsilon);
  }

  if (grip)
    difference(){
      for (i=[0:grip_spacing*grip_size*360.0/(PI*d):360])
	rotate([0,0,i])
	  translate([d/2 - wall_thickness/2,0,0]) {
	  cylinder(d=grip_size, h=cap_height, $fn=$fn/7);
	}
      cylinder(d=box_diameter+wall_thickness, h=cap_height + epsilon );
    }
}
