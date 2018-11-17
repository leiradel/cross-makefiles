local template = [[
##############
# Works on hosts ${HOST}
# ${HEADERMSG}

#########################
# Check the host platform

HOST_PLATFORM = linux
ifeq ($(shell uname -a),)
  HOST_PLATFORM = windows
else ifneq ($(findstring MINGW,$(shell uname -a)),)
  HOST_PLATFORM = windows
else ifneq ($(findstring Darwin,$(shell uname -a)),)
  HOST_PLATFORM = darwin
else ifneq ($(findstring win,$(shell uname -a)),)
  HOST_PLATFORM = windows
endif

#########################
# Set the target platform

TARGET_PLATFORM = ${TARGET_PLATFORM}

#################
# Toolchain setup

CC  = ${CC}
CXX = ${CXX}
AS  = ${AS}
AR  = ${AR}

############
# Extensions

OBJEXT = .${EXT}.o
SOEXT  = .${EXT}.${SO}
LIBEXT = .${EXT}.a

################
# Platform setup

STATIC_LINKING = ${STATIC_LINKING}
platform       = ${PLATFORM}
PLATDEFS       = ${PLAT_DEFS}
PLATCFLAGS     = ${PLAT_CFLAGS}
PLATCXXFLAGS   = ${PLAT_CXXFLAGS}
PLATLDFLAGS    = ${PLAT_LDFLAGS}
PLATLDXFLAGS   = ${PLAT_LDXFLAGS}

################
# libretro setup

RETRODEFS     = -D__LIBRETRO__
RETROCFLAGS   =
RETROCXXFLAGS =
RETROLDFLAGS  =
RETROLDXFLAGS =

#################
# Final variables

DEFINES  = $(PLATDEFS) $(RETRODEFS)
CFLAGS   = $(PLATCFLAGS) $(RETROCFLAGS) $(DEFINES) $(INCLUDES)
CXXFLAGS = $(PLATCXXFLAGS) $(RETROCXXFLAGS) $(DEFINES) $(INCLUDES)
LDFLAGS  = $(PLATLDFLAGS) $(RETROLDFLAGS)
LDXFLAGS = $(PLATLDXFLAGS) $(RETROLDXFLAGS)

########
# Tuning

ifneq ($(DEBUG),)
  CFLAGS   += -O0 -g
  CXXFLAGS += -O0 -g
else
  CFLAGS   += -O3 -DNDEBUG
  CXXFLAGS += -O3 -DNDEBUG
endif

ifneq ($(LOG_PERFORMANCE),)
  CFLAGS   += -DLOG_PERFORMANCE
  CXXFLAGS += -DLOG_PERFORMANCE
endif

####################################
# Variable setup for Makefile.common

CORE_DIR  ?= ..
BUILD_DIR ?= .
INCLUDES   = ${PLAT_INCDIR}

include $(BUILD_DIR)/Makefile.common

###############
# Include rules

include $(BUILD_DIR)/Makefile.rules
]]

--local host = 'linux-x86_64'
--local host = 'darwin-x86_64'
--local host = 'windows-x86_64'
local host = '$(HOST_PLATFORM)-x86_64'

