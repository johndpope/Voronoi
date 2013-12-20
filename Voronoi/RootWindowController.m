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
#import "Voronoi.h"

@interface RootWindowController ()

@property (nonatomic) VoronoiView *voronoiView;
@property (nonatomic) CreateDiagramPanel *createDiagramPanel;
@property (nonatomic) VoronoiSolver *voronoiSolver;

@end

@implementation RootWindowController

#pragma mark - CreateDiagramPanel

- (void)createDiagramPanelDidConfirmWithGridDiagramType:(CreateDiagramPanel *)panel xMargin:(NSUInteger)xMargin yMargin:(NSUInteger)yMargin numberOfIterations:(NSUInteger)numberOfIterations columns:(NSUInteger)columns rows:(NSUInteger)rows
{
	[[self window] endSheet:panel];
	
	NSView *contentView = self.window.contentView;
	
	NSRect rectangle = NSInsetRect(contentView.frame, xMargin, yMargin);
	
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
	
	NSArray *cells = [[self voronoiSolver] solveSiteEvents:siteEvents numberOfIterations:numberOfIterations bounds:rectangle];
	
	[[self voronoiView] setCells:cells];
	[[self voronoiView] setContentFrame:rectangle];
	
	[[self voronoiView] setNeedsDisplay:YES];
}

- (void)createDiagramPanelDidConfirmWithRandomDiagramType:(CreateDiagramPanel *)panel xMargin:(NSUInteger)xMargin yMargin:(NSUInteger)yMargin numberOfIterations:(NSUInteger)numberOfIterations numberOfSites:(NSUInteger)numberOfSites seed:(NSUInteger)seed
{
	[[self window] endSheet:panel];
	
	NSView *contentView = self.window.contentView;
	
	NSRect rectangle = NSInsetRect(contentView.frame, xMargin, yMargin);
	
	unsigned int randomSeed = (unsigned int)seed;
	
	MTRandom *randomNumberGenerator = [[MTRandom alloc] initWithSeed:randomSeed];
	
	NSMutableArray *siteEvents = [NSMutableArray array];
	
	for(NSInteger index = 0; index < numberOfSites; ++index)
	{
		CGPoint position = NSZeroPoint;
		
		position.x = floorf(rectangle.origin.x + [randomNumberGenerator randomDoubleFrom:0.0 to:rectangle.size.width]);
		position.y = floorf(rectangle.origin.y + [randomNumberGenerator randomDoubleFrom:0.0 to:rectangle.size.height]);
		
		VoronoiSiteEvent *siteEvent = [[VoronoiSiteEvent alloc] initWithPosition:position];
		
		[siteEvents addObject:siteEvent];
	}
	
	NSArray *cells = [[self voronoiSolver] solveSiteEvents:siteEvents numberOfIterations:numberOfIterations bounds:rectangle];
	
	NSLog(@"created %li cells from %li site events", [cells count], [siteEvents count]);
	
	[cells enumerateObjectsUsingBlock:^(VoronoiCell *cell, NSUInteger idx, BOOL *stop)
	{
		NSLog(@"cell has %li edges and %li corners", [[cell edges] count], [[cell corners] count]);
		
	}];
	
	[[self voronoiView] setCells:cells];
	[[self voronoiView] setContentFrame:rectangle];
	
	[[self voronoiView] setNeedsDisplay:YES];
}

- (void)createDiagramPanelDidConfirmWithSpiralDiagramType:(CreateDiagramPanel *)panel xMargin:(NSUInteger)xMargin yMargin:(NSUInteger)yMargin numberOfIterations:(NSUInteger)numberOfIterations spiralChord:(CGFloat)spiralChord
{
	[[self window] endSheet:panel];
	
	NSView *contentView = self.window.contentView;
	
	NSRect rectangle = NSInsetRect(contentView.frame, xMargin, yMargin);
	
	CGPoint origin = NSZeroPoint;
	
	origin.x = (rectangle.origin.x + (rectangle.size.width / 2.0));
	origin.y = (rectangle.origin.y + (rectangle.size.height / 2.0));
	
	NSMutableArray *siteEvents = [NSMutableArray array];
	
	VoronoiSiteEvent *siteEvent = [[VoronoiSiteEvent alloc] initWithPosition:origin];
	
	[siteEvents addObject:siteEvent];
	
	CGFloat maximumRadius = MIN((rectangle.size.width / 2.0), (rectangle.size.height / 2.0));
	
	CGFloat maximumTheta = ((maximumRadius / spiralChord) * (2.0 * M_PI));
	
	CGFloat step = maximumRadius / maximumTheta;
	
	for(CGFloat theta = spiralChord / step; theta <= maximumTheta;)
	{
		CGPoint position = NSZeroPoint;
		
		CGFloat distance = step * theta;
		
		position.x = (origin.x + (cosf(theta) * distance));
		position.y = (origin.y + (sinf(theta) * distance));
		
		VoronoiSiteEvent *siteEvent = [[VoronoiSiteEvent alloc] initWithPosition:position];
		
		[siteEvents addObject:siteEvent];
		
		theta += (spiralChord / distance);
	}
	
	NSArray *cells = [[self voronoiSolver] solveSiteEvents:siteEvents numberOfIterations:numberOfIterations bounds:rectangle];
	
	[[self voronoiView] setCells:cells];
	[[self voronoiView] setContentFrame:rectangle];
	
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
		
		[self setVoronoiSolver:[[VoronoiSolver alloc] init]];
		
		[[self createDiagramPanel] setDiagramDelegate:self];
		
		[[self window] setContentView:[self voronoiView]];
		
		[self setupMenu];
	}
	
	return self;
}

@end