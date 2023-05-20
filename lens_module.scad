// OpticalMountCAD
// Copyright (C) 2023 Julien Colafrancesco
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

module build_onesided_lens(r1, r2, sag1, sag2, width, ct, gt) {
    module lens_rect_superset(r1, r2, sag1, sag2, width, ct, gt) {
        translate([-(ct/2) - (r2 > 0 ? sag2 : 0), -width/2, 0])
        square([gt, width]);
    }
    module lens_circle(r1, r2, sag1, sag2, width, ct) {
        translate([-r1+ct/2, 0, 0])
        circle(d=abs(r1)*2);
    }

    if (r1 > 0) {
        intersection() {
            lens_rect_superset(r1, r2, sag1, sag2, width, ct, gt);
            lens_circle(r1, r2, sag1, sag2, width, ct);
        }
    }
    else {
        difference() {
            lens_rect_superset(r1, r2, sag1, sag2, width, ct, gt);
            lens_circle(r1, r2, sag1, sag2, width, ct);
        }
    }
}

module draw_lens_projection(r1, r2, sag1, sag2, width, ct, gt, r1_inf, r2_inf) {
    intersection() {
        if (!r1_inf)
            build_onesided_lens(r1, r2, sag1, sag2, width, ct, gt);
        if (!r2_inf) {
            rotate([0, 0, 180])
            build_onesided_lens(-r2, -r1, sag2, sag1, width, ct, gt);
        }
    }
}

module draw_lens(r1, r2, sag1, sag2, width, ct, gt, r1_inf, r2_inf, is_cyl, cyl_orient, cyl_height) {
    if (!is_cyl) {
        rotate([0, 90, 0])
        rotate_extrude(angle=360)
        rotate([0, 0, 90])
        intersection() {
            translate([-gt, -width/2])
            square([2*gt, width/2]);
            draw_lens_projection(r1, r2, sag1, sag2, width, ct, gt, r1_inf, r2_inf);
        }    
    }
    else {
        rotate([cyl_orient == "h" ? 90: 0, 0, 0])
        linear_extrude(height=cyl_height, center=true)
        draw_lens_projection(r1, r2, sag1, sag2, width, ct, gt, r1_inf, r2_inf);
    }
}
