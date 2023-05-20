// Copyright (C) 2023 Julien Colafrancesco
// This program is free software: you can redistribute it and/or modify it under the terms of the 
// GNU General Public License as published by the Free Software Foundation, version 3.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
// See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with this program. 
// If not, see <https://www.gnu.org/licenses/>.

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