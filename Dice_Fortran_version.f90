program main

  implicit none

  integer ( kind = 4 ) arg_num
  character ( len = 255 ) commandFilename
  integer ( kind = 4 ) command_unit
  character ( len = 255 ) data_filename
  integer ( kind = 4 ) data_unit
  integer ( kind = 4 ) end1
  integer ( kind = 4 ) end2
  integer ( kind = 4 ) i
  integer ( kind = 4 ) i4_uniform
  integer ( kind = 4 ) iarg
  integer ( kind = 4 ) ierror
  integer ( kind = 4 ) last
  integer ( kind = 4 ) n
  integer ( kind = 4 ) seed
  integer ( kind = 4 ) value
  integer ( kind = 4 ) valueCount(12)
  character ( len = 80 ) string

  call timestamp ( )
  write ( *, '(a)' ) ''
  write ( *, '(a)' ) 'DICE SIMULATION:'
  write ( *, '(a)' ) '  FORTRAN version'
  write ( *, '(a)' ) '  A program that simulates N throws of two identical dice with the same characteristics.'

  arg_num = iargc ( )

  if ( 1 <= arg_num ) then

    iarg = 1
    call getarg ( iarg, string )
    call s_to_i4 ( string, n, ierror, last )
  else

    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) '  How many times should both dice are thrown together: '

    read ( *, * ) n

  end if
  
  call get_seed ( seed )
  
  valueCount(1:12) = 0
  
  do i = 1, n
    end1 = i4_uniform ( 1, 6, seed )
    end2 = i4_uniform ( 1, 6, seed )
    value = end1 + end2
    valueCount(value) = valueCount(value) + 1
  end do
  
  data_filename = 'dice_data.txt'
  call get_unit ( data_unit )
  open ( unit = data_unit, file = data_filename, status = 'replace' )

  do value = 2, 12
    write ( data_unit, '(2x,i2,2x,i6)' ) value, valueCount(value)
  end do

  close ( unit = data_unit )
  write ( *, '(a)' ) ' '
  write ( *, '(a)' ) '  Created the graphics data file "' // trim ( data_filename ) // '".'
  
  commandFilename = 'dice_commands.txt'

  call get_unit ( command_unit )
  open ( unit = command_unit, file = commandFilename, status = 'replace' )

  write ( command_unit, '(a)' ) '# ' // trim ( commandFilename )
  write ( command_unit, '(a)' ) '#'
  write ( command_unit, '(a)' ) '# Usage:'
  write ( command_unit, '(a)' ) '#  gnuplot << ' // trim ( commandFilename )
  write ( command_unit, '(a)' ) '#'
  write ( command_unit, '(a)' ) 'set term png'
  write ( command_unit, '(a)' ) 'set output "dice_output.png"'
  write ( command_unit, '(a)' ) 'set xlabel " Value "'
  write ( command_unit, '(a)' ) 'set ylabel " Frequency "'
  write ( command_unit, '(a)' ) 'set title "value frequency for a pair of fair dice"'
  write ( command_unit, '(a)' ) 'set grid'
  write ( command_unit, '(a)' ) 'set style fill solid'
  write ( command_unit, '(a)' ) 'set yrange [0:*]'
  write ( command_unit, '(a)' ) 'set timestamp'
  write ( command_unit, '(a)' ) 'unset key'
  write ( command_unit, '(a,i4,a)' ) &
    'plot "dice_data.txt" using 1:2:(0.90):xtic(3) with boxes'
  write ( command_unit, '(a)' ) 'quit'

  close ( unit = command_unit )

  write ( *, '(a)' ) '  Created the graphics command file "' // trim ( commandFilename ) // '".'

  write ( *, '(a)' ) ''
  write ( *, '(a)' ) 'DICE_SIMULATION:'
  write ( *, '(a)' ) '  Execution has ended.'
  write ( *, '(a)' ) ''
  call timestamp ( )

  return
end
subroutine get_seed ( seed )

  implicit none

  integer ( kind = 4 ), parameter :: i4_huge = 2147483647
  integer ( kind = 4 ) seed
  real ( kind = 8 ) temp
  character ( len = 10 ) time
  character ( len = 8 ) today
  integer ( kind = 4 ) values(8)
  character ( len = 5 ) zone

  call date_and_time ( today, time, zone, values )

  temp = 0.0D+00

  temp = temp + real ( values(2) - 1, kind = 8 ) /  11.0D+00
  temp = temp + real ( values(3) - 1, kind = 8 ) /  30.0D+00
  temp = temp + real ( values(5),     kind = 8 ) /  23.0D+00
  temp = temp + real ( values(6),     kind = 8 ) /  59.0D+00
  temp = temp + real ( values(7),     kind = 8 ) /  59.0D+00
  temp = temp + real ( values(8),     kind = 8 ) / 999.0D+00
  temp = temp                                    /   6.0D+00

  do while ( temp <= 0.0D+00 )
    temp = temp + 1.0D+00
  end do

  do while ( 1.0D+00 < temp )
    temp = temp - 1.0D+00
  end do

  seed = int ( real ( i4_huge, kind = 8 ) * temp )

  if ( seed == 0 ) then
    seed = 1
  end if

  if ( seed == i4_huge ) then
    seed = seed - 1
  end if

  return
