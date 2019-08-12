procedure {:entrypoint} main()
  returns ($r: i32)
{
  var $i0: int;
  $i0 := 0;
$bb0:
  $i0 := $i0 + 1;
  goto $bb0;
  assert($i0 != 2);
}