// module build_lens_arms(lens_orient = "vertical") {
//     R1 = 10 / (sin(2 * atan((lens_sag) / (lens_width / 2))));
//     inv_focal_length = (n - 1) * (1 / R1);
//     h1 = 0;
//     h2 = (n - 1) * lens_ct / (R1 * n * inv_focal_length);

//     translate([-h2 + lens_ct / 2, 0, reference_height / 2]) {
//         difference() {
//             union() {
//                 arm_thickness = frontback_mrgs * 2 + lens_ct;
//                 translate([0, lens_height / 2 + arm_width / 2 - inr_arm_width, 0])
//                 cube([arm_thickness, arm_width, reference_height], center = true);

//                 translate([0, -lens_height / 2 - arm_width / 2 + inr_arm_width, 0])
//                 cube([arm_thickness, arm_width, reference_height], center = true);
//             };
//             translate([0, 0, reference_height / 2])
//             cyl_lens(R1, lens_orient);
//         };

//         color([1, 0, 0])
//         translate([0, 0, reference_height / 2])
//         cyl_lens(R1, lens_orient);
//     }
// }


module build_lateral_arm(lateral_pos, depth_pos, thickness, front_back_margin, left_mrg, right_mrg , height) {
    translate([lateral_pos, depth_pos - (right_mrg+left_mrg)/2+right_mrg, 0])
    cube([thickness+front_back_margin, right_mrg+left_mrg, height], center=true);
}