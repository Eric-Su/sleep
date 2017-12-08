import os, strutils, parseutils

proc showUsageAndExit(rc = QuitFailure) =
  let sPrgName = extractFilename(getAppFilename())
  var    
    msg = ""
  msg.add("Sleep v0.1\n\n" % sPrgName)
  msg.add("Usage: $# n[d|h|m|s]\n" % sPrgName)
  msg.add("       default n milliseconds to pause\n\n")
  msg.add("Example:\n")
  msg.add("       $# 3d\n" % sPrgName)
  msg.add("       $# 4h\n" % sPrgName)
  msg.add("       $# 5m\n" % sPrgName)
  quit(msg, rc)

proc main(): int {.discardable.} =
  var sleeptime: int
  var nLastIndex: cint
  var p: int

  if paramCount() >= 1 :
    p = parseutils.parseInt(paramStr(1), sleeptime, 0)
    if p == 0 or sleeptime == 0 : 
      showUsageAndExit()
    echo "paramStr(1)[p] = ", paramStr(1)[p]
    case paramStr(1)[p]
    of 'd':
      sleeptime = sleeptime * 24 * 60 * 60 * 1000
    of 'h':
      sleeptime = sleeptime * 60 * 60 * 1000
    of 'm':
      sleeptime = sleeptime * 60 * 1000
    of 's':
      sleeptime = sleeptime * 1000
    of '\0':
      echo "got null"
      discard
    else:
      showUsageAndExit()
    echo "sleeptime = ", sleeptime
    sleep(sleeptime)
  else:
    showUsageAndExit(0)
  return 0

main()
