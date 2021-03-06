########################################################################### ###
#@Copyright     Copyright (c) Imagination Technologies Ltd. All Rights Reserved
#@License       Dual MIT/GPLv2
# 
# The contents of this file are subject to the MIT license as set out below.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# Alternatively, the contents of this file may be used under the terms of
# the GNU General Public License Version 2 ("GPL") in which case the provisions
# of GPL are applicable instead of those above.
# 
# If you wish to allow use of your version of this file only under the terms of
# GPL, and not to allow others to use your version of this file under the terms
# of the MIT license, indicate your decision by deleting the provisions above
# and replace them with the notice and other provisions required by GPL as set
# out in the file called "GPL-COPYING" included in this distribution. If you do
# not delete the provisions above, a recipient may use your version of this file
# under the terms of either the MIT license or GPL.
# 
# This License is also included in this distribution in the file called
# "MIT-COPYING".
# 
# EXCEPT AS OTHERWISE STATED IN A NEGOTIATED AGREEMENT: (A) THE SOFTWARE IS
# PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT; AND (B) IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
### ###########################################################################

$(eval $(call UserConfigMake,libpthread_ldflags,))
$(eval $(call UserConfigMake,librt_ldflags,))
$(eval $(call UserConfigMake,LINKER_RPATH,/system/lib))
$(eval $(call UserConfigMake,ANDROID_MOVED_INCLUDES,$(ANDROID_MOVED_INCLUDES)))
$(eval $(call UserConfigMake,TARGET_ROOT,$(TARGET_ROOT)))

$(eval $(call BothConfigMake,SUPPORT_ANDROID_PLATFORM,1))
$(eval $(call BothConfigMake,SUPPORT_ION,1))
$(call NonTunableOption,SUPPORT_ION)

$(eval $(call BothConfigC,ANDROID,))
$(eval $(call BothConfigC,SUPPORT_ION,))

$(eval $(call UserConfigC,OGLES1_BASEPATH,\"$(EGL_DESTDIR)/\"))
$(eval $(call UserConfigC,OGLES3_BASEPATH,\"$(EGL_DESTDIR)/\"))
$(eval $(call UserConfigC,SUPPORT_ANDROID_PLATFORM,1))

# These are set automatically according to the platform version.
$(eval $(call TunableBothConfigC,PVR_ANDROID_NATIVE_WINDOW_HAS_SYNC,))
$(eval $(call TunableBothConfigC,PVR_ANDROID_DISABLE_MULTI_SYNCS,))

# These are user-tunable.


$(eval $(call TunableBothConfigC,PVR_ANDROID_HAS_SW_INCOMPATIBLE_FRAMEBUFFER,,\
Enable this to support running Android$(apos)s software GLES renderer_\
with gralloc from the DDK._\
))


# These are set automatically according to the platform version.
$(eval $(call TunableBothConfigMake,PVR_ANDROID_NATIVE_WINDOW_HAS_SYNC,))

# These are user-tunable.

# Support kernels built out-of-tree with O=/other/path
# In those cases, KERNELDIR will be O, not the source tree.
ifneq ($(wildcard $(KERNELDIR)/source),)
KSRCDIR := $(KERNELDIR)/source
else
KSRCDIR := $(KERNELDIR)
endif

ifneq ($(wildcard $(KSRCDIR)/drivers/staging/android/ion/ion.h),)
# The kernel has a more recent version of ion, located in drivers/staging.
# Change the default header paths and the behaviour wrt sg_dma_len.
PVR_ANDROID_ION_HEADER := \"../drivers/staging/android/ion/ion.h\"
PVR_ANDROID_ION_PRIV_HEADER := \"../drivers/staging/android/ion/ion_priv.h\"
PVR_ANDROID_ION_USE_SG_LENGTH := 1
endif

$(eval $(call TunableKernelConfigC,PVR_ANDROID_ION_HEADER,\"linux/ion.h\"))
$(eval $(call TunableKernelConfigC,PVR_ANDROID_ION_PRIV_HEADER,\"../drivers/gpu/ion/ion_priv.h\"))
$(eval $(call TunableKernelConfigC,PVR_ANDROID_ION_USE_SG_LENGTH,))
