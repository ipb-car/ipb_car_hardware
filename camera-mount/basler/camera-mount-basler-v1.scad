// include external resources
include <screw_holes.scad>

// IPB-CAR Camera holder
$fn=50;
tol = 0.5;

// camera params
camLength = 42;
camWidth = 29;
camHeight = 29;
wallThickness = 10;
wallHeight = 0.75*camHeight;
camHole1OffY = camLength/2 - 15; 
camHole2OffY = camLength/2 - 3.2;
camHole2OffX = camWidth/2 -4.6;

// plate params
plateHandleLength = 25;
plateLength = camWidth + 2*wallThickness + 2*plateHandleLength;
plateWidth = camLength+5;
plateThickness = 13;
mountHoleDia = 8.5; // M8 screws
mountHoleOff = plateHandleLength/2;

// M3 screw params
screwTopWidth = 5;
screwTopHeight = 2;
screwAngle = 90;

// base plate
difference(){

    //plate    
    linear_extrude(plateThickness){
        square([plateLength, plateWidth], center = true);
    }

    // holes for mounting to Alu-profile
    translate([plateLength/2-mountHoleOff, -camHole1OffY, 0])  cylinder(h=plateThickness,d=mountHoleDia);
    translate([-plateLength/2+mountHoleOff, -camHole1OffY, 0]) cylinder(h=plateThickness, d=mountHoleDia);

    // holes for mounting camera
    translate([0, -camHole1OffY, 0]) screw_hole([5, 2, 90], M3, plateThickness);
    translate([-camHole2OffX,  camHole2OffY, 0]) screw_hole([screwTopWidth, screwTopHeight, screwAngle], M3, plateThickness);
    translate([camHole2OffX,  camHole2OffY, 0]) screw_hole([5, 2, 90], M3, plateThickness);
}

// walls for camera
translate([-(camWidth+wallThickness+tol)/2,0,plateThickness+wallHeight/2]) cube([wallThickness,plateWidth,wallHeight], center=true);
translate([(camWidth+wallThickness+tol)/2,0,plateThickness+wallHeight/2]) cube([wallThickness,plateWidth,wallHeight], center=true);