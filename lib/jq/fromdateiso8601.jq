def fromdateiso8601:
  capture
      ( "^(?<year>[0-9]{4})"
      + "-(?<month>[0-9]{2})"
      + "-(?<day>[0-9]{2})"
      + "T(?<hour>[0-9]{2})"
      + ":(?<minute>[0-9]{2})"
      + ":(?<second>[0-9]{2})"
      + "(?<subseconds>\\.[0-9]+)?"   # Support optional subsecond precision
      + "(Z|"                         # Support Zulu or offset
      + "(?<offset_sign>[-+])"
      + "(?<offset_hours>[0-9]{2})"
      + ":?"
      + "(?<offset_minutes>[0-9]{2})"
      + ")$")

      # Subseconds are optional, and so is the offset if Zulu time is specified
      | .subseconds //= 0
      | .offset_hours //= 0
      | .offset_minutes //= 0
      | .offset_sign //= "+"  # string math ftw

      | .offset_sign += "1"  # string math ftw

      | (.year, .month, .day, .hour, .minute, .second,
         .subseconds, .offset_sign, .offset_hours, .offset_minutes) |= tonumber
      | .offset = (.offset_hours * 3600 + .offset_minutes * 60)
                 * .offset_sign * -1  # the Earth rotates eastward

      | ([.year, .month - 1, .day, .hour, .minute, .second, 0, 0] | mktime)
          + .offset + .subseconds
;
