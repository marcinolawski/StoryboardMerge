ACEView
=======

Use the wonderful [ACE editor](http://ace.ajax.org/) in your Cocoa applications.

![ACEView example](https://raw.github.com/faceleg/ACEView/master/Collateral/ace-example.jpg)

For great justice.

Usage
=====

Using ACEView is about as easy as it gets. First add the ACEView framework to your project (see [linking library or framework](https://developer.apple.com/library/ios/#recipes/xcode_help-project_editor/Articles/AddingaLibrarytoaTarget.html#//apple_ref/doc/uid/TP40010155-CH17-SW1) for information on how to do this), then add a view to your XIB, and tell it to be an ACEView:

![ACEView XIB](https://raw.github.com/faceleg/ACEView/master/Collateral/ace-xib.jpg)

Make sure you've got an IBOutlet in your view controller, and bind that bad girl:

![ACEView XIB Binding](https://raw.github.com/faceleg/ACEView/master/Collateral/ace-xib-binding.jpg)

Now, you could do something like this:

```ObjectiveC
#import "Cocoa/Cocoa.h"
#import "ACEView/ACEView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, ACEViewDelegate> {
    IBOutlet ACEView *aceView;
}

@property (assign) IBOutlet NSWindow *window;

@end

#import "AppDelegate.h"
#import "ACEView/ACEView.h"
#import "ACEView/ACEModeNames.h"
#import "ACEView/ACEThemeNames.h"

@implementation AppDelegate

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {

    // Note that you'll likely be using local text
    [aceView setString:[NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://github.com/faceleg/ACEView"] encoding:NSUTF8StringEncoding
                                                   error:nil]];
    [aceView setDelegate:self];
    [aceView setMode:ACEModeHTML];
    [aceView setTheme:ACEThemeXcode];
    [aceView setShowInvisibles:YES];
}

- (void) textDidChange:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
```