local platforms = {
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_arm64_v8a = {
    MAKEFILE      = 'Makefile.android_arm64-v8a',
    HOST          = 'Linux, Windows and Darwin',
    HEADERMSG     = 'Download the Android NDK, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/aarch64-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/aarch64-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/aarch64-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/aarch64-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/aarch64-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/aarch64-linux-android-as',
    AR            = '$(NDK_ROOT_DIR)/toolchains/aarch64-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/aarch64-linux-android-ar',
    EXT           = 'android_arm64-v8a',
    SO            = 'so',
    PLATFORM      = 'android',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-21/arch-arm64/usr/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/arm64-v8a/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include/backward',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST',
    PLAT_CFLAGS   = '-fpic -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS} -fno-exceptions -fno-rtti',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-21/arch-arm64 -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS} $(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/arm64-v8a/libgnustl_static.a',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_x86_64 = {
    MAKEFILE      = 'Makefile.android_x86_64',
    HOST          = 'Linux, Windows and Darwin',
    HEADERMSG     = 'Download the Android NDK, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/x86_64-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/x86_64-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/x86_64-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/x86_64-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/x86_64-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/x86_64-linux-android-as',
    AR            = '$(NDK_ROOT_DIR)/toolchains/x86_64-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/x86_64-linux-android-ar',
    EXT           = 'android_x86_64',
    SO            = 'so',
    PLATFORM      = 'android',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-21/arch-x86_64/usr/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/x86_64/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include/backward',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST',
    PLAT_CFLAGS   = '-ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS} -fno-exceptions -fno-rtti',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-21/arch-x86_64 -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS} $(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/x86_64/libgnustl_static.a',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_mips64 = {
    MAKEFILE      = 'Makefile.android_mips64',
    HOST          = 'Linux, Windows and Darwin',
    HEADERMSG     = 'Download the Android NDK, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/mips64el-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/mips64el-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/mips64el-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/mips64el-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/mips64el-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/mips64el-linux-android-as',
    AR            = '$(NDK_ROOT_DIR)/toolchains/mips64el-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/mips64el-linux-android-ar',
    EXT           = 'android_mips64',
    SO            = 'so',
    PLATFORM      = 'android',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-21/arch-mips64/usr/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/mips64/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include/backward',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST',
    PLAT_CFLAGS   = '-fpic -fno-strict-aliasing -finline-functions -ffunction-sections -funwind-tables -fmessage-length=0 -fno-inline-functions-called-once -fgcse-after-reload -frerun-cse-after-loop -frename-registers -no-canonical-prefixes -fomit-frame-pointer -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS} -fno-exceptions -fno-rtti',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-21/arch-mips64 -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm',
    PLAT_LDXFLAGS  = '${PLAT_LDFLAGS} $(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/mips64/libgnustl_static.a',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_arm_v7a = {
    MAKEFILE      = 'Makefile.android_armeabi-v7a',
    HOST          = 'Linux, Windows and Darwin',
    HEADERMSG     = 'Download the Android NDK, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/arm-linux-androideabi-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/arm-linux-androideabi-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/arm-linux-androideabi-as',
    AR            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/arm-linux-androideabi-ar',
    EXT           = 'android_armeabi-v7a',
    SO            = 'so',
    PLATFORM      = 'android',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-19/arch-arm/usr/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/armeabi/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include/backward',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST',
    PLAT_CFLAGS   = '-fpic -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS} -fno-exceptions -fno-rtti',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-19/arch-arm -lgcc -no-canonical-prefixes -march=armv7-a -Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS} $(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/armeabi-v7a/libgnustl_static.a',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_arm_v5te = {
    MAKEFILE      = 'Makefile.android_armeabi',
    HOST          = 'Linux, Windows and Darwin',
    HEADERMSG     = 'Download the Android NDK, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/arm-linux-androideabi-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/arm-linux-androideabi-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/arm-linux-androideabi-as',
    AR            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/arm-linux-androideabi-ar',
    EXT           = 'android_armeabi',
    SO            = 'so',
    PLATFORM      = 'android',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-9/arch-arm/usr/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/armeabi/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include/backward',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST',
    PLAT_CFLAGS   = '-fpic -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -march=armv5te -mtune=xscale -msoft-float -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS} -fno-exceptions -fno-rtti',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-9/arch-arm -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS} $(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/armeabi/libgnustl_static.a',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_x86 = {
    MAKEFILE      = 'Makefile.android_x86',
    HOST          = 'Linux, Windows and Darwin',
    HEADERMSG     = 'Download the Android NDK, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/x86-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/i686-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/x86-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/i686-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/x86-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/i686-linux-android-as',
    AR            = '$(NDK_ROOT_DIR)/toolchains/x86-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/i686-linux-android-ar',
    EXT           = 'android_x86',
    SO            = 'so',
    PLATFORM      = 'android',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-9/arch-x86/usr/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/x86/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include/backward',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST',
    PLAT_CFLAGS   = '-ffunction-sections -funwind-tables -no-canonical-prefixes -fstack-protector -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS} -fno-exceptions -fno-rtti',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-9/arch-x86 -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS} $(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/x86/libgnustl_static.a',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_mips = {
    MAKEFILE      = 'Makefile.android_mips',
    HOST          = 'Linux, Windows and Darwin',
    HEADERMSG     = 'Download the Android NDK, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/mipsel-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/mipsel-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/mipsel-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/mipsel-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/mipsel-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/mipsel-linux-android-as',
    AR            = '$(NDK_ROOT_DIR)/toolchains/mipsel-linux-android-$(NDK_TOOLCHAIN_VERSION)/prebuilt/' .. host .. '/bin/mipsel-linux-android-ar',
    EXT           = 'android_mips',
    SO            = 'so',
    PLATFORM      = 'android',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-9/arch-mips/usr/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/mips/include -I$(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/include/backward',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST',
    PLAT_CFLAGS   = '-fpic -fno-strict-aliasing -finline-functions -ffunction-sections -funwind-tables -fmessage-length=0 -fno-inline-functions-called-once -fgcse-after-reload -frerun-cse-after-loop -frename-registers -no-canonical-prefixes -fomit-frame-pointer -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS} -fno-exceptions -fno-rtti',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-9/arch-mips -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS} $(NDK_ROOT_DIR)/sources/cxx-stl/gnu-libstdc++/$(NDK_TOOLCHAIN_VERSION)/libs/mips/libgnustl_static.a',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  linux_x86 = {
    MAKEFILE      = 'Makefile.linux_x86',
    HOST          = 'Linux',
    HEADERMSG     = 'apt-get install g++-multilib libc6-dev-i386',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    AR            = 'ar',
    EXT           = 'linux_x86',
    SO            = 'so',
    PLATFORM      = 'unix',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m32 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m32 -shared -lm -Wl,-version-script=$(BUILD_DIR)/link.T -Wl,-no-undefined',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  linux_portable_x86 = {
    MAKEFILE      = 'Makefile.linux-portable_x86',
    HOST          = 'Linux',
    HEADERMSG     = 'apt-get install g++-multilib libc6-dev-i386',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    AR            = 'ar',
    EXT           = 'linux-portable_x86',
    SO            = 'so',
    PLATFORM      = 'unix',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m32 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m32 -shared -lm -Wl,-version-script=$(BUILD_DIR)/link.T',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  linux_x86_64 = {
    MAKEFILE      = 'Makefile.linux_x86_64',
    HOST          = 'Linux',
    HEADERMSG     = '',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    AR            = 'ar',
    EXT           = 'linux_x86_64',
    SO            = 'so',
    PLATFORM      = 'unix',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m64 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m64 -shared -lm -Wl,-version-script=$(BUILD_DIR)/link.T -Wl,-no-undefined',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  linux_portable_x86_64 = {
    MAKEFILE      = 'Makefile.linux-portable_x86_64',
    HOST          = 'Linux',
    HEADERMSG     = '',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    AR            = 'ar',
    EXT           = 'linux-portable_x86_64',
    SO            = 'so',
    PLATFORM      = 'unix',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m64 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m64 -shared -lm -Wl,-version-script=$(BUILD_DIR)/link.T',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  windows_x86 = {
    MAKEFILE      = 'Makefile.windows_x86',
    HOST          = 'Linux',
    HEADERMSG     = 'apt-get install mingw-w64',
    CC            = 'i686-w64-mingw32-gcc',
    CXX           = 'i686-w64-mingw32-g++',
    AS            = 'i686-w64-mingw32-as',
    AR            = 'i686-w64-mingw32-ar',
    EXT           = 'windows_x86',
    SO            = 'dll',
    PLATFORM      = 'win',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  windows_x86_64 = {
    MAKEFILE      = 'Makefile.windows_x86_64',
    HOST          = 'Linux',
    HEADERMSG     = 'apt-get install mingw-w64',
    CC            = 'x86_64-w64-mingw32-gcc',
    CXX           = 'x86_64-w64-mingw32-g++',
    AS            = 'x86_64-w64-mingw32-as',
    AR            = 'x86_64-w64-mingw32-ar',
    EXT           = 'windows_x86_64',
    SO            = 'dll',
    PLATFORM      = 'win',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  osx_x86 = {
    MAKEFILE      = 'Makefile.osx_x86',
    HOST          = 'Linux',
    HEADERMSG     = 'Compile and install OSXCROSS: https://github.com/tpoechtrager/osxcross',
    CC            = '$(OSXCROSS_ROOT_DIR)/target/bin/i386-apple-darwin13-cc',
    CXX           = '$(OSXCROSS_ROOT_DIR)/target/bin/i386-apple-darwin13-c++',
    AS            = '$(OSXCROSS_ROOT_DIR)/target/bin/i386-apple-darwin13-as',
    AR            = '$(OSXCROSS_ROOT_DIR)/target/bin/i386-apple-darwin13-ar',
    EXT           = 'osx_x86',
    SO            = 'dylib',
    PLATFORM      = 'osx',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  osx_x86_64 = {
    MAKEFILE      = 'Makefile.osx_x86_64',
    HOST          = 'Linux',
    HEADERMSG     = 'Compile and install OSXCROSS: https://github.com/tpoechtrager/osxcross',
    CC            = '$(OSXCROSS_ROOT_DIR)/target/bin/x86_64-apple-darwin13-cc',
    CXX           = '$(OSXCROSS_ROOT_DIR)/target/bin/x86_64-apple-darwin13-c++',
    AS            = '$(OSXCROSS_ROOT_DIR)/target/bin/x86_64-apple-darwin13-as',
    AR            = '$(OSXCROSS_ROOT_DIR)/target/bin/x86_64-apple-darwin13-ar',
    EXT           = 'osx_x86_64',
    SO            = 'dylib',
    PLATFORM      = 'osx',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  mingw32 = {
    MAKEFILE      = 'Makefile.mingw_x86',
    HOST          = 'Windows',
    HEADERMSG     = 'Install MSYS2',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    AR            = 'ar',
    EXT           = 'mingw_x86',
    SO            = 'dll',
    PLATFORM      = 'win',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m32 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m32 -shared -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  mingw64 = {
    MAKEFILE      = 'Makefile.mingw_x86_64',
    HOST          = 'Windows',
    HEADERMSG     = 'Install MSYS2',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    AR            = 'ar',
    EXT           = 'mingw_x86_64',
    SO            = 'dll',
    PLATFORM      = 'win',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m64 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m64 -shared -lm',
    PLAT_LDXFLAGS = '${PLAT_LDFLAGS}',
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  wii = {
    MAKEFILE       = 'Makefile.wii_ppc',
    HOST           = 'Linux',
    HEADERMSG      = 'Install devkitppc',
    CC             = '$(DEVKITPPC_ROOT_DIR)/bin/powerpc-eabi-gcc',
    CXX            = '$(DEVKITPPC_ROOT_DIR)/bin/powerpc-eabi-g++',
    AS             = '$(DEVKITPPC_ROOT_DIR)/bin/powerpc-eabi-as',
    AR             = '$(DEVKITPPC_ROOT_DIR)/bin/powerpc-eabi-ar',
    EXT            = 'wii_ppc',
    SO             = 'so',
    PLATFORM       = 'wii',
    PLAT_INCDIR    = '',
    PLAT_DEFS      = '-DGEKKO -DHW_RVL',
    PLAT_CFLAGS    = '-m32 -fstrict-aliasing -mrvl -mcpu=750 -meabi -mhard-float',
    PLAT_CXXFLAGS  = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS   = '-shared -lm',
    PLAT_LDXFLAGS  = '${PLAT_LDFLAGS}',
    STATIC_LINKING = '1'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  vita = {
    MAKEFILE       = 'Makefile.vita_arm',
    HOST           = 'Linux',
    HEADERMSG      = 'Install vitasdk',
    CC             = '$(VITASDK)/bin/arm-vita-eabi-gcc',
    CXX            = '$(VITASDK)/bin/arm-vita-eabi-g++',
    AS             = '$(VITASDK)/bin/arm-vita-eabi-as',
    AR             = '$(VITASDK)/bin/arm-vita-eabi-ar',
    EXT            = 'vita_arm',
    SO             = 'so',
    PLATFORM       = 'vita',
    PLAT_INCDIR    = '',
    PLAT_DEFS      = '-DVITA',
    PLAT_CFLAGS    = '-ftree-vectorize -mfloat-abi=hard -ffast-math -fsingle-precision-constant -funroll-loops -fno-short-enums',
    PLAT_CXXFLAGS  = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS   = '-shared -lm -mthumb -mcpu=cortex-a9 -mfloat-abi=hard',
    PLAT_LDXFLAGS  = '${PLAT_LDFLAGS}',
    STATIC_LINKING = '1'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  vita = {
    MAKEFILE       = 'Makefile.ps3_ppc',
    HOST           = 'Windows or Linux using Wine',
    HEADERMSG      = 'Install CellSDK',
    CC             = '$(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-gcc',
    CXX            = '$(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-g++',
    AS             = '$(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-as',
    AR             = '$(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-ar',
    EXT            = 'ps3_ppc',
    SO             = 'so',
    PLATFORM       = 'ps3',
    PLAT_INCDIR    = '',
    PLAT_DEFS      = '-D__CELLOS_LV2__',
    PLAT_CFLAGS    = '-DMSB_FIRST -DWORDS_BIGENDIAN=1',
    PLAT_CXXFLAGS  = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS   = '-shared -lm',
    PLAT_LDXFLAGS  = '${PLAT_LDFLAGS}',
    STATIC_LINKING = '1'
  },
}

for plat, defs in pairs( platforms ) do
  local templ = template
  local equal

  defs.STATIC_LINKING = defs.STATIC_LINKING or '0'
  defs.TARGET_PLATFORM = defs.EXT

  repeat
    equal = true

    for def, value in pairs( defs ) do
      local templ2 = templ:gsub( '%${' .. def .. '}', ( value:gsub( '%%', '%%%%' ) ) )
      equal = equal and templ == templ2
      templ = templ2
    end
  until equal

  local file = assert( io.open( defs.MAKEFILE, 'wb' ) )
  file:write( templ )
  file:close()
end

local ordered = {}

for _, defs in pairs( platforms ) do
  ordered[ #ordered + 1 ] = defs
end

table.sort( ordered, function( e1, e2 ) return e1.EXT < e2.EXT end )

local else_ = ''

for _, defs in ipairs( ordered ) do
  io.write( else_, 'ifeq ($(platform),', defs.EXT, ')\n' )
  io.write( 'include $(BUILD_DIR)/Makefile.', defs.EXT, '\n' )
  else_ = 'else '
end

io.write( 'else\n' )
