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

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self setWindow:[[NSWindow alloc] initWithContentRect:NSInsetRect([[NSScreen mainScreen] frame], 125.0, 125.0) styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask) backing:NSBackingStoreBuffered defer:YES]];
	
	[self setRootWindowController:[[RootWindowController alloc] initWithWindow:[self window]]];
	
	[[self window] makeKeyAndOrderFront:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

@end