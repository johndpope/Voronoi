//
//*******
//
//	filename: VoronoiSolver.m
//	author: Zack Brown
//	date: 27/11/2013
//
//*******
//

#import "VoronoiSolver.h"

#import "VoronoiCell.h"
#import "VoronoiCircleEvent.h"
#import "VoronoiEdge.h"
#import "VoronoiParabola.h"
#import "VoronoiSiteEvent.h"

@interface VoronoiSolver ()

@property (nonatomic) NSRect bounds;
@property (nonatomic) NSMutableArray *siteEvents;
@property (nonatomic) NSMutableArray *eventQueue;
@property (nonatomic) NSMutableArray *cells;
@property (nonatomic) NSMutableArray *edges;
@property (nonatomic) VoronoiParabola *rootParabola;

@end

@implementation VoronoiSolver

#pragma mark - VoronoiSolver

- (void)reset
{
	[self setNumberOfIterations:1];
	
	[[self siteEvents] removeAllObjects];
	
	[[self eventQueue] removeAllObjects];
	
	[[self cells] removeAllObjects];
	
	[[self edges] removeAllObjects];
	
	[self setRootParabola:nil];
}

- (void)addSiteEvents:(NSArray *)siteEvents
{
	__block CGFloat x = 0.0;
	__block CGFloat y = 0.0;
	__block CGFloat width = 0.0;
	__block CGFloat height = 0.0;
	
	__block NSInteger index = 0;
	
	[[self siteEvents] addObjectsFromArray:siteEvents];
	
	[[self siteEvents] sortUsingComparator:^NSComparisonResult(VoronoiSiteEvent *siteEvent, VoronoiSiteEvent *other)
	{
		if(index == 0)
		{
			x = siteEvent.position.x;
			y = siteEvent.position.y;
			width = siteEvent.position.x;
			height = siteEvent.position.y;
			
			++index;
		}
		else
		{
			x = MIN(x, siteEvent.position.x);
			y = MIN(y, siteEvent.position.y);
			width = MAX(width, siteEvent.position.x);
			height = MAX(height, siteEvent.position.y);
		}
		
		if(CGPointEqualToPoint([siteEvent position], [other position]))
		{
			return NSOrderedSame;
		}
		
		if(siteEvent.position.y < other.position.y)
		{
			return NSOrderedAscending;
		}
		
		return NSOrderedDescending;
	
	}];
	
	[[self eventQueue] addObjectsFromArray:[self siteEvents]];
	
	[self setBounds:NSMakeRect(x, y, width, height)];
}

- (void)setNumberOfIterations:(NSUInteger)numberOfIterations
{
	_numberOfIterations = (numberOfIterations > 0 ? numberOfIterations : 1);
}

- (NSArray *)solve
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	for(NSInteger iteration = 0; iteration < [self numberOfIterations]; ++iteration)
	{
		[self processEvents];
		
		[self processEdges];
		
		if((iteration + 1) < [self numberOfIterations])
		{
			[self relaxCells];
			
			[[self siteEvents] removeAllObjects];
			
			NSMutableArray *siteEvents = [NSMutableArray array];
			
			[[self cells] enumerateObjectsUsingBlock:^(VoronoiCell *cell, NSUInteger idx, BOOL *stop)
			{
				VoronoiSiteEvent *siteEvent = [[VoronoiSiteEvent alloc] initWithPosition:[cell position]];
				
				[siteEvents addObject:siteEvent];
			
			}];
			
			[self addSiteEvents:[NSArray arrayWithArray:siteEvents]];
		}
	}
	
	return [NSArray arrayWithArray:[self cells]];
}

- (void)processEdges
{
	
}

- (void)processEvents
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	while([[self eventQueue] lastObject])
	{
		id event = [[self eventQueue] lastObject];
		
		if(event)
		{
			[[self eventQueue] removeLastObject];
			
			if([event isKindOfClass:[VoronoiCircleEvent class]])
			{
				[self processCircleEvent:event];
			}
			else
			{
				[self processSiteEvent:event];
			}
		}
	}
	
	[self finishEdges];
}

