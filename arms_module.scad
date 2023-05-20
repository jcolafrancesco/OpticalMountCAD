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

module build_lateral_arm(lateral_pos, depth_pos, thickness, front_back_margin, left_mrg, right_mrg , height) {
    translate([lateral_pos, depth_pos - (right_mrg+left_mrg)/2+right_mrg, 0])
    cube([thickness+front_back_margin, right_mrg+left_mrg, height], center=true);
}
