# vim:ft=gdb:
set history save
set history size 2500
set history filename ~/.gdb_history
set history expansion on
set history size 10000
set height 0
set width 0
set verbose off
set confirm off
set demangle-style gnu-v3
set print pretty on
set print asm-demangle on
set print demangle on
set print asm-demangle on
set print array on
set print array-indexes on
set print object on
set print vtbl on
set print frame-arguments all
set print static-members on
set print elements 4096
set disassembly-flavor intel
set prompt > 
set pagination off
set target-async on
set non-stop on

catch syscall ptrace
  commands 1
  set ($eax) = 0
  continue
end

define dis
  disassemble $rip-16,+48
end
document dis
  Disassembles code around the current instruction pointer ($rip)
end
