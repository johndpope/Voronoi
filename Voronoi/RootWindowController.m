//
//*******
//
//	filename: RootWindowController.m
//	author: Zack Brown
//	date: 04/11/2013
//
//*******
//

#import "RootWindowController.h"

@implementation RootWindowController

#pragma mark - RootWindowController

- (void)setupMenu
{
	NSMenu *mainMenu = [[NSMenu alloc] init];
	
	NSMenu *applicationMenu = [[NSMenu alloc] init];
	
	[applicationMenu addItemWithTitle:@"New Diagram" action:@selector(presentNewDiagramPanel) keyEquivalent:@"n"];
	
	[applicationMenu addItem:[NSMenuItem separatorItem]];
	
	[applicationMenu addItemWithTitle:[NSString stringWithFormat:@"Hide %@", [[NSProcessInfo processInfo] processName]] action:@selector(hide:) keyEquivalent:@"h"];
	
	[applicationMenu addItemWithTitle:@"Show All" action:@selector(unhideAllApplications:) keyEquivalent:@""];
	
	[applicationMenu addItem:[NSMenuItem separatorItem]];
	
	[applicationMenu addItemWithTitle:[NSString stringWithFormat:@"Quit %@", [[NSProcessInfo processInfo] processName]] action:@selector(terminate:) keyEquivalent:@"q"];
	
	NSMenuItem *menuItem = [[NSMenuItem alloc] init];
	
	[menuItem setSubmenu:applicationMenu];
	
	[mainMenu addItem:menuItem];
	
	[[NSApplication sharedApplication] setMainMenu:mainMenu];
}

- (void)presentNewDiagramPanel
{

}

#pragma mark - NSWindowController

- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	
	if(self)
	{
		[[self window] setTitle:[[NSProcessInfo processInfo] processName]];
		[[self window] setDelegate:self];
		
		[self setupMenu];
	}
	
	return self;
}

@end