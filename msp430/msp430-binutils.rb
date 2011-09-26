require 'formula'

class Msp430Binutils < Formula
  url 'http://ftpmirror.gnu.org/gnu/binutils/binutils-2.21.1.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  md5 'bde820eac53fa3a8d8696667418557ad'


  def patches
    sfp = 'http://sourceforge.net/projects/mspgcc/files/Patches/LTS/20110716/msp430-binutils-2.21.1-20110716-sf'
    # SF 3143071 error in addend of relocation entry in output
    # SF 3379341: non-empty ARCH environment variable results unusable ld
    # SF 3386145 gc-sections broken in LTS 20110716
    # SF 3400711 consts placed in RAM instead of ROM with -fdata-sections
    # SF 3400750 infomemnobits missing from LTS 20110716
    {
      :p1 => [
        'http://sourceforge.net/projects/mspgcc/files/Patches/binutils-2.21.1/msp430-binutils-2.21.1-20110716.patch',
        sfp+'3143071.patch',
        sfp+'3379341.patch',
        sfp+'3386145.patch',
        sfp+'3400711.patch',
        sfp+'3400750.patch'
      ]
    }
  end


  def install
    # brew's build environment is in our way
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'LD'
    ENV.delete 'CC'
    ENV.delete 'CXX'

    ENV['CPPFLAGS'] = "-I#{include}"

    args = ["--prefix=#{prefix}",
            "--program-prefix=msp430-",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--disable-nls",
            "--target=msp430" ]

    system "./configure", *args
    system "make"
    system "make install"
  end
end