end
subroutine get_unit ( iunit )

  implicit none

  integer ( kind = 4 ) i
  integer ( kind = 4 ) ios
  integer ( kind = 4 ) iunit
  logical lopen
 
  iunit = 0
 
  do i = 1, 99
 
    if ( i /= 5 .and. i /= 6 .and. i /= 9 ) then

      inquire ( unit = i, opened = lopen, iostat = ios )
 
      if ( ios == 0 ) then
        if ( .not. lopen ) then
          iunit = i
          return
        end if
      end if

    end if
 
  end do

  return
end
function i4_uniform ( a, b, seed )


  implicit none

  integer ( kind = 4 ) a
  integer ( kind = 4 ) b
  integer ( kind = 4 ), parameter :: i4_huge = 2147483647
  integer ( kind = 4 ) i4_uniform
  integer ( kind = 4 ) k
  real ( kind = 4 ) r
  integer ( kind = 4 ) seed
  integer ( kind = 4 ) value

  if ( seed == 0 ) then
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) 'I4_UNIFORM - Fatal error!'
    write ( *, '(a)' ) '  Input value of SEED = 0.'
    stop
  end if

  k = seed / 127773

  seed = 16807 * ( seed - k * 127773 ) - k * 2836

  if ( seed < 0 ) then
    seed = seed + i4_huge
  end if

  r = real ( seed, kind = 4 ) * 4.656612875E-10

  r = ( 1.0E+00 - r ) * ( real ( min ( a, b ), kind = 4 ) - 0.5E+00 ) &
    +             r   * ( real ( max ( a, b ), kind = 4 ) + 0.5E+00 )

  value = nint ( r, kind = 4 )

  value = max ( value, min ( a, b ) )
  value = min ( value, max ( a, b ) )

  i4_uniform = value

  return
end
subroutine s_to_i4 ( s, ival, ierror, length )

  implicit none

  character c
  integer ( kind = 4 ) i
  integer ( kind = 4 ) ierror
  integer ( kind = 4 ) isgn
  integer ( kind = 4 ) istate
  integer ( kind = 4 ) ival
  integer ( kind = 4 ) length
  character ( len = * ) s

  ierror = 0
  istate = 0
  isgn = 1
  ival = 0

  do i = 1, len_trim ( s )

    c = s(i:i)

    if ( istate == 0 ) then

      if ( c == ' ' ) then

      else if ( c == '-' ) then
        istate = 1
        isgn = -1
      else if ( c == '+' ) then
        istate = 1
        isgn = + 1
      else if ( lle ( '0', c ) .and. lle ( c, '9' ) ) then
        istate = 2
        ival = ichar ( c ) - ichar ( '0' )
      else
        ierror = 1
        return
      end if

    else if ( istate == 1 ) then

      if ( c == ' ' ) then

      else if ( lle ( '0', c ) .and. lle ( c, '9' ) ) then
        istate = 2
        ival = ichar ( c ) - ichar ( '0' )
      else
        ierror = 1
        return
      end if

    else if ( istate == 2 ) then

      if ( lle ( '0', c ) .and. lle ( c, '9' ) ) then
        ival = 10 * ival + ichar ( c ) - ichar ( '0' )
      else
        ival = isgn * ival
        length = i - 1
        return
      end if

    end if

  end do

  if ( istate == 2 ) then
    ival = isgn * ival
    length = len_trim ( s )
  else
    ierror = 1
    length = 0
  end if

  return
end
subroutine timestamp ( )

  implicit none

  character ( len = 8 ) ampm
  integer ( kind = 4 ) d
  integer ( kind = 4 ) h
  integer ( kind = 4 ) m
  integer ( kind = 4 ) mm
  character ( len = 9 ), parameter, dimension(12) :: month = (/ &
    'January  ', 'February ', 'March    ', 'April    ', &
    'May      ', 'June     ', 'July     ', 'August   ', &
    'September', 'October  ', 'November ', 'December ' /)
  integer ( kind = 4 ) n
  integer ( kind = 4 ) s
  integer ( kind = 4 ) values(8)
  integer ( kind = 4 ) y

  call date_and_time ( values = values )

  y = values(1)
  m = values(2)
  d = values(3)
  h = values(5)
  n = values(6)
  s = values(7)
  mm = values(8)

  if ( h < 12 ) then
    ampm = 'AM'
  else if ( h == 12 ) then
    if ( n == 0 .and. s == 0 ) then
      ampm = 'Noon'
    else
      ampm = 'PM'
    end if
  else
    h = h - 12
    if ( h < 12 ) then
      ampm = 'PM'
    else if ( h == 12 ) then
      if ( n == 0 .and. s == 0 ) then
        ampm = 'Midnight'
      else
        ampm = 'AM'
      end if
    end if
  end if

  write ( *, '(i2,1x,a,1x,i4,2x,i2,a1,i2.2,a1,i2.2,a1,i3.3,1x,a)' ) &
    d, trim ( month(m) ), y, h, ':', n, ':', s, '.', mm, trim ( ampm )

  return
end