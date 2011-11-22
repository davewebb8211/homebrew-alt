require 'formula'

class AvrXmegaBinutils < Formula
  url 'http://ftp.gnu.org/gnu/binutils/binutils-2.20.1.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  md5 '2b9dc8f2b7dbd5ec5992c6e29de0b764'
  
  def patches
    # patches from Atmel
    # 
    atmel = 'http://distribute.atmel.no/tools/opensource/avr-gcc/binutils-2.20.1/'
    {
      :p0 => [
        atmel+'30-binutils-2.20.1-avr-size.patch',
        atmel+'31-binutils-2.20.1-avr-coff.patch',
        atmel+'32-binutils-2.20.1-new-sections.patch',
        atmel+'34-binutils-2.20.1-as-dwarf.patch',
        atmel+'35-binutils-2.20.1-dwarf2-AVRStudio-workaround.patch	',
        atmel+'36-binutils-2.20.1-assembler-options.patch',
        atmel+'50-binutils-2.20.1-xmega.patch',
        atmel+'51-binutils-2.20.1-new-devices.patch',
        atmel+'52-binutils-2.20.1-avrtiny10.patch',
        atmel+'53-binutils-2.20.1-xmega128a1u-64a1u.patch',
        atmel+'54-binutils-2.20.1-atxmega16x1-32x1.patch',
        atmel+'55-binutils-2.20.1-atxmega128b1.patch',
        atmel+'56-binutils-2.20.1-atxmega256a3bu.patch',
        atmel+'57-binutils-2.20.1-at90pwm161.patch',
        atmel+'58-binutils-2.20.1-atmega16hvb-32hvb.patch',
        atmel+'59-binutils-2.20.1-atmega32_5_50_90_pa.patch',
        atmel+'60-binutils-2.20.1-bug13789.patch',
        atmel+'62-binutils-2.20.1-attiny1634.patch',
        atmel+'64-binutils-2.20.1-atmega48pa.patch'
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
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--disable-nls",
            "--target=avr" ]

    system "./configure", *args
    system "make"
    system "make install"
  end
end
