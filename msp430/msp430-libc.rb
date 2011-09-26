require 'formula'

class Msp430Libc < Formula
  url 'http://sourceforge.net/projects/mspgcc/files/msp430-libc/msp430-libc-20110612.tar.bz2'
  homepage 'http://sourceforge.net/apps/mediawiki/mspgcc/index.php?title=MSPGCC_Wiki'
  md5 'f143dfc01911df4e15aa168dee00e40c'

  depends_on relative 'msp430-binutils'
  depends_on relative 'msp430-gcc'

  def patches
    sfp = 'http://sourceforge.net/projects/mspgcc/files/Patches/LTS/20110716/msp430-libc-20110612-sf'
    # SF 3387164 put BV macro back
    # SF 3402836 new printf lacks precision support
    {
      :p1 => [
        sfp+'3387164.patch',
        sfp+'3402836.patch'
      ]
    }
  end


  def install

    system "cd src; make"
    system "cd src; make PREFIX=#{prefix} install"

  end
end