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
	[self setWindow:[[NSWindow alloc] initWithContentRect:[[NSScreen mainScreen] frame] styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask) backing:NSBackingStoreRetained defer:YES]];
	
	[self setRootWindowController:[[RootWindowController alloc] initWithWindow:[self window]]];
	
	[[self window] makeKeyAndOrderFront:self];
}

@end