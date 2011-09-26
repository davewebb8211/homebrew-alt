require 'formula'

class Msp430Gdb < Formula
  url 'http://ftpmirror.gnu.org/gdb/gdb-7.2a.tar.bz2'
  homepage 'http://www.gnu.org/software/gdb/index.html'
  md5 'ae6c7c98de35dc14b6720c9c321e4d94'


  def patches
    {
      :p1 => [
               # mspgcc is distributed as a patch against binutils/gcc/gdb
               'http://sourceforge.net/projects/mspgcc/files/Patches/gdb-7.2/msp430-gdb-7.2-20110103.patch'
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

    args = ["--target=msp430",
            "--prefix=#{prefix}",
            "--program-prefix=msp430-",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--disable-nls" ]

    system "./configure", *args
    system "make"
    system "make install"
  end
end