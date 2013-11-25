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
#import "CreateDiagramPanelController.h"
#import "VoronoiView.h"

@interface RootWindowController ()

@property (nonatomic) VoronoiView *voronoiView;
@property (nonatomic) CreateDiagramPanelController *createDiagramPanelController;

@end

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
	[[self window] beginSheet:[[self createDiagramPanelController] window] completionHandler:nil];
}

#pragma mark - NSWindowController

- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	
	if(self)
	{
		[[self window] setTitle:[[NSProcessInfo processInfo] processName]];
		[[self window] setDelegate:self];
		
		[self setVoronoiView:[[VoronoiView alloc] init]];
		
		[self setCreateDiagramPanelController:[[CreateDiagramPanelController alloc] initWithWindow:[[NSPanel alloc] initWithContentRect:NSMakeRect(0.0, 0.0, 300.0, 300.0) styleMask:NSClosableWindowMask backing:NSBackingStoreBuffered defer:YES]]];
		
		[[self window] setContentView:[self voronoiView]];
		
		[self setupMenu];
	}
	
	return self;
}

@end