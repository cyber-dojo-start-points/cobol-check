set -e
shopt -s globstar nocaseglob nullglob

cat <<'EOF'
cobol-check test rules:
  The tests for X.CBL are the .cut files in the dir X/
  So if you rename X.CBL, rename the X/ dir to match.

EOF

# --------------------------------------------------------------
# Every program is compiled on its own first, at any depth, whether or not it
# has tests yet. A mistake is then reported against your file and its line
# number. cobol-check compiles each program again later, with your test cases
# merged into it, and a mistake found only there is reported against the
# merged file, with your line quoted beside it.
echo Compile
sources=( **/*.cbl **/*.cob )
if [ ${#sources[@]} -eq 0 ]; then
  echo 'There are no programs: no .CBL or .COB file.' >&2
  exit 1
fi
cobc -fsyntax-only -I . "${sources[@]}"

# --------------------------------------------------------------
# Each directory here holding a .cut file names a program to test.
# Every program is tested in ONE run of cobol-check. It prints a report for
# each program in turn, each ending with its own counts.
programs=()
for dir in */; do
  dir="${dir%/}"
  tests=( "${dir}"/**/*.cut )
  if [ ${#tests[@]} -gt 0 ]; then
    programs+=("${dir}")
    sources=( "${dir}"[.]cbl "${dir}"[.]cob )   # [.] makes each a pattern, matched ignoring case
    if [ ${#sources[@]} -eq 0 ]; then
      echo "${dir}/ holds tests, but there is no program ${dir}.CBL" >&2
      exit 1
    fi
  fi
done
if [ ${#programs[@]} -eq 0 ]; then
  echo 'There are no tests: no directory holds a .cut file.' >&2
  exit 1
fi

JAVA_OPTS=()

COBOL_CHECK_OPTS=()
COBOL_CHECK_OPTS+=(--config-file /opt/cobol-check/config.properties)
COBOL_CHECK_OPTS+=(--log-level off)                                   # its progress log, not your tests
COBOL_CHECK_OPTS+=(--programs "$(IFS=:; echo "${programs[*]}")")      # X:Y:Z

echo
status=0
java "${JAVA_OPTS[@]}" -jar /opt/cobol-check/cobol-check.jar "${COBOL_CHECK_OPTS[@]}" \
  2> /tmp/cobol-check.stderr || status=$?

# cobol-check prints a few lines of its own progress however quiet it is
# asked to be, and when a .cut file has a mistake in it, a page of its own
# java stack frames after the message naming the file, line, and column. Both
# are dropped here; everything else it says is kept.
grep -v \
  -e '^CobolCheck: INFO ' \
  -e $'^\tat ' \
  -e $'^\t\\.\\.\\. [0-9]* more$' \
  /tmp/cobol-check.stderr >&2 || true

# Whatever your programs DISPLAYed UPON SYSERR while the tests ran.
if [ -e /tmp/cobol-check/stderr-of-test-programs ]; then
  cat /tmp/cobol-check/stderr-of-test-programs >&2
fi

# A test program that did not compile, or stopped before reporting, means some
# tests did not run, whatever the reports for other programs say.
if [ -s /tmp/cobol-check/why-a-test-program-did-not-finish ]; then
  cat /tmp/cobol-check/why-a-test-program-did-not-finish >&2
  exit 1
fi
exit ${status}
