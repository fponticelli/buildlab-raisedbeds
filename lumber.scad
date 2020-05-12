lumber_nominal_thick = 2;
lumber_width_thick = 4;

lumber_thick = lumber_nominal_thick - 0.5;
lumber_width = lumber_width_thick - 0.5;

module beam(length) {
  echo(str("BEAM: beam (",lumber_thick,"x",lumber_width,"): length ",  length, "in."));
  color("brown") {
    cube([length, lumber_width, lumber_thick], false);
  }
}

module stud(length) {
  echo(str("BEAM: stud (",lumber_thick,"x",lumber_width,"): length ",  length, "in."));
  color("brown") {
    cube([lumber_thick, lumber_width, length], false);
  }
}

module noggin(length) {
  echo(str("BEAM: noggin (",lumber_thick,"x",lumber_width,"): length ",  length, "in."));
  color("brown") {
    cube([length, lumber_width, lumber_thick], false);
  }
}
