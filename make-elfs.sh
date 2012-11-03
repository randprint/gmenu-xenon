rm -f ./*.elf32
rm -f /srv/tftp/gmenu*.elf32
xenon-objcopy -O elf32-powerpc --adjust-vma 0x80000000 ./objs/gmenu2x ./gmenu2x.elf32
xenon-objcopy -O elf32-powerpc --adjust-vma 0x80000000 ./objs/gmenu2x-debug ./gmenu2x-debug.elf32
xenon-strip ./gmenu2x.elf32
cp *.elf32 /srv/tftp
