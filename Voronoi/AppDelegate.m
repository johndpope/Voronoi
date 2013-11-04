//
//*******
//
//	filename: AppDelegate.m
//	author: Zack Brown
//	date: 04/11/2013
//
//*******
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self setWindow:[[NSWindow alloc] initWithContentRect:NSMakeRect(0.0, 0.0, 100.0, 100.0) styleMask:NSTitledWindowMask backing:NSBackingStoreRetained defer:YES screen:[NSScreen mainScreen]]];
	
	[[self window] makeKeyAndOrderFront:self];
}

@end