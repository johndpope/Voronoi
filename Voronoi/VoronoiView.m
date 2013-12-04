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
@property (nonatomic) NSColor *edgeStrokeColor;
@property (nonatomic) NSColor *cornerFillColor;
@property (nonatomic) NSColor *cornerStrokeColor;

@end

@implementation VoronoiView

#pragma mark - VoronoiView

- (void)drawCell:(VoronoiCell *)cell
{
	[[self siteStrokeColor] setStroke];
	[[self siteFillColor] setFill];
	
	CGFloat radius = 2.5;
	
	NSRect rectangle = NSMakeRect((cell.position.x - radius), (cell.position.y - radius), (radius * 2.0), (radius * 2.0));
	
	NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:rectangle xRadius:radius yRadius:radius];
	
	[bezierPath fill];
	[bezierPath stroke];
	
	bezierPath = [NSBezierPath bezierPathWithRect:[self contentFrame]];
	
	[bezierPath stroke];
	
	[[self edgeStrokeColor] setStroke];
	
	[[cell edges] enumerateObjectsUsingBlock:^(VoronoiEdge *edge, NSUInteger idx, BOOL *stop)
	{
		[bezierPath removeAllPoints];
		
		[bezierPath moveToPoint:[edge start]];
		
		[bezierPath lineToPoint:[edge end]];
		
		[bezierPath stroke];
	}];
	
	[[self cornerStrokeColor] setStroke];
	[[self cornerFillColor] setFill];
	
	[[cell corners] enumerateObjectsUsingBlock:^(VoronoiCorner *corner, NSUInteger idx, BOOL *stop)
	{
		[bezierPath removeAllPoints];
		
		NSRect rectangle = NSMakeRect((corner.position.x - radius), (corner.position.y - radius), (radius * 2.0), (radius * 2.0));
		
		[bezierPath appendBezierPathWithRoundedRect:rectangle xRadius:radius yRadius:radius];
		
		[bezierPath fill];
		[bezierPath stroke];
	
	}];
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
		[self setEdgeStrokeColor:[NSColor whiteColor]];
		[self setCornerFillColor:[NSColor colorWithDeviceRed:0.345 green:0.796 blue:0.929 alpha:1]];
		[self setCornerStrokeColor:[NSColor whiteColor]];
	}
	
	return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[self backgroundColor] setFill];
	
	NSRectFill(dirtyRect);
	
	[[self cells] enumerateObjectsUsingBlock:^(VoronoiCell *cell, NSUInteger idx, BOOL *stop)
	{
		[self drawCell:cell];
		
	}];
}

@end