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
@property (nonatomic) NSMutableArray *siteEventQueue;
@property (nonatomic) NSMutableArray *circleEventQueue;
@property (nonatomic) NSMutableArray *cells;
@property (nonatomic) NSMutableArray *edges;
@property (nonatomic) VoronoiParabola *rootParabola;

@end

@implementation VoronoiSolver

#pragma mark - VoronoiSolver

#pragma mark - Setup

- (void)reset
{
	[[self siteEventQueue] removeAllObjects];
	
	[[self circleEventQueue] removeAllObjects];
	
	[[self cells] removeAllObjects];
	
	[[self edges] removeAllObjects];
	
	[self setRootParabola:nil];
	
	[self setBounds:NSZeroRect];
}

- (void)setSiteEvents:(NSArray *)siteEvents
{
	[[self siteEventQueue] removeAllObjects];
	
	[[self siteEventQueue] addObjectsFromArray:siteEvents];
	
	[[self siteEventQueue] sortUsingComparator:^NSComparisonResult(VoronoiSiteEvent *siteEvent, VoronoiSiteEvent *other)
	{
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
}

- (void)addCircleEvent:(VoronoiCircleEvent *)circleEvent
{
	[[self circleEventQueue] addObject:circleEvent];
	
	[[self circleEventQueue] sortedArrayUsingComparator:^NSComparisonResult(VoronoiCircleEvent *circleEvent, VoronoiCircleEvent *other)
	{
		if(CGPointEqualToPoint([circleEvent position], [other position]))
		{
			return NSOrderedSame;
		}
		
		if(circleEvent.position.y < other.position.y)
		{
			return NSOrderedAscending;
		}
		
		return NSOrderedDescending;
	
	}];
}

#pragma mark - Solve

- (NSArray *)solveSiteEvents:(NSArray *)siteEvents numberOfIterations:(NSInteger)numberOfIterations bounds:(NSRect)bounds
{
	[self reset];
	
	[self setSiteEvents:siteEvents];
	
	[self setBounds:bounds];
	
	numberOfIterations = (numberOfIterations > 0 ? numberOfIterations : 1);
	
	for(NSInteger iteration = 0; iteration < numberOfIterations; ++iteration)
	{
		[self processEvents];
		
		[self processEdges];
		
		if((iteration + 1) < numberOfIterations)
		{
			[self relaxCells];
			
			NSMutableArray *newSiteEvents = [NSMutableArray array];
			
			[[self cells] enumerateObjectsUsingBlock:^(VoronoiCell *cell, NSUInteger idx, BOOL *stop)
			{
				VoronoiSiteEvent *siteEvent = [[VoronoiSiteEvent alloc] initWithPosition:[cell position]];
				
				[newSiteEvents addObject:siteEvent];
			
			}];
			
			[self reset];
			
			[self setSiteEvents:newSiteEvents];
			
			[self setBounds:bounds];
		}
	}
	
	return [NSArray arrayWithArray:[self cells]];
}

- (void)processEvents
{
	while([[self siteEventQueue] lastObject] || [[self circleEventQueue] lastObject])
	{
		VoronoiCircleEvent *circleEvent = [[self circleEventQueue] lastObject];
		
		VoronoiSiteEvent *siteEvent = [[self siteEventQueue] lastObject];
		
		if(circleEvent && siteEvent)
		{
			if(circleEvent.position.y < siteEvent.position.y)
			{
				siteEvent = nil;
			}
			else
			{
				circleEvent = nil;
			}
		}
		
		if(circleEvent)
		{
			[[self circleEventQueue] removeLastObject];
			
			[self processCircleEvent:circleEvent];
		}
		else if(siteEvent)
		{
			[[self siteEventQueue] removeLastObject];
			
			[self processSiteEvent:siteEvent];
		}
	}
	
	[self finishEdges];
}

#pragma mark - Events

- (void)processSiteEvent:(VoronoiSiteEvent *)siteEvent
{
	NSLog(@"processing site event %@", NSStringFromPoint(siteEvent.position));
	
	if(![self rootParabola])
	{
		[self setRootParabola:[[VoronoiParabola alloc] initWithSiteEvent:siteEvent]];
		
		return;
	}
	
	if([[self rootParabola] isLeafNode] && fabs(self.rootParabola.siteEvent.position.y - siteEvent.position.y) < 1.0)
	{
		VoronoiParabola *leftParabola = [[VoronoiParabola alloc] initWithSiteEvent:[[self rootParabola] siteEvent]];
		VoronoiParabola *rightParabola = [[VoronoiParabola alloc] initWithSiteEvent:siteEvent];
		
		[[self rootParabola] setLeftParabola:leftParabola];
		[[self rootParabola] setRightParabola:rightParabola];
		
		return;
	}
	
	
}

- (void)processCircleEvent:(VoronoiCircleEvent *)circleEvent
{
	NSLog(@"processing site event %@", NSStringFromPoint(circleEvent.position));
	
	VoronoiParabola *parabola = [circleEvent parabola];
}

#pragma mark - Edges

- (void)processEdges
{
	
}

- (void)finishEdges
{
	
}

#pragma mark - Cells

- (void)relaxCells
{
	
}

#pragma mark - NSObject

- (id)init
{
	self = [super init];
	
	if(self)
	{
		[self setSiteEventQueue:[NSMutableArray array]];
		
		[self setCircleEventQueue:[NSMutableArray array]];
		
		[self setCells:[NSMutableArray array]];
		
		[self setEdges:[NSMutableArray array]];
	}
	
	return self;
}

@end