- (void)processSiteEvent:(VoronoiSiteEvent *)siteEvent
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	if(![self rootParabola])
	{
		[self setRootParabola:[[VoronoiParabola alloc] initWithSiteEvent:siteEvent]];
		
		return;
	}
	
	if([[self rootParabola] isLeafNode] && (self.rootParabola.siteEvent.position.y - siteEvent.position.y) < 1.0)
	{
		[[self rootParabola] setIsLeafNode:NO];
		
		[[self rootParabola] setLeftParabola:[[VoronoiParabola alloc] initWithSiteEvent:[[self rootParabola] siteEvent]]];
		[[self rootParabola] setRightParabola:[[VoronoiParabola alloc] initWithSiteEvent:siteEvent]];
		
		VoronoiSiteEvent *event = [[self rootParabola] siteEvent];
		
		#warning self.bounds.size.height may not need self.bounds.origin.y adding
		NSPoint point = NSMakePoint(((siteEvent.position.x + event.position.x) / 2.0), (self.bounds.origin.y + self.bounds.size.height));
		
		if(siteEvent.position.x > event.position.x)
		{
			[[self rootParabola] setEdge:[[VoronoiEdge alloc] initWithStart:point leftSiteEvent:[[self rootParabola] siteEvent] rightSiteEvent:siteEvent]];
		}
		else
		{
			[[self rootParabola] setEdge:[[VoronoiEdge alloc] initWithStart:point leftSiteEvent:siteEvent rightSiteEvent:[[self rootParabola] siteEvent]]];
		}
		
		[[self edges] addObject:[[self rootParabola] edge]];
		
		return;
	}
	
	VoronoiParabola *parabola = [self parabolaIntersectingSiteEvent:siteEvent];
	
	if([parabola circleEvent])
	{
		[[self eventQueue] removeObject:[parabola circleEvent]];
		
		[parabola setCircleEvent:nil];
	}
	
	NSPoint point = NSMakePoint(siteEvent.position.x, [self yOfSiteEvent:[parabola siteEvent] intersectingWithEvent:siteEvent]);
	
	VoronoiEdge *leftEdge = [[VoronoiEdge alloc] initWithStart:point leftSiteEvent:[parabola siteEvent] rightSiteEvent:siteEvent];
	VoronoiEdge *rightEdge = [[VoronoiEdge alloc] initWithStart:point leftSiteEvent:siteEvent rightSiteEvent:[parabola siteEvent]];
	
	[leftEdge setNeighbour:rightEdge];
	
	[[self edges] addObject:leftEdge];
	
	[parabola setEdge:rightEdge];
	[parabola setIsLeafNode:NO];
	
	VoronoiParabola *parabola0 = [[VoronoiParabola alloc] initWithSiteEvent:[parabola siteEvent]];
	VoronoiParabola *parabola1 = [[VoronoiParabola alloc] initWithSiteEvent:siteEvent];
	VoronoiParabola *parabola2 = [[VoronoiParabola alloc] initWithSiteEvent:[parabola siteEvent]];
	VoronoiParabola *leafParabola = [[VoronoiParabola alloc] initWithSiteEvent:nil];
	
	[leafParabola setLeftParabola:parabola0];
	[leafParabola setRightParabola:parabola1];
	[leafParabola setEdge:leftEdge];
	
	[parabola setLeftParabola:leafParabola];
	[parabola setRightParabola:parabola2];
	
	[self checkAndCreateCircleEventWithEvent:siteEvent andParabola:parabola0];
	[self checkAndCreateCircleEventWithEvent:siteEvent andParabola:parabola2];
}

