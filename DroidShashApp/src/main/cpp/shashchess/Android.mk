LOCAL_PATH := $(call my-dir)

SF_SRC_FILES := \
	benchmark.cpp bitbase.cpp bitboard.cpp endgame.cpp evaluate.cpp learn.cpp main.cpp \
	material.cpp misc.cpp montecarlo.cpp movegen.cpp movepick.cpp pawns.cpp position.cpp psqt.cpp \
	search.cpp thread.cpp timeman.cpp tt.cpp uci.cpp ucioption.cpp tune.cpp syzygy/tbprobe.cpp \
	nnue/evaluate_nnue.cpp nnue/features/half_ka_v2_hm.cpp

MY_ARCH_DEF :=
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
  MY_ARCH_DEF += -DUSE_NEON -mthumb -march=armv7-a -mfloat-abi=softfp -mfpu=neon
  LOCAL_ARM_NEON := true
endif
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
  MY_ARCH_DEF += -DIS_64BIT -DUSE_POPCNT -DUSE_NEON
endif
ifeq ($(TARGET_ARCH_ABI),x86_64)
  MY_ARCH_DEF += -DIS_64BIT -DUSE_SSE41 -msse4.1
endif
ifeq ($(TARGET_ARCH_ABI),x86)
  MY_ARCH_DEF += -DUSE_SSE41 -msse4.1
endif

include $(CLEAR_VARS)
LOCAL_MODULE    := shashchess
include $(LOCAL_PATH)/build_sf.mk

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
  MY_ARCH_DEF := -mthumb -march=armv7-a -mfloat-abi=softfp
  include $(CLEAR_VARS)
  LOCAL_ARM_NEON  := false
  LOCAL_MODULE    := shashchess_nosimd
  include $(LOCAL_PATH)/build_sf.mk
  shashchess : shashchess_nosimd
endif

ifeq ($(TARGET_ARCH_ABI),x86)
  MY_ARCH_DEF :=
  include $(CLEAR_VARS)
  LOCAL_MODULE    := shashchess_nosimd
  include $(LOCAL_PATH)/build_sf.mk
  shashchess : shashchess_nosimd
endif
