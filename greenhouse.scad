include <config.scad>;
include <lumber.scad>;

module wall() {
  translate([
    -wall_width / 2,
    sqrt((wall_width * wall_width) - ((wall_width / 2) * (wall_width / 2))),
    0
  ]) {
    beam(wall_width);
    translate([0, 0, lumber_thick]) {
      let(
        beam_count = vertical_sections,
        noggin_count = horizontal_sections - 1,
        dist_h = (wall_width - lumber_thick) / beam_count,
        effective_height = wall_height - (lumber_thick * 2),
        dist_v = (effective_height - lumber_thick * noggin_count) / horizontal_sections,
        noggin_length = dist_h - lumber_thick
      ) {
        for(section = [0 : 1 : beam_count]) {
          translate([section * dist_h, 0, 0]) {
            stud(effective_height);
          }
        }
        for(h = [0 : 1 : beam_count - 1]) {
          for(v = [0 : 1 : noggin_count - 1]) {
            translate([
              h * dist_h + lumber_thick,
              0,
              dist_v + (v * (dist_v + lumber_thick))
            ]) {
              noggin(noggin_length);
            }
          }
        }
      }
    }
    translate([0, 0, wall_height - lumber_thick]) {
      beam(wall_width);
    }
  }
}

for(s = [0: 1: 5]) {
  rotate([0, 0, 60 * s]) {
    wall();
  }
}
