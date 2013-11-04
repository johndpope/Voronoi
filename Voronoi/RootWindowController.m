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

- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	
	if(self)
	{
		[[self window] setTitle:@"Voronoi"];
		[[self window] setDelegate:self];
	}
	
	return self;
}

@end