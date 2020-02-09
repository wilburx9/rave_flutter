import 'package:flutter_test/flutter_test.dart';
import 'package:rave_flutter/src/common/rave_utils.dart' as raveUtils;

import 'case.dart';

void main() {
  group("#isEmpty", () {
    final cases = [
      Case(inp: " ", out: true),
      Case(inp: "", out: true),
      Case(inp: null, out: true),
      Case(inp: "一些角色", out: false),
      Case(inp: "九十", out: false),
      Case(inp: "девяносто", out: false),
      Case(inp: "KDHJIWUHE", out: false),
      Case(inp: "-1-2-84ufpo", out: false),
    ];

    cases.forEach((c) {
      test("${c.inp} returns ${c.out}", () {
        final value = raveUtils.isEmpty(c.inp);
        expect(c.out, value);
      });
    });
  });

  group("#cleanUrl", () {
    final cases = [
      Case(inp: "4n2sJwkXwFHEXQZ7", out: "4n2sJwkXwFHEXQZ7"),
      Case(
          inp: "nyMKZ\nusTIfghd\nnmGtMoT5Yw\r1jy xjXWvS4E9ql yQGX7",
          out: "nyMKZusTIfghdnmGtMoT5Yw1jyxjXWvS4E9qlyQGX7"),
      Case(
          inp: "http: / / w w w . g oog \rl e.com\n",
          out: "http://www.google.com"),
      Case(inp: "一\n些角色 r", out: "一些角色r"),
      Case(inp: "\rде вяносто", out: "девяносто"),
    ];

    cases.forEach((c) {
      test("${c.inp} returns ${c.out}", () {
        final value = raveUtils.cleanUrl(c.inp);
        expect(c.out, value);
      });
    });
  });
}
