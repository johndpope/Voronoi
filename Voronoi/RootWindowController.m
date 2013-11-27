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

#import "VoronoiView.h"
#import "MTRandom.h"
#import "Voronoi.h";

@interface RootWindowController ()

@property (nonatomic) VoronoiView *voronoiView;
@property (nonatomic) CreateDiagramPanel *createDiagramPanel;

@end

@implementation RootWindowController

#pragma mark - CreateDiagramPanel

- (void)createDiagramPanelDidConfirmWithGridDiagramType:(CreateDiagramPanel *)panel xMargin:(NSUInteger)xMargin yMargin:(NSUInteger)yMargin numberOfIterations:(NSUInteger)numberOfIterations columns:(NSUInteger)columns rows:(NSUInteger)rows
{
	[[self window] endSheet:panel];
	
	NSView *contentView = self.window.contentView;
	
	CGFloat x = (xMargin > 0 ? (xMargin / 2.0) : xMargin);
	CGFloat y = (yMargin > 0 ? (yMargin / 2.0) : yMargin);
	
	NSRect rectangle = NSMakeRect(x, y, (contentView.frame.size.width - xMargin), (contentView.frame.size.height - yMargin));
	
	CGFloat xStep = (rectangle.size.width / columns);
	CGFloat yStep = (rectangle.size.height / rows);
	CGFloat xHalfStep = (xStep / 2.0);
	CGFloat yHalfStep = (yStep / 2.0);
	
	NSMutableArray *siteEvents = [NSMutableArray array];
	
	for(NSInteger row = 0; row < rows; ++row)
	{
		for(NSInteger column = 0; column < columns; ++column)
		{
			CGPoint position = rectangle.origin;
			
			position.x += ((column * xStep) + xHalfStep);
			position.y += ((row * yStep) + yHalfStep);
			
			VoronoiSiteEvent *siteEvent = [[VoronoiSiteEvent alloc] initWithPosition:position];
			
			[siteEvents addObject:siteEvent];
		}
	}
	
	[[self voronoiView] setSiteEvents:[NSArray arrayWithArray:siteEvents]];
	
	[[self voronoiView] setNeedsDisplay:YES];
}

- (void)createDiagramPanelDidConfirmWithRandomDiagramType:(CreateDiagramPanel *)panel xMargin:(NSUInteger)xMargin yMargin:(NSUInteger)yMargin numberOfIterations:(NSUInteger)numberOfIterations numberOfSites:(NSUInteger)numberOfSites seed:(NSUInteger)seed
{
	[[self window] endSheet:panel];
	
	NSView *contentView = self.window.contentView;
	
	CGFloat x = (xMargin > 0 ? (xMargin / 2.0) : xMargin);
	CGFloat y = (yMargin > 0 ? (yMargin / 2.0) : yMargin);
	
	NSRect rectangle = NSMakeRect(x, y, (contentView.frame.size.width - xMargin), (contentView.frame.size.height - yMargin));
	
	unsigned int randomSeed = (unsigned int)seed;
	
	MTRandom *randomNumberGenerator = [[MTRandom alloc] initWithSeed:randomSeed];
	
	NSMutableArray *siteEvents = [NSMutableArray array];
	
	for(NSInteger index = 0; index < numberOfSites; ++index)
	{
		CGPoint position = NSZeroPoint;
		
		position.x = [randomNumberGenerator randomDoubleFrom:rectangle.origin.x to:(rectangle.origin.x + rectangle.size.width)];
		position.y = [randomNumberGenerator randomDoubleFrom:rectangle.origin.y to:(rectangle.origin.y + rectangle.size.height)];
		
		VoronoiSiteEvent *siteEvent = [[VoronoiSiteEvent alloc] initWithPosition:position];
		
		[siteEvents addObject:siteEvent];
	}
	
	[[self voronoiView] setSiteEvents:[NSArray arrayWithArray:siteEvents]];
	
	[[self voronoiView] setNeedsDisplay:YES];
}

- (void)createDiagramPanelDidConfirmWithSpiralDiagramType:(CreateDiagramPanel *)panel xMargin:(NSUInteger)xMargin yMargin:(NSUInteger)yMargin numberOfIterations:(NSUInteger)numberOfIterations spiralChord:(CGFloat)spiralChord
{
	[[self window] endSheet:panel];
	
	NSView *contentView = self.window.contentView;
	
	CGFloat x = (xMargin > 0 ? (xMargin / 2.0) : xMargin);
	CGFloat y = (yMargin > 0 ? (yMargin / 2.0) : yMargin);
	
	NSRect rectangle = NSMakeRect(x, y, (contentView.frame.size.width - xMargin), (contentView.frame.size.height - yMargin));
	
	CGPoint origin = NSZeroPoint;
	
	origin.x = (rectangle.origin.x + (rectangle.size.width / 2.0));
	origin.y = (rectangle.origin.y + (rectangle.size.height / 2.0));
	
	NSMutableArray *siteEvents = [NSMutableArray array];
	
	VoronoiSiteEvent *siteEvent = [[VoronoiSiteEvent alloc] initWithPosition:origin];
	
	[siteEvents addObject:siteEvent];
	
	[[self voronoiView] setSiteEvents:[NSArray arrayWithArray:siteEvents]];
	
	[[self voronoiView] setNeedsDisplay:YES];
}

- (void)createDiagramPanelDidCancel:(CreateDiagramPanel *)panel
{
	[[self window] endSheet:panel];
}

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
	[[self window] beginSheet:[self createDiagramPanel] completionHandler:nil];
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
		
		[self setCreateDiagramPanel:[[CreateDiagramPanel alloc] initWithContentRect:NSMakeRect(0.0, 0.0, 280.0, 350.0) styleMask:NSClosableWindowMask backing:NSBackingStoreBuffered defer:YES]];
		
		[[self createDiagramPanel] setDiagramDelegate:self];
		
		[[self window] setContentView:[self voronoiView]];
		
		[self setupMenu];
	}
	
	return self;
}

@end