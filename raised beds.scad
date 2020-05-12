// START INPUTS

beds = [
  [180, 5],
  [150, 4],
  [120, 3],
  [90,  2],
];

top_offset = 1; // min 1.5 to cover panel
// verify metal connection size

// materials
lumber_thick = 2 - 0.5;
lumber_width = 4 - 0.5;

good_lumber_thick = 2 - 0.5;
good_lumber_width = 4 - 0.5;

panel_height = 26 + 1/4; // should be 1/3 not 1/2
panel_thickness = 1 / 2;

short_panel_width = 40; // between 36 and 48 - 96 or 120
bed_external_width = short_panel_width + 2 * (panel_thickness + lumber_thick + top_offset);

// END START INPUTS

//panel_height = 25 + 1/3;
//panel_thickness = 1 / 2;

bed_external_height = panel_height + lumber_thick;

function accumulate(input, i=0, acc_sum=[]) =
    i == len(input) == 0 ?
        acc_sum :
        let( sum_i = (i==0 ? input[0]: acc_sum[i-1] + input[i]) )
        accumulate(input, i=i+1, acc_sum = concat(acc_sum, [ sum_i ]) );

module beam(size) {
  length = max(size);
  echo(str("BEAM (",lumber_thick,"x",lumber_width,"): length ",  length, "in."));
  color("brown") {
    cube(size, false);
  }
}

module panel(length) {

//    |       36        |
//    | 12  |
//    1x    1
//    _                 _   C
//  _/ \___/-\___/-\___/ \  B
//    2y    2               A
  echo(str("PANEL: length ",  length, "in."));
  weight = 0.1;
  color("gray") {
    translate([length, 0, 0]) {
      rotate([0,-90,0]) {
        translate([0, -panel_thickness / 2, 0]) {
          linear_extrude(length) {
            polygon([
              [0,0], [0, panel_thickness],
              [panel_height, 0], [panel_height, panel_thickness],
            ]);
          }
        }
      }
    }
  }
}

module panelCorrugated(length) {
  s = 24 / 9 / 2;
  o = (2 + 2/3) / 4;
  off = 0.01;
  ae = 1 / 2 / 2;
  ai = ae - off;
  be = -ae;
  bi = -ai;

  echo(str("PANEL: length ",  length, "in."));

  color("gray") {
    translate([length, 0, 0]) {
      rotate([0,-90,0]) {
        linear_extrude(length) {
          polygon([
            [s * 0  + 0, off], [s * 0  + o, ae], [s * 1  + o, bi], [s * 2  + o, ae], [s * 3  + o, bi], [s * 4  + o, ae], [s * 5  + o, bi], [s * 6  + o, ae], [s * 7  + o, bi], [s * 8  + o, ae], [s * 9  + o, bi], [s * 10 + o, ae], [s * 11 + o, bi], [s * 12 + o, ae], [s * 13 + o, bi], [s * 14 + o, ae], [s * 15 + o, bi], [s * 16 + o, ae], [s * 17 + o, bi], [s * 18 + o, ae], [s * 19 + 0, off], [s * 19 + 0, -off], [s * 18 + o, ai], [s * 17 + o, be], [s * 16 + o, ai], [s * 15 + o, be], [s * 14 + o, ai], [s * 13 + o, be], [s * 12 + o, ai], [s * 11 + o, be], [s * 10 + o, ai], [s *  9 + o, be], [s *  8 + o, ai], [s *  7 + o, be], [s *  6 + o, ai], [s *  5 + o, be], [s *  4 + o, ai], [s *  3 + o, be], [s *  2 + o, ai], [s *  1 + o, be], [s *  0 + o, ai], [s *  0 + 0, -off]
          ]);
        }
      }
    }
  }
}

