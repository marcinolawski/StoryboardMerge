StoryboardMerge
===============

![alt tag](http://marcinolawski.pl/Tools_files/Screenshot2.jpg)

Storyboard diff and merge tool which:
- compares and merges two storyboard files,
- provides an automatic merge-facility,

The storyboarding is a new UI design feature introduced with the Xcode 4.2 which allows to describe all the application’s UI in one file. This very handy mechanism has one major drawback. Because all the UI lives in one file, the whole UI design process is very prone to revision control conflicts. Moreover, the Xcode standard merging mechanism treats storyboard files like ordinary text files which further complicates merging.  The StoryboardMerge solves those problems.

How to use
==========
Load two conflicted storyboard files from disk, SVN or Git and click Compare.

The StoryboardMerge compares files and shows conflicts (differences). Use checkboxes to tell the StoryboardMerge how to solve conflicts. 

After setting all checkboxes click Merge. You will see the merged storyboard in a right panel. 

The StoryboardMerge will validate a new storyboard and mark in red incorrect elements.

Click Save to write a new storyboard or override the old one.

How to use as a git mergetool
=============================
Edit your `~/.gitconfig` file and add the following section:

```
[mergetool "storyboard"]
	name = StoryboardMerge interactive merge
	cmd = storyboard-merge $BASE $LOCAL $REMOTE $MERGED
	trustExitCode = false
```

Copy [storyboard-merge](https://github.com/marcinolawski/StoryboardMerge/blob/master/storyboard-merge) into `/usr/local/bin` and make it executable:

```bash
$ chmod 755 /usr/local/bin/storyboard-merge
```

When a storyboard conflict occurs:

```bash
$ git status
On branch master
Your branch and 'origin/master' have diverged,
and have 1 and 1 different commit each, respectively.
  (use "git pull" to merge the remote branch into yours)

You have unmerged paths.
  (fix conflicts and run "git commit")

Unmerged paths:
  (use "git add <file>..." to mark resolution)

	both modified:   Storyboards/Base.lproj/Main.storyboard

no changes added to commit (use "git add" and/or "git commit -a")
```

Run:

```bash
$ git mergetool -t storyboard
```

Which will give you the following prompt in your terminal:

```bash
$ git mergetool -t storyboard
Merging:
Storyboards/Base.lproj/Main.storyboard

Normal merge conflict for 'Storyboards/Base.lproj/Main.storyboard':
  {local}: modified file
  {remote}: modified file
Hit return to start merge resolution tool (storyboard): 
```

Hit `return` to accept the default (as defined in your `~/.gitconfig` above.) Which will launch StoryboardMerge and give you the following prompt in your terminal:

```bash
Storyboards/Base.lproj/Main.storyboard seems unchanged.
Was the merge successful? [y/n]
```

When your merge is complete, press the StoryboardMerge 'save' toolbar icon, which will save the file to the proper place, then return to your terminal and type 'y' to accept the merge. (Or 'n' if something went wrong and you'd like to start over.)

After merging I'd recommend opening the file in Xcode and verifying everything is okay and to allow it to rewrite any changes is sees fit before committing your changes.

Building
========

**IMPORTANT**: StoryboardMerge uses CocoaPods so make sure to always open the workspace file (StoryboardMerge.xcworkspace) instead of the project file (StoryboardMerge.xcodeproj) when building.

More info
=========

See http://marcinolawski.pl/Tools.html