- (void)processCircleEvent:(VoronoiCircleEvent *)circleEvent
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	VoronoiParabola *parabola = [circleEvent parabola];
	
	VoronoiParabola *leftParentParabola = [parabola leftParentParabola];
	VoronoiParabola *rightParentParabola = [parabola rightParentParabola];
	
	VoronoiParabola *leftChildParabola = [leftParentParabola leftChildParabola];
	VoronoiParabola *rightChildParabola = [rightParentParabola rightChildParabola];
	
	if(leftChildParabola && [leftChildParabola circleEvent])
	{
		[[self eventQueue] removeObject:[leftChildParabola circleEvent]];
		
		[leftChildParabola setCircleEvent:nil];
	}
	
	if(rightChildParabola && [rightChildParabola circleEvent])
	{
		[[self eventQueue] removeObject:[rightChildParabola circleEvent]];
		
		[rightChildParabola setCircleEvent:nil];
	}
	
	NSPoint point = NSMakePoint(circleEvent.position.x, [self yOfSiteEvent:[parabola siteEvent] intersectingWithEvent:circleEvent]);
	
	[[leftParentParabola edge] setEnd:point];
	[[rightChildParabola edge] setEnd:point];
	
	VoronoiParabola *rootParabola = nil;
	VoronoiParabola *parentParabola = parabola;
	
	while(![parentParabola isEqualTo:[self rootParabola]])
	{
		parentParabola = [parentParabola parentParabola];
		
		if([parentParabola isEqualTo:leftParentParabola])
		{
			rootParabola = leftParentParabola;
		}
		
		if([parentParabola isEqualTo:rightParentParabola])
		{
			rootParabola = rightParentParabola;
		}
	}

	[rootParabola setEdge:[[VoronoiEdge alloc] initWithStart:point leftSiteEvent:[leftChildParabola siteEvent] rightSiteEvent:[rightChildParabola siteEvent]]];
	
	[[self edges] addObject:[rootParabola edge]];
	
	VoronoiParabola *grandparentParabola = [[parabola parentParabola] parentParabola];
	
	if([[[parabola parentParabola] leftParabola] isEqualTo:parabola])
	{
		if([[grandparentParabola leftParabola] isEqualTo:[parabola parentParabola]])
		{
			[grandparentParabola setLeftParabola:[[parabola parentParabola] rightParabola]];
		}
		else
		{
			[grandparentParabola setRightParabola:[[parabola parentParabola] rightParabola]];
		}
	}
	else
	{
		if([[grandparentParabola leftParabola] isEqualTo:[parabola parentParabola]])
		{
			[grandparentParabola setLeftParabola:[[parabola parentParabola] leftParabola]];
		}
		else
		{
			[grandparentParabola setRightParabola:[[parabola parentParabola] leftParabola]];
		}
	}
	
	[self checkAndCreateCircleEventWithEvent:circleEvent andParabola:leftChildParabola];
	[self checkAndCreateCircleEventWithEvent:circleEvent andParabola:rightChildParabola];
}

- (void)finishEdges
{
	[self finishEdge:[self rootParabola]];
	
	[[self edges] enumerateObjectsUsingBlock:^(VoronoiEdge *edge, NSUInteger idx, BOOL *stop)
	{
		if([edge neighbour])
		{
			[edge setStart:[[edge neighbour] end]];
		}
	
	}];
}

- (void)finishEdge:(VoronoiParabola *)parabola
{
	
}

- (void)relaxCells
{
	
}

- (VoronoiParabola *)parabolaIntersectingSiteEvent:(VoronoiSiteEvent *)siteEvent
{
	VoronoiParabola *parabola = [self rootParabola];
	
	CGFloat x = 0.0;
	
	while(![parabola isLeafNode])
	{
		x = [self xOfParabola:parabola intersectingSiteEvent:siteEvent];
		
		if(x > siteEvent.position.x)
		{
			parabola = [parabola leftParabola];
		}
		else
		{
			parabola = [parabola rightParabola];
		}
	}
	
	return parabola;
}

- (CGFloat)xOfParabola:(VoronoiParabola *)parabola intersectingSiteEvent:(VoronoiSiteEvent *)siteEvent
{
	return 0.0;
}

- (CGFloat)yOfSiteEvent:(VoronoiSiteEvent *)siteEvent intersectingWithEvent:(VoronoiEvent *)event
{
	return 0.0;
}

- (void)checkAndCreateCircleEventWithEvent:(VoronoiEvent *)event andParabola:(VoronoiParabola *)parabola
{
	
}

- (NSPoint)pointIntersectingEdge:(VoronoiEdge *)edge andEdge:(VoronoiEdge *)other
{
	return NSZeroPoint;
}

#pragma mark - NSObject

- (id)init
{
	self = [super init];
	
	if(self)
	{
		[self setNumberOfIterations:1];
		
		[self setSiteEvents:[NSMutableArray array]];
		
		[self setEventQueue:[NSMutableArray array]];
		
		[self setCells:[NSMutableArray array]];
		
		[self setEdges:[NSMutableArray array]];
	}
	
	return self;
}

@end