for(b = [1:1:len(beds)]) {

  long_panel_width = beds[b-1][0];
  bedexternalw = long_panel_width + 2 * (lumber_thick + top_offset);
  posts = beds[b-1][1];

  echo(str("Size External: ", bedexternalw, "x", bed_external_width, "x", bed_external_height, " (internal ", long_panel_width, "x", short_panel_width, "x", panel_height, ", area ", (long_panel_width*panel_height/12/12) ," sqft., volume ", (bedexternalw * bed_external_width * bed_external_height / 12 / 12 / 12) ," cf)"));
  dist = (long_panel_width + 2 * lumber_thick - lumber_width) / (posts + 1);
  echo(str("Distance between posts: centerline ", dist, " in, spacing ", (dist - lumber_width), " in"));

  scale([-1, 1, 1]) {
    translate([0, (bed_external_height + 40)*(b-1), 0]) {
      // panels parallel
      translate([lumber_thick, lumber_thick + panel_thickness / 2, 0]) {
        panelCorrugated(long_panel_width);
      }
      translate([lumber_thick, lumber_thick + panel_thickness / 2 + panel_thickness + short_panel_width, 0]) {
        panelCorrugated(long_panel_width);
      }

      // panels ortho
      translate([lumber_thick + panel_thickness / 2, lumber_thick + panel_thickness, 0]) {
        rotate([0, 0, 90]) {
          panelCorrugated(short_panel_width);
        }
      }
      translate([lumber_thick - panel_thickness / 2 + long_panel_width, lumber_thick + panel_thickness, 0]) {
        rotate([0, 0, 90]) {
          panelCorrugated(short_panel_width);
        }
      }

      // vertical beams parallel
      dist3 = long_panel_width + 2 * lumber_thick - lumber_width;
      translate([0, 0, 0]) {
        beam([lumber_width, lumber_thick, panel_height]);
      }
      translate([dist3, 0, 0]) {
        beam([lumber_width, lumber_thick, panel_height]);
      }

      translate([0, short_panel_width + 2 * panel_thickness + lumber_thick, 0]) {
        translate([0, 0, 0]) {
          beam([lumber_width, lumber_thick, panel_height]);
        }
        translate([dist3, 0, 0]) {
          beam([lumber_width, lumber_thick, panel_height]);
        }
      }


      // vertical beams orthogonal
      dist2 = long_panel_width + lumber_thick;
      translate([0, lumber_thick, 0]) {
        beam([lumber_thick, lumber_width, panel_height]);
      }
      translate([dist2, lumber_thick, 0]) {
        beam([lumber_thick, lumber_width, panel_height]);
      }

      translate([0, short_panel_width + 2 * panel_thickness - lumber_width + lumber_thick, 0]) {
        translate([0, 0, 0]) {
          beam([lumber_thick, lumber_width, panel_height]);
        }
        translate([dist2, 0, 0]) {
          beam([lumber_thick, lumber_width, panel_height]);
        }
      }

      // horizontal beams parallel
      len1 = long_panel_width + 2 * lumber_thick + 2 * top_offset;
      translate([-top_offset, -top_offset, panel_height]) {
        beam([len1, good_lumber_width, good_lumber_thick]);
      }
      translate([-top_offset, short_panel_width + 2 * lumber_thick + 2 * panel_thickness + top_offset - good_lumber_width, panel_height]) {
        beam([len1, good_lumber_width, good_lumber_thick]);
      }

      // horizontal beams ortho
      len2 = short_panel_width + 2 * lumber_thick + 2 * panel_thickness + 2 * top_offset;
      translate([-top_offset, -top_offset, panel_height]) {
        beam([good_lumber_width, len2, good_lumber_thick]);
      }
      translate([long_panel_width + 2 * lumber_thick + top_offset - good_lumber_width, -top_offset, panel_height]) {
        beam([good_lumber_width, len2, good_lumber_thick]);
      }

      // border beams parallel
      len3 = long_panel_width + 2 * lumber_thick - 2 * lumber_width;
      translate([lumber_width, 0, panel_height - lumber_width]) {
        beam([len3, lumber_thick, lumber_width]);
      }
      translate([lumber_width, short_panel_width + 2 * panel_thickness + lumber_thick, panel_height - lumber_width]) {
        beam([len3, lumber_thick, lumber_width]);
      }

      // border beams ortho
      len4 = short_panel_width + 2 * panel_thickness - 2 * lumber_width ;
      translate([0, lumber_thick + lumber_width, panel_height - lumber_width]) {
        beam([lumber_thick, len4, lumber_width]);
      }
      translate([long_panel_width + lumber_thick, lumber_thick + lumber_width, panel_height - lumber_width]) {
        beam([lumber_thick, len4, lumber_width]);
      }

      // posts
      len5 = panel_height - lumber_width;
      for(i = [1:1:posts]) {
        translate([i * dist, 0, 0]) {
          beam([lumber_width, lumber_thick, len5]);
        }
        translate([i * dist, short_panel_width + 2 * panel_thickness + lumber_thick, 0]) {
          beam([lumber_width, lumber_thick, len5]);
        }
      }
    }
  }
}
// echo(str("TOTAL BEAM ", beam_tot / 12, " ft"));
// echo(str("TOTAL PANEL ", panel_tot / 12, " ft"));

/*

decide how to screw them together
decide rules for posts
decide width
split first in 2?
decide offset

*/
