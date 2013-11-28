//
//*******
//
//	filename: VoronoiCorner.m
//	author: Zack Brown
//	date: 28/11/2013
//
//*******
//

#import "VoronoiCorner.h"

#import "VoronoiEdge.h"

@interface VoronoiCorner ()

@property (nonatomic, readwrite) NSPoint position;
@property (nonatomic, readwrite) VoronoiEdge *leftEdge;
@property (nonatomic, readwrite) VoronoiEdge	*rightEdge;

@end

@implementation VoronoiCorner

#pragma mark - VoronoiCorner

#pragma mark - NSObject

- (id)initWithPosition:(NSPoint)position leftEdge:(VoronoiEdge *)leftEdge rightEdge:(VoronoiEdge *)rightEdge
{
	self = [super init];
	
	if(self)
	{
		[self setPosition:position];
		
		[self setLeftEdge:leftEdge];
		[self setRightEdge:rightEdge];
	}
	
	return self;
}

@end