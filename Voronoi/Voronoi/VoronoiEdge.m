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

@interface VoronoiEdge ()

@property (nonatomic, readwrite) NSPoint start;
@property (nonatomic, readwrite) NSPoint end;
@property (nonatomic, readwrite) VoronoiSiteEvent *leftSiteEvent;
@property (nonatomic, readwrite) VoronoiSiteEvent *rightSiteEvent;
@property (nonatomic, readwrite) CGFloat direction;
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
		#warning implement me
	}
	
	return self;
}

@end