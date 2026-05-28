#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================================="
echo "              GLMARK2 MULTI-TARGET BUILD               "
echo "======================================================="

DATA_PATH="$SCRIPT_DIR/data"
DLL_PATH="$SCRIPT_DIR/dlls"

echo -e "\n[1/3] NT6+ x64..."
rm -rf build_nt6_x64

env PATH="/mingw64/bin:/usr/bin:$PATH" \
  meson setup build_nt6_x64 \
  -Dflavors=win32-gl \
  -Ddata-path="$DATA_PATH"

env PATH="/mingw64/bin:/usr/bin:$PATH" \
  meson compile -C build_nt6_x64

mkdir -p build_nt6_x64/data
cp -r "$DATA_PATH"/* build_nt6_x64/data/

cp "$DLL_PATH"/x64/*.dll build_nt6_x64/src/


echo -e "\n[2/3] NT6+ x86..."
rm -rf build_nt6_x86

env PATH="/mingw32/bin:/usr/bin:$PATH" \
  meson setup build_nt6_x86 \
  -Dflavors=win32-gl \
  -Ddata-path="$DATA_PATH"

env PATH="/mingw32/bin:/usr/bin:$PATH" \
  meson compile -C build_nt6_x86

mkdir -p build_nt6_x86/data
cp -r "$DATA_PATH"/* build_nt6_x86/data/

cp "$DLL_PATH"/x86/NT6/*.dll build_nt6_x86/src/


echo -e "\n[3/3] NT5 / XP..."
rm -rf build_nt5_xp

env PATH="/mingw32/bin:/usr/bin:$PATH" \
  meson setup build_nt5_xp \
  -Dflavors=win32-gl \
  -Ddata-path="$DATA_PATH" \
  -Dc_args="-D_WIN32_WINNT=0x0501 -DWINVER=0x0501" \
  -Dcpp_args="-D_WIN32_WINNT=0x0501 -DWINVER=0x0501" \
  -Dc_link_args="-static-libgcc" \
  -Dcpp_link_args="-static-libgcc -static-libstdc++"

env PATH="/mingw32/bin:/usr/bin:$PATH" \
  meson compile -C build_nt5_xp

mkdir -p build_nt5_xp/data
cp -r "$DATA_PATH"/* build_nt5_xp/data/

cp "$DLL_PATH"/x86/NT5/*.dll build_nt5_xp/src/


echo
echo "Done."
echo " - build_nt6_x64/src/glmark2-win32.exe"
echo " - build_nt6_x86/src/glmark2-win32.exe"
echo " - build_nt5_xp/src/glmark2-win32.exe"
