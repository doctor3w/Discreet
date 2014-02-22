include theos/makefiles/common.mk

TWEAK_NAME = Discreet
Discreet_FILES = Tweak.xm DListener.x
Discreet_FRAMEWORKS = UIKit AudioToolbox
ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
