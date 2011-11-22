require 'formula'

def relative(name)
  return name if name.kind_of? Formula
  File.join(File.split(__FILE__)[0], name) + '.rb'
end

class AvrXmegaLibc < Formula
  url 'http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.7.1.tar.bz2'
  homepage 'http://www.nongnu.org/avr-libc/'
  md5 '8608061dcff075d44d5c59cb7b6a6f39'

  depends_on relative 'avr-xmega-gcc'

  # brew's build environment is in our way
  ENV.delete 'CFLAGS'
  ENV.delete 'CXXFLAGS'
  ENV.delete 'LD'
  ENV.delete 'CC'
  ENV.delete 'CXX'

  def patches
    # patches from Atmel
    # 
    atmel = 'http://distribute.atmel.no/tools/opensource/avr-gcc/avr-libc-1.7.1/'
    {
      :p0 => [
        atmel+'40-avr-libc-1.7.1-xmega32X1.patch',
        atmel+'41-avr-libc-1.7.1-xmega128b1.patch',
        atmel+'42-avr-libc-1.7.1-bug_11793_fix.patch',
        atmel+'43-avr-libc-1.7.1-bug13804.patch',
        atmel+'50-avr-libc-1.7.1-atxmega256a3bu.patch',
        atmel+'51-avr-libc-1.7.1-at90pwm161.patch',
        atmel+'52-avr-libc-1.7.1-atmega32_5_50_90_pa.patch',
        atmel+'55-avr-libc-1.7.1-attiny1634.patch',
        atmel+'57-avr-libc-1.7.1-atmega48pa.patch'
      ]
    }
  end

  def install
    avr_gcc = Formula.factory(relative 'avr-xmega-gcc')
    build = `./config.guess`.chomp
    system "./configure", "--build=#{build}", "--prefix=#{prefix}", "--host=avr"
    system "make install"
    avr = File.join prefix, 'avr'
    # copy include and lib files where avr-gcc searches for them
    # this wouldn't be necessary with a standard prefix
    ohai "copying #{avr} -> #{avr_gcc.prefix}"
    cp_r avr, avr_gcc.prefix
  end
end
