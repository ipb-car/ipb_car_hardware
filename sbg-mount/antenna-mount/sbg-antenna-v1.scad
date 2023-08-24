// include external resources
include <screw_holes.scad>
$fn=50;

/* [Antenna] */
antenna_diameter = 69;
antenna_height = 22;
screw_to_border = 7;    // space between M3 hole and border
/* [Hidden] */
distance_between_holes = 40;

/* [Antenna wall] */
wall_height = 0.5*antenna_height;
wall_width = 5; // minimum antenna wall width, some parts will be bigger
wall_thickness = antenna_diameter + wall_width;

/* [Plate handle] */
mount_length = distance_between_holes + (2 * screw_to_border );
half_mount_length = mount_length / 2;

/* [Main Plate] */
plate_handle_length = 25; // distance between wall and border
plate_thickness = 10; // the main thickness of the whole thing
plate_length = wall_thickness + 2*plate_handle_length;
plate_width = mount_length;

/* [M8 screw params(mount)] */
m8_diameter = 8.5;
m8_hole_off = plate_handle_length/2;
m8_screw_hole_x = plate_length/2 - m8_hole_off;

/* [M3 screw params(antenna)] */
m3_screw_top_width = 5;
m3_screw_top_height = 2;
m3_screw_angle = 90;
m3_screw_hole_x = half_mount_length - screw_to_border;
m3_screw_hole_y = half_mount_length - screw_to_border;

// Main Plate
difference(){
    // Base plate
    linear_extrude(plate_thickness){
        square([plate_length, plate_width], center = true);
    }

    // holes for mounting to Alu-profile
    translate([+m8_screw_hole_x, 0, 0]) cylinder(h=plate_thickness, d=m8_diameter);
    translate([-m8_screw_hole_x, 0, 0]) cylinder(h=plate_thickness, d=m8_diameter);

    // holes for mounting antenna
    translate([+m3_screw_hole_x, +m3_screw_hole_y, 0]) screw_hole([m3_screw_top_width, m3_screw_top_height, m3_screw_angle], M3, plate_thickness);
    translate([+m3_screw_hole_x, -m3_screw_hole_y, 0]) screw_hole([m3_screw_top_width, m3_screw_top_height, m3_screw_angle], M3, plate_thickness);
    translate([-m3_screw_hole_x, +m3_screw_hole_y, 0]) screw_hole([m3_screw_top_width, m3_screw_top_height, m3_screw_angle], M3, plate_thickness);
    translate([-m3_screw_hole_x, -m3_screw_hole_y, 0]) screw_hole([m3_screw_top_width, m3_screw_top_height, m3_screw_angle], M3, plate_thickness);
}

// Wall with diameter-wide hole for the antenna
difference() {
    translate([0, 0, plate_thickness+wall_height/2]) cube([wall_thickness, plate_width, wall_height], center=true);
    translate([0, 0, plate_thickness+wall_height/2]) cylinder(h=wall_height, d=antenna_diameter, center=true);
}
