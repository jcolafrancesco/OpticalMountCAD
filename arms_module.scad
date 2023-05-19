module build_lateral_arm(lateral_pos, depth_pos, thickness, front_back_margin, left_mrg, right_mrg , height) {
    translate([lateral_pos, depth_pos - (right_mrg+left_mrg)/2+right_mrg, 0])
    cube([thickness+front_back_margin, right_mrg+left_mrg, height], center=true);
}
