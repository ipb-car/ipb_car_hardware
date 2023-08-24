// include external resources
include <screw_holes.scad>

/* [Hidden] */
$fn=50;

/* [IMU] */
imu_width = 46;
screw_to_border = 5; // space between M3 hole and border
/* [Hidden] */
distance_between_holes_x = 39;
distance_between_holes_y = 38;

/* [Plate handle] */
mount_length = distance_between_holes_y + (2 * screw_to_border );
half_mount_length = mount_length / 2;

/* [Main Plate] */
plate_handle_length = 15; // distance between wall and border
plate_thickness = 10; // the main thickness of the whole thing
plate_length =  imu_width + 2*plate_handle_length;
plate_width = mount_length+5;

/* [M8 screw params(mount)] */
m8_diameter = 8.5;
m8_hole_off = plate_handle_length/2;
m8_screw_hole_x = plate_length/2 - m8_hole_off;

/* [M3 screw params(imu)] */
m3_screw_top_width = 5;
m3_screw_top_height = 2;
m3_screw_angle = 90;
m3_screw_hole_x = (distance_between_holes_x / 2) ;
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

    // holes for mounting imu
    translate([+m3_screw_hole_x, +m3_screw_hole_y, 0]) screw_hole([m3_screw_top_width, m3_screw_top_height, m3_screw_angle], M3, plate_thickness);
    translate([+m3_screw_hole_x, -m3_screw_hole_y, 0]) screw_hole([m3_screw_top_width, m3_screw_top_height, m3_screw_angle], M3, plate_thickness);
    translate([-m3_screw_hole_x, +m3_screw_hole_y, 0]) screw_hole([m3_screw_top_width, m3_screw_top_height, m3_screw_angle], M3, plate_thickness);
    translate([-m3_screw_hole_x, -m3_screw_hole_y, 0]) screw_hole([m3_screw_top_width, m3_screw_top_height, m3_screw_angle], M3, plate_thickness);
}
