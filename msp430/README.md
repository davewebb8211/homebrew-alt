# Overview

This is a try to get a MSP430 toolchain compile for OSX. 

Inspirations from Fink (http://fink.cvs.sourceforge.net/fink/dists/10.4/unstable/main/finkinfo/10.4-EOL/devel/msp430-binutils.info?view=markup) and Wiki of mspgcc (http://sourceforge.net/apps/mediawiki/mspgcc/index.php?title=Install:fromsource)



# Contents

Brews in this repository are broken out as described below.

  * msp430-binutils:
    The GNU binutils, compiled for MSP

  * msp430-gcc:
    The GNU C compiler.

  * msp430-gdb:
    These brew provides GNU debugger. 

  * msp430-libc:
    Formula for compiling the C library for MSP using msp430-gcc. 

  * msp430mcu:
    Headers and support files from Texas Instruments. 

  * msp430-mspdebug:
    Tool to read and write flash and to debug. 

# ToDo
  
  * Compile a sample project
  
  * Include ez430 dummy driver


# Using

There are two ways to install packages from this repository.

## Using Raw URLs

First you need to get your hands on the raw URL. For example, the raw url for
the princexml formula is:

`https://github.com/davewebb8211/homebrew-alt/raw/master/msp430-binutils`


Pass that URL as a parameter to the `brew install` command, like so:

`brew install https://github.com/davewebb8211/homebrew-alt/raw/master/msp430/msp430-binutils.rb`

## Cloning the Repository

Clone the repository to somewhere that you'll remember:

`git clone https://github.com/davewebb8211/homebrew-alt.git /usr/local/MyLibrary`

This example creates a `MyLibrary` directory under `/usr/local`.

Then to install a formula pass the full path to the formula into the
`brew install` command. Here's another example that installs msp430-binutils:

`brew install /usr/local/MyLibrary/msp430/msp430-binutils.rb`
