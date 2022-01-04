use <threads-library-by-cuiso-v1.scad>


boxHeight = 30;
// Outside diameter
boxDiameter = 30;

wallThicness = 2;

thread_clearence = 0.4;
thread_height = 10;

/* [Hidden] */
$fn=30;

box();
%translate([0,0,boxHeight - thread_height]){
  cap();
}

module box () {
  difference() {
    union(){
      cylinder(d=boxDiameter, h=boxHeight - thread_height);
      translate([0,0,boxHeight - thread_height]){ 
	thread_for_screw_fullparm(diameter=boxDiameter, length=thread_height,
				  pitch=wallThicness - thread_clearence, divs=$fn);
      }
    }
    
    translate([0,0, wallThicness]){ 
      cylinder(d=boxDiameter-wallThicness*2, h=boxHeight-wallThicness + 0.01);
    }
  }
}


module cap (){
  difference(){
    cylinder(d=boxDiameter+wallThicness*2, h=thread_height +wallThicness );
    thread_for_nut_fullparm(diameter=boxDiameter, length=thread_height,
			    pitch=wallThicness - thread_clearence, divs=$fn,
			    usrclearance=0.1);
  }
}
