//
//*******
//
//	filename: VoronoiEdge.m
//	author: Zack Brown
//	date: 27/11/2013
//
//*******
//

#import "VoronoiEdge.h"

#import "VoronoiSiteEvent.h"

@interface VoronoiEdge ()

@property (nonatomic, readwrite) VoronoiSiteEvent *leftSiteEvent;
@property (nonatomic, readwrite) VoronoiSiteEvent *rightSiteEvent;
@property (nonatomic, readwrite) NSPoint direction;
@property (nonatomic, readwrite) CGFloat f;
@property (nonatomic, readwrite) CGFloat g;

@end

@implementation VoronoiEdge

#pragma mark - VoronoiEdge

#pragma mark - NSObject

- (id)initWithStart:(NSPoint)start leftSiteEvent:(VoronoiSiteEvent *)leftSiteEvent rightSiteEvent:(VoronoiSiteEvent *)rightSiteEvent
{
	self = [super init];
	
	if(self)
	{
		[self setStart:start];
		
		[self setLeftSiteEvent:leftSiteEvent];
		[self setRightSiteEvent:rightSiteEvent];
		
		[self setF:((rightSiteEvent.position.x - leftSiteEvent.position.x) / (leftSiteEvent.position.y - rightSiteEvent.position.y))];
		[self setG:(start.y - self.f * start.x)];
		
		[self setDirection:NSMakePoint((rightSiteEvent.position.y - leftSiteEvent.position.y), (rightSiteEvent.position.x - leftSiteEvent.position.x))];
	}
	
	return self;
}

@end