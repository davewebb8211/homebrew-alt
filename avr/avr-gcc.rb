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

class AvrGcc < Formula
  homepage 'http://gcc.gnu.org'
  # url 'http://ftp.gnu.org/gnu/gcc/gcc-4.6.1/gcc-4.6.1.tar.bz2'
  url 'http://ftp.gnu.org/gnu/gcc/gcc-4.6.2/gcc-4.6.2.tar.bz2'
  # md5 'c57a9170c677bf795bdc04ed796ca491'

  depends_on relative 'avr-binutils'
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
    # C++ PROGMEM bug in 49764: 
    # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=49764
    # Fixed in upstream cvs
#    DATA
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

#__END__
#--- gcc-4.6.2/gcc/config/avr/avr.c	2011/07/04 12:21:45	175808
#+++ gcc-4.6.2/gcc/config/avr/avr.c	2011/07/04 12:28:02	175809
#@@ -5052,7 +5052,19 @@
#       && (TREE_STATIC (node) || DECL_EXTERNAL (node))
#       && avr_progmem_p (node, *attributes))
#     {
#-      if (TREE_READONLY (node)) 
#+      tree node0 = node;
#+
#+      /* For C++, we have to peel arrays in order to get correct
#+         determination of readonlyness.  */
#+      
#+      do
#+        node0 = TREE_TYPE (node0);
#+      while (TREE_CODE (node0) == ARRAY_TYPE);
#+
#+      if (error_mark_node == node0)
#+        return;
#+      
#+      if (TYPE_READONLY (node0))
#         {
#           static const char dsec[] = ".progmem.data";
# 
