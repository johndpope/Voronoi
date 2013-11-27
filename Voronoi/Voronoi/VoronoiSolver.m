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
#import "VoronoiSiteEvent.h"

@interface VoronoiSolver ()

@property (nonatomic) NSMutableArray *siteEvents;

@end

@implementation VoronoiSolver

#pragma mark - VoronoiSolver

- (void)reset
{
	[self setNumberOfIterations:1];
	
	[[self siteEvents] removeAllObjects];
}

- (void)addSiteEvents:(NSArray *)siteEvents
{
	[[self siteEvents] addObjectsFromArray:[siteEvents sortedArrayUsingComparator:^NSComparisonResult(VoronoiSiteEvent *siteEvent, VoronoiSiteEvent *other)
	{
		if(CGPointEqualToPoint([siteEvent position], [other position]))
		{
			return NSOrderedSame;
		}
		
		if(siteEvent.position.y > other.position.y)
		{
			return NSOrderedAscending;
		}
		
		return NSOrderedDescending;
	
	}]];
}

- (void)setNumberOfIterations:(NSUInteger)numberOfIterations
{
	_numberOfIterations = (numberOfIterations > 0 ? numberOfIterations : 1);
}

#pragma mark - NSObject

- (id)init
{
	self = [super init];
	
	if(self)
	{
		[self setNumberOfIterations:1];
		
		[self setSiteEvents:[NSMutableArray array]];
	}
	
	return self;
}

@end