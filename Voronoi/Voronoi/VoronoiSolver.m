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
	[[self edges] enumerateObjectsUsingBlock:^(VoronoiEdge *edge, NSUInteger idx, BOOL *stop)
	{
		VoronoiCell *leftCell = [self findOrCreateCellAtPosition:[[edge leftSiteEvent] position]];
		VoronoiCell *rightCell = [self findOrCreateCellAtPosition:[[edge rightSiteEvent] position]];
		
		[leftCell addEdge:edge];
		[rightCell addEdge:edge];
	
	}];
}

- (void)processEvents
{
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
	[[rightParentParabola edge] setEnd:point];
	
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
	CGFloat x = parabola.edge.start.x;
	
	CGFloat maxX = (self.bounds.origin.x + self.bounds.size.width);
	
	if(parabola.edge.direction.x > 0.0)
	{
		x = MAX(x, maxX);
	}
	else
	{
		x = MIN(x, self.bounds.origin.x);
	}
	
	[[parabola edge] setEnd:NSMakePoint(x, (parabola.edge.f * x + parabola.edge.g))];
	
	if([parabola leftParabola] && ![[parabola leftParabola] isLeafNode])
	{
		[self finishEdge:[parabola leftParabola]];
	}
	
	if([parabola rightParabola] && ![[parabola rightParabola] isLeafNode])
	{
		[self finishEdge:[parabola rightParabola]];
	}
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
	VoronoiParabola *leftChildParabola = [parabola leftChildParabola];
	VoronoiParabola *rightChildParabola = [parabola rightChildParabola];
	
	NSPoint leftPoint = [[leftChildParabola siteEvent] position];
	NSPoint rightPoint = [[rightChildParabola siteEvent] position];
	
	CGFloat dotProduct = (2.0 * (leftPoint.y - siteEvent.position.y));
	CGFloat a1 = (1.0 / dotProduct);
	CGFloat b1 = (-2.0 * (leftPoint.x / dotProduct));
	CGFloat c1 = (siteEvent.position.y + dotProduct / 4.0 + leftPoint.x * leftPoint.x / dotProduct);
	
	dotProduct = (2.0 * (rightPoint.y - siteEvent.position.y));
	CGFloat a2 = (1.0 / dotProduct);
	CGFloat b2 = (-2.0 * (rightPoint.x / dotProduct));
	CGFloat c2 = (siteEvent.position.y + dotProduct / 4.0 + rightPoint.x * rightPoint.x / dotProduct);
	
	CGFloat a = (a1 - a2);
	CGFloat b = (b1 - b2);
	CGFloat c = (c1 - c2);
	
	CGFloat discriminant = (b * b - 4.0 * a * c);
	
	CGFloat x1 = (-b + sqrtf(discriminant)) / (2.0 * a);
	CGFloat x2 = (-b - sqrtf(discriminant)) / (2.0 * a);
	
	return ((leftPoint.y < rightPoint.y) ? MAX(x1, x2) : MIN(x1, x2));
}

- (CGFloat)yOfSiteEvent:(VoronoiSiteEvent *)siteEvent intersectingWithEvent:(VoronoiEvent *)event
{
	CGFloat dotProduct = (2.0 * (siteEvent.position.y - event.position.y));
	
	CGFloat b1 = (-2.0 * siteEvent.position.x / dotProduct);
	CGFloat c1 = (event.position.y + dotProduct / 4.0 + siteEvent.position.x * siteEvent.position.x / dotProduct);
	
	return (event.position.x * event.position.x / dotProduct + b1 * event.position.x + c1);
}

- (void)checkAndCreateCircleEventWithEvent:(VoronoiEvent *)event andParabola:(VoronoiParabola *)parabola
{
	VoronoiParabola *leftParentParabola = [parabola leftParentParabola];
	VoronoiParabola *rightParentParabola = [parabola rightParentParabola];
	
	VoronoiParabola *leftChildParabola = (!leftParentParabola ? nil : [leftParentParabola leftChildParabola]);
	VoronoiParabola *rightChildParabola = (!rightParentParabola ? nil : [rightParentParabola rightChildParabola]);
	
	if(!leftChildParabola || !rightChildParabola || ([[leftChildParabola siteEvent] isEqualTo:[rightChildParabola siteEvent]]))
	{
		return;
	}
	
	NSPoint point = [self pointIntersectingEdge:[leftParentParabola edge] andEdge:[rightParentParabola edge]];
	
	if(NSEqualPoints(NSZeroPoint, point))
	{
		return;
	}
	
	CGFloat x = (point.x - leftChildParabola.siteEvent.position.x);
	CGFloat y = (point.y - leftChildParabola.siteEvent.position.y);
	
	CGFloat distance = sqrtf((x * x) + (y * y));
	
	if((point.y - distance) >= event.position.y)
	{
		return;
	}
	
	VoronoiCircleEvent *circleEvent = [[VoronoiCircleEvent alloc] initWithPosition:NSMakePoint(point.x, (point.y - distance))];
	
	[circleEvent setParabola:parabola];
	
	[parabola setCircleEvent:circleEvent];
	
	[[self eventQueue] addObject:circleEvent];
}

- (NSPoint)pointIntersectingEdge:(VoronoiEdge *)edge andEdge:(VoronoiEdge *)other
{
	CGFloat x = ((other.g - edge.g) / (edge.f - other.f));
	CGFloat y = (edge.f * x + edge.g);
	
	if(edge.direction.x == 0.0 || other.direction.x == 0.0)
	{
		return NSZeroPoint;
	}
	
	if(edge.direction.y == 0.0 || other.direction.y == 0.0)
	{
		return NSZeroPoint;
	}
	
	if(((x - edge.start.x) / edge.direction.x) < 0.0)
	{
		return NSZeroPoint;
	}
	
	if(((x - other.start.x) / other.direction.x) < 0.0)
	{
		return NSZeroPoint;
	}
	
	if(((y - edge.start.y) / edge.direction.y) > 0.0)
	{
		return NSZeroPoint;
	}
	
	if(((y - other.start.y) / other.direction.y) > 0.0)
	{
		return NSZeroPoint;
	}
	
	if(fabs(edge.direction.x) < 0.01 && fabs(other.direction.x) < 0.01)
	{
		return NSZeroPoint;
	}
	
	return NSMakePoint(x, y);
}

- (VoronoiCell *)findOrCreateCellAtPosition:(NSPoint)position
{
	VoronoiCell *result = nil;
	
	for(VoronoiCell *cell in [self cells])
	{
		if(NSEqualPoints([cell position], position))
		{
			return cell;
		}
	}
	
	result = [[VoronoiCell alloc] initWithPosition:position];
	
	[[self cells] addObject:result];
	
	return result;
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