$(function() {
    $(".hero-heading .rotate").textrotator({
      animation: "spin", // dissolve, fade, flip, flipUp, flipCube, flipCubeUp, spin.
      separator: ",",
      speed: 1000
    });
    $(".logo-wrapper .rotate").textrotator({
      animation: "dissolve", // dissolve, fade, flip, flipUp, flipCube, flipCubeUp, spin.
      separator: ",",
      speed: 2000
    });
  });