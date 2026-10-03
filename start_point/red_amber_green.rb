
# cobol-check prints a report for each program it tests, ending in counts:
#
#     1 TEST CASES WERE EXECUTED
#     0 PASSED
#     1 FAILED
#     0 CALLS NOT MOCKED
#
# A kata testing several programs prints one such block per program, so the
# counts are added up across every block. The wording does not change with
# the count, so there is no plural to allow for.
#
# cobol-check itself exits 0 whether tests pass or fail, so its exit status
# says nothing. cyber-dojo.sh exits non-zero instead when anything stopped a
# test from running: a program or a test case that would not compile, a .cut
# file that would not parse, or a test program that stopped before reporting.
# Each of those is an error rather than a failed assertion, so it is amber.

lambda { |stdout,stderr,status|
  return :amber if status != 0
  output = stdout + stderr
  count = lambda { |word| output.scan(/^\s*(\d+) #{word}\s*$/).flatten.map(&:to_i).sum }
  executed = count.call('TEST CASES WERE EXECUTED')
  passed   = count.call('PASSED')
  failed   = count.call('FAILED')
  return :red   if failed > 0
  # Nothing ran, so nothing was proved either way.
  return :amber if executed == 0
  return :green if passed == executed
  return :amber
}
