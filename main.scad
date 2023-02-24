include <base_module.scad>
include <lens_module.scad>
include <arms_module.scad>

/* [General Parameters] */
// Optical object type
optic_type = "Plate"; // [Spherical Lens, Cylindrical Lens, Plate]
// Set to true to display the optics with the holder
display_optics = false;
// Element with greatest height
bigst_elt_height = 40;

/* [Lens Parameters] */
// First radius
r1 = 25;
// Is first radius infinity?
r1_inf = false;
// Second radius
r2 = 30; //0.01
// Is second radius infinity?
r2_inf = true;
// Center thickness
ct = 4.01;
// Width (or diameter for spherical lenses)
width = 20; //0.01
// Refractive Index
n = 1.5;
// Function to compute lens sagitta
function sagitta(r, w) = let(ar = abs(r)) ar - sqrt(ar*ar - pow(w/2,2));
// Sagitta 1
sag1 = r1_inf ? 0 : sagitta(r1, width);
// Sagitta 2
sag2 = r2_inf ? 0 : sagitta(r2, width);
// Edge Thickness
et = ct - sign(r1) * sag1 + sign(r2) * sag2;
// Global Thickness
gt = ct + (r1 < 0 ? sag1 : 0) + (r2 > 0 ? sag2 : 0);
// Center position
cp = 0;
// Edges position
ep = ct/2 - sign(r2) * sag1 - et/2;
// Inverse of R1
inv_r1 = r1_inf ? 0 : 1/r1;
// Inverse of R2
inv_r2 = r2_inf ? 0 : 1/r2;
// Inverse Focal distance
inv_f = (n - 1) * (inv_r1 - inv_r2 + (n-1) * ct / n * inv_r1 * inv_r2);
// First principal plane distance
h1 = (n-1) * ct * inv_r2 / n / inv_f;
// Second principal plane distance
h2 = (n-1) * ct * inv_r1 / n / inv_f;
/* [Cylinder lens parameters] */
// Cylinder height
cyl_height = 22; //0.01
// Cylinder orientation
cyl_orient = "v"; // ["h", "v"]

/* [Plate parameters] */
// Plate thickness
plate_thickness = 1; // 0.01
// Plate thickness
plate_height = 20; // 0.01

/* [Arms parameters] */
// Set to true to build central arm
central_arm_presence = false;
// Set to true to build lateral arms
lateral_arms_presence = true;
// Portion of the arm overlaping with the lens
inr_margin = 1;
// Portion of the arm that doesn't overlap with the lens
outr_margin = 4;
// Portion of the arm extending at the front and back of the lens
fb_margin = 2;

/* [Base Parameters] */
// Thread diameter
thread_diameter = 6; //[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
// Inter-axes spacing
axes_spacing = 25; // [25, 25.4]
// Base height
base_height = 5; // [1:10]
// Radius of the srews' heads, fixed to two times the thread
head_radius = thread_diameter;
// Base thickness, fixed to two times the thread.
base_thickness = 2 * head_radius;

/* [Advanced Parameters] */
// The epsilon value used to remove overlap ambiguities
eps = 0.01;
$fa = 1;
$fs = 0.4;

module draw_optics() {
    if (optic_type == "Plate")
        cube([plate_thickness, width, plate_height], center=true);
    else
        draw_lens(r1, r2, sag1, sag2, width, ct, gt, r1_inf, r2_inf, optic_type == "Cylindrical Lens", cyl_orient, cyl_height);
}

// Height at which all optics should center
reference_height = bigst_elt_height / 2 + base_height;
optic_height = optic_type == "Plate" ? plate_height : ((optic_type == "Cylindrical Lens") && cyl_orient == "h" ? cyl_height : width);
optic_center = optic_type == "Plate" ? 0 : ((optic_type == "Cylindrical Lens") && cyl_orient == "h" ? cp : ep);
optic_thickness = optic_type == "Plate" ? plate_thickness : ((optic_type == "Cylindrical Lens") && cyl_orient == "h" ? ct : et);

base(base_height, base_thickness, thread_diameter, head_radius, eps);

union() {
    if (lateral_arms_presence) {
        difference() {
            translate([0, 0, reference_height / 2]) {
                build_lateral_arm(optic_center, -optic_height/2, optic_thickness, fb_margin, outr_margin, inr_margin, reference_height);
                build_lateral_arm(optic_center, +optic_height/2, optic_thickness, fb_margin, inr_margin, outr_margin, reference_height);
            }

            translate([0, 0, reference_height])
            draw_optics();
        }
    }

    if (central_arm_presence) {
        difference() {
            if (optic_type == "Spherical Lens") {
                difference() {
                    translate([ep, 0, reference_height / 2])
                    cube([optic_thickness + fb_margin, width + outr_margin, reference_height], center=true);
                    
                    translate([ep, 0, reference_height])
                    rotate([0, 90, 0])
                    cylinder(h=100, r=width/2-inr_margin, center=true);
                }
            }
            else {
                translate([optic_center, 0, (reference_height - optic_height/2 + inr_margin)/2])
                cube([optic_thickness + fb_margin, width + outr_margin, reference_height - optic_height/2 + inr_margin], center=true);
            }

            translate([0, 0, reference_height])
            draw_optics();
        }
    }

    if (display_optics) {
        color([1, 0, 0])
        translate([0, 0, reference_height])
        draw_optics();
    }
}
