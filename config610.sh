../configure CC="csky-linux-gcc -mcpu=ck610 -mlittle-endian"  CXX="csky-linux-g++ -mcpu=ck610 -mlittle-endian"  AS="csky-linux-as -mcpu=ck610 -mlittle-endian"  LD="csky-linux-ld -mcpu=ck610 -EL"   --host=csky-linux --target=csky-linux --build=x86_64 --prefix=/home/chenlf/sourcecode/glibc-2.25/install/ CFLAGS="-mcpu=ck610 -O2 -Wl,--eh-frame-hdr  -msoft-float -fPIC"  CPPFLAGS="-mcpu=ck610 -O2 -Wl,--eh-frame-hdr   -msoft-float -fPIC"  LDFLAGS="-L</lib>  -Wl,-s"  --enable-kernel=4.9 --disable-check-abi --disable-profile --enable-bounded --enable-stackguard-randomization --disable-all-warnings --enable-shared --with-fp libc_cv_ctors_header=yes libc_cv_c_cleanup=yes libc_cv_pic_default=yes libc_cv_forced_unwind=yes libc_cv_gcc_static_libgcc= --with-headers=/home/chenlf/sourcecode/new-linux-glibc/source/glibc/../linux-headers/include/ --disable-build-nscd --disable-nscd --enable-obsolete-rpc --enable-static-nss libc_cv_ld_gnu_indirect_function=yes #--libc_cv_slibdir=/lib --libc_cv_libdir=/usr/lib/