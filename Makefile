TARGET =: clang
export ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = Discreet
Discreet_FILES = Tweak.xm
Discreet_FRAMEWORKS = UIKit AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += discreetprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
