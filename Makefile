APPNAME = cowin-bot
LinuxLocation = build/linux/x64/release/bundle/cowin_vaccination_bot
AndroidLocation = build/app/outputs/apk/release/app-release.apk

compile_app:
	flutter config --enable-linux-desktop
	flutter build apk
	flutter build linux
release:
	mkdir release
	mv $(LinuxLocation) release/$(APPNAME)-linux.AppImage
	mv $(AndroidLocation) release/$(APPNAME).apk
clean:
	rm -rf release/