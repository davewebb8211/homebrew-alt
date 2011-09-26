require 'formula'

def relative(name)
  return name if name.kind_of? Formula
  File.join(File.split(__FILE__)[0], name) + '.rb'
end

# print msp430-gcc's builtin include paths
# `msp430-gcc -print-prog-name=cc1plus` -v

class Msp430Gcc < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftpmirror.gnu.org/gcc/gcc-4.5.3/gcc-core-4.5.3.tar.bz2'
  md5 '98be5094b5b5a7b9087494291bc7f522'

  depends_on relative 'msp430-binutils'
  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'

  # Dont strip compilers.
  skip_clean :all

  def patches
    sfp = 'http://sourceforge.net/projects/mspgcc/files/Patches/LTS/20110716/msp430-gcc-4.5.3-20110706-sf'
    # SF 3370978: ICE on shift with 32-bit count
    # SF 3390964 broken optimization with emulated multiply
    # SF 3394176 unrecognizable insn error subtracting addresses
    # SF 3396639 restore lost source listings (and perhaps debugger support)
    # SF 3409864 Args overwritten after call involving int64
    {
      :p1 => [
        # mspgcc is distributed as a patch against gcc
        'http://sourceforge.net/projects/mspgcc/files/Patches/gcc-4.5.3/msp430-gcc-4.5.3-20110706.patch',
        sfp+'3370978.patch',
        sfp+'3390964.patch',
        sfp+'3394176.patch',
        sfp+'3396639.patch',
        sfp+'3409864.patch'
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
            "--target=msp430",
            "--program-prefix=msp430-",
            "--disable-nls",
            # build only C
            "--enable-languages=c",
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
            "--with-as=/usr/local/bin/msp430-as"
           ]

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system '../configure', *args
      system 'make'

      # At this point `make check` could be invoked to run the testsuite. The
      # deja-gnu and autogen formulae must be installed in order to do this.

      system 'make install'
    end
  end
end
