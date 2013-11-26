//
//*******
//
//	filename: VoronoiEvent.m
//	author: Zack Brown
//	date: 26/11/2013
//
//*******
//

#import "VoronoiEvent.h"

@implementation VoronoiEvent

- (id)initWithPosition:(CGPoint)position
{
	self = [super init];
	
	if(self)
	{
		[self setPosition:position];
	}
	
	return self;
}

@end