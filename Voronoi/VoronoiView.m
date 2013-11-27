//
//*******
//
//	filename: VoronoiView.m
//	author: Zack Brown
//	date: 13/11/2013
//
//*******
//

#import "VoronoiView.h"

#import "Voronoi.h"

@interface VoronoiView ()

@property (nonatomic) NSColor *backgroundColor;
@property (nonatomic) NSColor *siteFillColor;
@property (nonatomic) NSColor *siteStrokeColor;

@end

@implementation VoronoiView

#pragma mark - VoronoiView

- (void)drawSiteEvent:(VoronoiSiteEvent *)siteEvent
{
	[[self siteStrokeColor] setStroke];
	[[self siteFillColor] setFill];
	
	CGFloat radius = 2.5;
	
	NSRect rectangle = NSMakeRect((siteEvent.position.x - radius), (siteEvent.position.y - radius), (radius * 2.0), (radius * 2.0));
	
	NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:rectangle xRadius:radius yRadius:radius];
	
	[bezierPath fill];
	[bezierPath stroke];
}

#pragma mark - NSView

- (id)init
{
	self = [super init];
	
	if(self)
	{
		[self setBackgroundColor:[NSColor colorWithDeviceRed:0.161 green:0.165 blue:0.141 alpha:1]];
		[self setSiteFillColor:[NSColor colorWithDeviceRed:0.682 green:0.525 blue:0.988 alpha:1]];
		[self setSiteStrokeColor:[NSColor colorWithDeviceRed:0.463 green:0.447 blue:0.376 alpha:1]];
	}
	
	return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[self backgroundColor] setFill];
	
	NSRectFill(dirtyRect);
	
	[[self siteEvents] enumerateObjectsUsingBlock:^(VoronoiSiteEvent *siteEvent, NSUInteger idx, BOOL *stop)
	{
		[self drawSiteEvent:siteEvent];
		
	}];
}

@end