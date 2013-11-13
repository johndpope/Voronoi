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

@implementation VoronoiView

#pragma mark - VoronoiView

#pragma mark - NSView

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor] setFill];
	
	NSRectFill(dirtyRect);
}

@end