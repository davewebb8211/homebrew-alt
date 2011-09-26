require 'formula'

class Msp430mcu < Formula
  url 'http://sourceforge.net/projects/mspgcc/files/msp430mcu/msp430mcu-20110613.tar.bz2'
  homepage 'http://sourceforge.net/apps/mediawiki/mspgcc/index.php?title=MSPGCC_Wiki'
  md5 '0579e1a7de78f92a1d833cd9d9ea4f43'


  def patches
    sfp = 'http://sourceforge.net/projects/mspgcc/files/Patches/LTS/20110716/msp430mcu-20110613-sf'
    # SF 3379189: Wrong permission on installed files
    # SF 3384550 Missing __ASSEMBLER__ guard in msp430.h
    # SF 3400714 __delay_cycles missing from in430.h
    {
      :p1 => [
        sfp+'3379189.patch',
        sfp+'3384550.patch',
        sfp+'3400714.patch'
      ]
    }
  end


  def install

    system "MSP430MCU_ROOT=`pwd` ./scripts/install.sh #{prefix}"

  end
end