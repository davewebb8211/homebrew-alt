require 'formula'

def nocxx?
  ARGV.include? '--disable-cxx'
end

def relative(name)
  return name if name.kind_of? Formula
  File.join(File.split(__FILE__)[0], name) + '.rb'
end

# print avr-gcc's builtin include paths
# `avr-gcc -print-prog-name=cc1plus` -v

class AvrXmegaGcc < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftp.gnu.org/gnu/gcc/gcc-4.5.1/gcc-4.5.1.tar.bz2'
  md5 '48231a8e33ed6e058a341c53b819de1a'

  depends_on relative 'avr-xmega-binutils'
  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'

  def options
    [
     ['--disable-cxx', 'Don\'t build the g++ compiler'],
    ]
  end

  # Dont strip compilers.
  skip_clean :all

  def patches
    # patches from Atmel
    # 
    atmel = 'http://distribute.atmel.no/tools/opensource/avr-gcc/gcc-4.5.1/'
    {
      :p0 => [
        atmel+'20-gcc-4.5.1-libiberty-Makefile.in.patch',
        atmel+'30-gcc-4.5.1-fixedpoint-3-4-2010.patch',
        atmel+'31-gcc-4.5.1-xmega-v14.patch',
        atmel+'32-gcc-4.5.1-avrtiny10.patch',
        atmel+'33-gcc-4.5.1-osmain.patch',
        atmel+'34-gcc-4.5.1-builtins-v6.patch',
        atmel+'35-gcc-4.5.1-avrtiny10-non-fixedpoint.patch',
        atmel+'37-gcc-4.5.1-option-list-devices.patch',
        atmel+'38-gcc-4.5.1-bug13473.patch',
        atmel+'39-gcc-4.5.1-bug13579.patch',
        atmel+'40-gcc-4.5.1-bug-18145-v4.patch',
        atmel+'41-gcc-4.5.1-avrtiny10-bug-12510.patch',
        atmel+'42-gcc-4.5.1-bug12915.patch',
        atmel+'43-gcc-4.5.1-bug13932.patch',
        atmel+'44-gcc-4.5.1-bug13789.patch',
        atmel+'50-gcc-4.5.1-new-devices.patch',
        atmel+'51-gcc-4.5.1-atmega32_5_50_90_pa.patch',
        atmel+'54-gcc-4.5.1-attiny1634.patch',
        atmel+'56-gcc-4.5.1-atmega48pa.patch'
      ]
    }
  end

  def install
    gmp = Formula.factory 'gmp'
    mpfr = Formula.factory 'mpfr'
    libmpc = Formula.factory 'libmpc'

    # brew's build environment is in our way
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'AS'
    ENV.delete 'LD'
    ENV.delete 'NM'
    ENV.delete 'RANLIB'

    if MacOS.lion?
      ENV['CC'] = 'clang'
    end

    args = [
            "--target=avr",
            "--disable-libssp",
            "--disable-libada",
            "--disable-shared",
            "--disable-nls",
            "--with-dwarf2",
            # Sandbox everything...
            "--prefix=#{prefix}",
            "--with-gmp=#{gmp.prefix}",
            "--with-mpfr=#{mpfr.prefix}",
            "--with-mpc=#{libmpc.prefix}",
            # ...except the stuff in share...
            "--datarootdir=#{share}",
            # ...and the binaries...
            "--bindir=#{bin}",
            # This shouldn't be necessary
            "--with-as=/usr/local/bin/avr-as"
           ]

    # The C compiler is always built, C++ can be disabled
    languages = %w[c]
    languages << 'c++' unless nocxx?

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system '../configure', "--enable-languages=#{languages.join(',')}", *args
      system 'make'

      # At this point `make check` could be invoked to run the testsuite. The
      # deja-gnu and autogen formulae must be installed in order to do this.

      system 'make install'
    end
  end
end
