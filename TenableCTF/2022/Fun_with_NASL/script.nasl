include('compat.inc');



ab = 40+3;
function a()
{
  var a1 = _FCT_ANON_ARGS[0];
  var a2 = _FCT_ANON_ARGS[1];
  var ret = 0;
  for (var i=0; i < a2; i++)
    ret = b(ret, a1);

  return ret;
}

function b()
{
  var b1 = _FCT_ANON_ARGS[0];
  var b2 = _FCT_ANON_ARGS[1];
  var ret = b1;
  for (var i =0; i < b2; i++)
    ret += 1;
  return ret;
}

function c()
{
  var c1 = _FCT_ANON_ARGS[0];
  var c2 = _FCT_ANON_ARGS[1];
  var ret = c1;
  for (var i=0; i < c2; i++)
    ret -= 1;
  return ret;
}

function d()
{
  var d1 = _FCT_ANON_ARGS[0];
  var d2 = _FCT_ANON_ARGS[1];
  var ret = 0;
  while (d1 > 0)
  {
    d1 = c(d1, d2);
    ret++;
  }
  return ret;
}

function e()
{
  return b(a(_FCT_ANON_ARGS[0],_FCT_ANON_ARGS[1]),_FCT_ANON_ARGS[2]);
}

function f()
{
  var o = new aa();
  return o.d(o.d(_FCT_ANON_ARGS[0],_FCT_ANON_ARGS[1]),o.d(_FCT_ANON_ARGS[2],_FCT_ANON_ARGS[3]));
}

function g()
{
  var o = new aa();
  return o.b(a(_FCT_ANON_ARGS[0],_FCT_ANON_ARGS[1]),_FCT_ANON_ARGS[2]);
}
function h()
{
  var o = new aa();
  var ret = 1;
  for (var i=0; i < _FCT_ANON_ARGS[1]; i++)
    ret = o.d(ret, _FCT_ANON_ARGS[0]);
  return ret;
}

function debug(msg)
{
  if (!msg) return NULL;
  display(msg);
}

object aa
{
  public function a()
  {
    return ::b(_FCT_ANON_ARGS[0], _FCT_ANON_ARGS[1]);
  }
  public function b()
  {
    return ::c(_FCT_ANON_ARGS[0], _FCT_ANON_ARGS[1]);
  }
  public function c()
  {
    return ::d(_FCT_ANON_ARGS[0], _FCT_ANON_ARGS[1]);
  }
  public function d()
  {
    return ::a(_FCT_ANON_ARGS[0], _FCT_ANON_ARGS[1]);
  }
}


function int_to_double_ascii(num)
{
  var hex_str = int2hex(num:num, width:4);
  var hex1 = substr(hex_str, 0, 1);
  var hex2 = substr(hex_str, 2, 3);
  var char1 = hex2raw(s:hex1);
  var char2 = hex2raw(s:hex2);
  return char1 + char2;
}





object flag_generator
{
  public function generate_flag()
  {
    var flag = 'flag{' +
      this.part1(_FCT_ANON_ARGS[0][0]) +
      this.part2(_FCT_ANON_ARGS[0][3]) +
      this.part3(_FCT_ANON_ARGS[0][2]) +
      this.part4(_FCT_ANON_ARGS[0][1],_FCT_ANON_ARGS[0][3]) +
      this.part5(_FCT_ANON_ARGS[0][3]) +
      this.part6(_FCT_ANON_ARGS[0][3]) + '}';
    return flag;
  }

  function part1()
  {
    var o = new aa();
    return int_to_double_ascii(num:o.d(o.a(o.b(1001,o.c(5,5)),1),int(_FCT_ANON_ARGS[0])));
  }
  function part2()
  {
    return int_to_double_ascii(num:e(8*_FCT_ANON_ARGS[0],13*41,4));
  }
  function part3()
  {
    return int_to_double_ascii(num:e(8*ab,int(_FCT_ANON_ARGS[0]),1));
  }
  function part4()
  {
    return int_to_double_ascii(num:f(1,_FCT_ANON_ARGS[1],int(_FCT_ANON_ARGS[0]),179));
  }
  function part5()
  {
    return int_to_double_ascii(num:g(h(3,3)*_FCT_ANON_ARGS[0],11*19,4));
  }
  function part6()
  {
    return int_to_double_ascii(num:h(2,2)*h(3,2)*e(6,_FCT_ANON_ARGS[0],h(7,3)));
  }
}

input = get_preference('line_numbers');
line_numbers = split(input, sep:",", keep:false);

fg = new flag_generator();
flag = fg.generate_flag(line_numbers);
display(flag + '\n');


