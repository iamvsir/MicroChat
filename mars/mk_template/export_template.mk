#LOCAL_MODULE :=
#LOCAL_EXPORT_CFLAGS :=
#LOCAL_EXPORT_CPPFLAGS :=
#LOCAL_EXPORT_C_INCLUDES :=
#LOCAL_EXPORT_LDFLAGS :=
#LOCAL_EXPORT_LDLIBS :=

LOCAL_EXPORT_STATIC_LIBRARIES := $(LOCAL_EXPORT_STATIC_LIBRARIES)
LOCAL_EXPORT_SHARED_LIBRARIES := $(LOCAL_EXPORT_SHARED_LIBRARIES)
LOCAL_EXPORT_SRC_FILES := $(LOCAL_EXPORT_SRC_FILES)

upper-case = $(subst a,A,$(subst b,B,$(subst c,C,$(subst d,D,$(subst e,E,$(subst f,F,$(subst g,G,$(subst h,H,$(subst i,I,$(subst j,J,$(subst k,K,$(subst l,L,$(subst m,M,$(subst n,N,$(subst o,O,$(subst p,P,$(subst q,Q,$(subst r,R,$(subst s,S,$(subst t,T,$(subst u,U,$(subst v,V,$(subst w,W,$(subst x,X,$(subst y,Y,$(subst z,Z,$1))))))))))))))))))))))))))

include $(EXPORT_LOCAL_PATH)/build.conf

ifeq ($(SELF_BUILD_CMD), BUILD_SHARED_LIBRARY)
ifeq ($(filter $(SELF_LOCAL_MODULE),$(LOCAL_EXPORT_SHARED_LIBRARIES)),)
include $(CLEAR_VARS)  
LOCAL_MODULE := $(SELF_LOCAL_MODULE)
LOCAL_EXPORT_CFLAGS := $(SELF_LOCAL_EXPORT_CFLAGS)
LOCAL_EXPORT_CPPFLAGS := $(SELF_LOCAL_EXPORT_CPPFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(SELF_LOCAL_EXPORT_C_INCLUDES)
LOCAL_EXPORT_LDFLAGS := $(SELF_LOCAL_EXPORT_LDFLAGS)
LOCAL_EXPORT_LDLIBS := $(SELF_LOCAL_EXPORT_LDLIBS)
$(info 'export LOCAL_MODULE=$(SELF_LOCAL_MODULE) shared  $(SELF_LOCAL_EXPORT_C_INCLUDES)')

LOCAL_SRC_FILES := $(EXPORT_LOCAL_PATH)/../libs/$(TARGET_ARCH_ABI)/lib$(LIBPREFIX)$(SELF_LOCAL_MODULE).so 
LOCAL_SRC_FILES := $(LOCAL_SRC_FILES:$(LOCAL_PATH)/%=%)
LOCAL_EXPORT_CFLAGS +=-DMARS_$(call upper-case,$(LOCAL_MODULE))

include $(PREBUILT_SHARED_LIBRARY)

endif

LOCAL_EXPORT_SHARED_LIBRARIES += $(SELF_LOCAL_MODULE)

endif


ifeq ($(SELF_BUILD_CMD), BUILD_STATIC_LIBRARY)
ifeq ($(filter $(SELF_LOCAL_MODULE),$(LOCAL_EXPORT_STATIC_LIBRARIES)),)
include $(CLEAR_VARS)  
LOCAL_MODULE := $(SELF_LOCAL_MODULE)
LOCAL_EXPORT_CFLAGS := $(SELF_LOCAL_EXPORT_CFLAGS)
LOCAL_EXPORT_CPPFLAGS := $(SELF_LOCAL_EXPORT_CPPFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(SELF_LOCAL_EXPORT_C_INCLUDES)
LOCAL_EXPORT_LDFLAGS := $(SELF_LOCAL_EXPORT_LDFLAGS)
LOCAL_EXPORT_LDLIBS := $(SELF_LOCAL_EXPORT_LDLIBS)
$(info 'export LOCAL_MODULE=$(SELF_LOCAL_MODULE) static $(SELF_LOCAL_EXPORT_C_INCLUDES)')

LOCAL_SRC_FILES := $(EXPORT_LOCAL_PATH)/../obj/local/$(TARGET_ARCH_ABI)/lib$(LIBPREFIX)$(SELF_LOCAL_MODULE).a
LOCAL_SRC_FILES := $(LOCAL_SRC_FILES:$(LOCAL_PATH)/%=%)

LOCAL_EXPORT_CFLAGS +=-DMARS_$(call upper-case,$(LOCAL_MODULE))

include $(PREBUILT_STATIC_LIBRARY)

LOCAL_EXPORT_SRC_FILES += $(SELF_LOCAL_EXPORT_SRC_FILES) 
endif
LOCAL_EXPORT_STATIC_LIBRARIES += $(SELF_LOCAL_MODULE)
endif

ifeq ($(EXPORT_LOCAL_PATH)/import.mk, $(wildcard  $(EXPORT_LOCAL_PATH)/import.mk))
ifeq ($(SELF_BUILD_CMD), BUILD_SHARED_LIBRARY)
LOCAL_EXPORT_STATIC_LIBRARIES += $(SELF_LOCAL_MODULE)_shared{
else
LOCAL_EXPORT_STATIC_LIBRARIES += $(SELF_LOCAL_MODULE)_static{
endif
include $(EXPORT_LOCAL_PATH)/import.mk
LOCAL_EXPORT_STATIC_LIBRARIES += }
endif

