# vim:ft=gdb:
set history save
set history size 2500
set history filename ~/.gdb_history
set print pretty on
set print asm-demangle on
set print object on
set print frame-arguments all
set print static-members off
set print elements 4096
set disassembly-flavor intel
set prompt [38;5;226m▸▸▸[0;0m 
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
