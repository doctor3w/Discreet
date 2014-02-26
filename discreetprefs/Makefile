include theos/makefiles/common.mk

BUNDLE_NAME = DiscreetPrefs
DiscreetPrefs_FILES = DiscreetPrefs.mm
DiscreetPrefs_INSTALL_PATH = /Library/PreferenceBundles
DiscreetPrefs_FRAMEWORKS = UIKit
DiscreetPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DiscreetPrefs.plist$(ECHO_END)
