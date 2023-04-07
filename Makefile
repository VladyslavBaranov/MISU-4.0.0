run:
	pod deintegrate
	sudo gem install cocoapods-clean
	pod clean
	pod setup
	pod install

clean: 
	git credential-osxkeychain erase 
	print "%s\n" host=github.com | protocol=https

git_clean:
	git status
	git reset --hard
	git pull
	git status

git_fast:
	git add -u
	git status
ifdef m
	git commit -m "$(m)"
else
	git commit -m "Fast push"
endif
ifdef b
	git push origin $(b)
else
	git push origin master
endif


fix_inerface:
ifdef w
	git checkout --$(w) CoronaVirTracker.xcworkspace/xcuserdata/dmytrokruhlov.xcuserdatad/UserInterfaceState.xcuserstate
else
	git checkout --theirs CoronaVirTracker.xcworkspace/xcuserdata/dmytrokruhlov.xcuserdatad/UserInterfaceState.xcuserstate
endif
