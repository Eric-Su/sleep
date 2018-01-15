import os, strutils, parseutils, parseopt

const
  Version = "0.2"

proc showUsageAndExit(rc = QuitFailure) =
  let sPrgName = extractFilename(getAppFilename())
  var    
    msg = ""
  msg.add("Sleep v$#\n" % Version)
  msg.add("Usage: $# [-options] n[d | h | m | s]\n" % sPrgName)
  msg.add("       default n milliseconds to pause\n")
  msg.add("where options include:\n")
  msg.add("       -h | --help     print this help message\n")
  msg.add("       -v | --verbose  enable verbose output\n")
  msg.add("Example:\n")
  msg.add("       $# 900\n" % sPrgName)
  msg.add("       $# 1h-0.99h\n" % sPrgName)
  msg.add("       $# 3s0.2m .1h\n" % sPrgName)
  quit(msg, rc)

proc parseCmdLine(): int =
  if paramCount() <= 0 :
    showUsageAndExit()

  var
    verbose = false
    parm = initOptParser()

  while true:
    next(parm)
    var 
      kind = parm.kind
      key = parm.key.string

    case kind
      of cmdArgument:
        var
          number: float
          pos = 0
        while pos < len(key):
          let numLen = parseutils.parseFloat(key, number, pos)
          if numLen == 0:
            showUsageAndExit()
          pos += numLen
          case key[pos]
            of 'd':
              result += int(number * 24 * 60 * 60 * 1000)
            of 'h':
              result += int(number * 60 * 60 * 1000)
            of 'm':
              result += int(number * 60 * 1000)
            of 's':
              result += int(number * 1000)
            of '\0':
              result += int(number)
            else:
              showUsageAndExit()
          pos += 1

      of cmdLongoption, cmdShortOption:
        case normalize(key)
        of "h", "help":
          showUsageAndExit(0)
        of "v", "verbose":
          verbose = true
        else:
          showUsageAndExit()
      of cmdEnd: break

  if verbose:
    var
      res: int
      num: int
      remainder: int = result
      msg = ""

    if result < 0:
      msg = "Sleep 0ms "
      msg.add(" ($# ms)" % $result)
      echo msg
      return

    num = 24 * 60 * 60 * 1000
    res = remainder div num
    remainder = remainder mod num
    if res > 0:
      msg.add($res & "d")

    num = 60 * 60 * 1000
    res = remainder div num
    remainder = remainder mod num
    if res > 0:
      msg.add($res & "h")

    num = 60 * 1000
    res = remainder div num
    remainder = remainder mod num
    if res > 0:
      msg.add($res & "m")

    num = 1000
    res = remainder div num
    remainder = remainder mod num
    if res > 0:
      msg.add($res & "s")

    if msg == "" or remainder > 0:
      msg.add($remainder & "ms")

    if result > 1000:
      msg.add(" ($# ms)" % $result)
    echo "Sleep ", msg

proc main() =
  let sleeptime = parseCmdLine()
  if sleeptime > 0:
    sleep(sleeptime)

main()
