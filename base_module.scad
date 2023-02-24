
module base(base_height, base_depth, thread_diameter, head_radius, eps) {


    difference() {
        union() {
            translate([-base_depth / 2, -axes_spacing, 0])
            cube([base_depth, 2 * axes_spacing, base_height]);

            translate([0, -axes_spacing, 0])
            cylinder(h = base_height, r = head_radius);

            translate([0, axes_spacing, 0])
            cylinder(h = base_height, r = head_radius);
        }

        translate([0, -axes_spacing, -eps])
        cylinder(h = base_height + 2 * eps, r = thread_diameter / 2);

        translate([0, axes_spacing, -eps])
        cylinder(h = base_height + 2 * eps, r = thread_diameter / 2);
    }
}