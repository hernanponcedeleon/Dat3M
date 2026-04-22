#!/usr/bin/env bash

verbose=true

build-ck() {
  install-ck
  for arch in armv7 armv8 ppc64 riscv64
  do build-ck-for-arch "$arch" || return 1
  done
}

install-ck() {
  export dir_ck=../ck
  url_ck=https://github.com/concurrencykit/ck.git
  tag_ck=0.7.2
  if [ ! -d "$dir_ck" -a ! "$(git -C "$dir_ck" remote get-url origin)" = "$url_ck" ]
  then echo "Install dependency $url_ck into $dir_ck"
    git clone "$url_ck" "$dir_ck"
    git -C "$dir_ck" checkout "$tag_ck"
  fi
  if [ "$verbose" = true ]
  then echo "Concurrency kit $( \
      git -C "$dir_ck" describe --tags --exact-match HEAD 2>/dev/null \
      || git -C "$dir_ck" rev-parse --short HEAD)"
  fi
}

build-ck-for-arch() {
  arch="$1"
	archdir=$arch
	case "$arch" in
		armv7)
		ckoption="-mfloat-abi=soft -D__arm__ -D__ARM_ARCH_7__"
		names="clhlock faslock spsc_queue ticketlock"
		;;
		armv8)
		ckoption="-mfloat-abi=soft -D__aarch__"
		names="anderson caslock clhlock declock ebr faslock mcslock spsc_queue stack_empty ticketlock"
		;;
		ppc64)
		ckoption="-mfloat-abi=soft -D__ppc64__"
		names="anderson caslock clhlock declock faslock mcslock spsc_queue stack_empty ticketlock"
		;;
		riscv64)
		ckoption="-D__riscv -D__riscv_xlen=64"
		names="spsc_queue"
		archdir="riscv"
		;;
		*)
		echo "Unknown arch '$arch'." && exit 3
	esac
  targetdir="dartagnan/src/test/resources/asm/$archdir/ck"
  sourcedir="benchmarks/ck"
	cflags="-Iinclude/libc -I$dir_ck/include -iquote$dir_ck/src -target $arch-pc-linux-gnu $ckoption"
	for name in $names
	do ll-from-c "$targetdir/$name.ll" "$sourcedir/$name.c" "$cflags" || return 1
	done
}

ll-from-c() {
  ll="$1"
  c="$2"
  hash="$(shasum -a 512 "$ll")"
  if clang $CFLAGS $3 -Iinclude -S -emit-llvm -g -gcolumn-info -o "$ll" "$c"
  then
    [ "$verbose" = true -a "$hash" != "$(shasum -a 512 "$ll")" ] && echo "Updated $ll."
    return 0
  fi
  return 1
}

require-program() {
  which "$1" 2>/dev/null || exit
}

cd "$(dirname "$0")"
cd ..
build-ck
