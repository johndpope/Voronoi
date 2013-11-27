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

@property (nonatomic) NSRect bounds;
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
		
		if(siteEvent.position.y > other.position.y)
		{
			return NSOrderedAscending;
		}
		
		return NSOrderedDescending;
	
	}];
	
	[self setBounds:NSMakeRect(x, y, width, height)];
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