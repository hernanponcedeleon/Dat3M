procedure {:entrypoint} main()
  returns ($r: i32)
{
  var $i0: i32;
  var $i1: i1;
  var $i2: i32;
  var $i3: i1;
$bb0:
  $i0 := 0;
  goto $bb1;
$bb1:
  $i1 := $i0< 5;
  goto $bb2, $bb3;
$bb2:
  assume ($i1 == 1);
  $i2 := $i0 + 1;
  $i0 := $i2;
  goto $bb1;
$bb3:
  assume !(($i1 == 1));
  $i3 := $i0 != 2;
  goto $bb4, $bb5;
$bb4:
  assume ($i3 == 1);
  $r := 0;
  return;
$bb5:
  assume !(($i3 == 1));
  goto $bb6;
$bb6:
  assert(false);
  assume false;
}