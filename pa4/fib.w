var n = 5;

if (n == 0)
  return 0;
else {
  var x = 0;
  var y = 1;
  var i = 1;
  while (i < n) {
    var z = x + y;
    x = y;
    y = z;
  }
}

print y;
