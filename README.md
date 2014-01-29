StoryboardMerge
===============

Storyboard diff and merge tool which:
- compares and merges two storyboard files,
- provides an automatic merge-facility,
- supports SVN and Git.

The storyboarding is a new UI design feature introduced with the Xcode 4.2 which allows to describe all the application’s UI in one file. This very handy mechanism has one major drawback. Because all the UI lives in one file, the whole UI design process is very prone to revision control conflicts. Moreover, the Xcode standard merging mechanism treats storyboard files like ordinary text files which further complicates merging.  The StoryboardMerge solves those problems.

How to use
==========
Load two conflicted storyboard files from disk, SVN or Git and click Compare.

The StoryboardMerge compares files and shows conflicts (differences). Use checkboxes to tell the StoryboardMerge how to solve conflicts. 

After setting all checkboxes click Merge. You will see the merged storyboard in a right panel. 

The StoryboardMerge will validate a new storyboard and mark in red incorrect elements.

Click Save to write a new storyboard or override the old one.

More info
=========

See http://marcinolawski.pl/Tools.html
