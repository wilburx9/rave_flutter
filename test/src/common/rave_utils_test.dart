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

  group("#putIfNotNull", () {
    final map = {};
    final cases = [
      Case(inp: ["key1", "value1"], out: true),
      Case(inp: ["key2", ""], out: false),
      Case(inp: ["key3", "  value3"], out: true),
      Case(inp: ["key4 ", "value4"], out: true),
      Case(inp: ["key5 ", null], out: false),
    ];
    cases.forEach((c) {
      test("${c.inp} returns ${c.out}", () {
        raveUtils.putIfNotNull(map: map, key: c.inp[0], value: c.inp[1]);
        expect(c.out, map.containsKey(c.inp[0]));
      });
    });
  });

  group("#putIfTrue", () {
    final map = {};
    final cases = [
      Case(inp: ["key1", true], out: true),
      Case(inp: ["key2", false], out: false),
      Case(inp: ["key3", null], out: false),
    ];
    cases.forEach((c) {
      test("${c.inp} returns ${c.out}", () {
        raveUtils.putIfTrue(map: map, key: c.inp[0], value: c.inp[1]);
        expect(c.out, map.containsKey(c.inp[0]));
      });
    });
  });
}
