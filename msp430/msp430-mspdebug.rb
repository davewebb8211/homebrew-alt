require 'formula'

class Msp430Mspdebug < Formula
  url 'http://sourceforge.net/projects/mspdebug/files/mspdebug-0.17.tar.gz'
  homepage 'http://mspdebug.sourceforge.net/index.html'
  md5 '6c112939d37bb1149f61c58c7a886bd6'

  depends_on 'libusb-compat'

  def install

    system "make"
    system "make install"

  end
end