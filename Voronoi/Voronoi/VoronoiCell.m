//
//*******
//
//	filename: VoronoiCell.m
//	author: Zack Brown
//	date: 27/11/2013
//
//*******
//

#import "VoronoiCell.h"
#import "VoronoiCorner.h"
#import "VoronoiEdge.h"

@interface VoronoiCell ()

@property (nonatomic) NSMutableArray *uniqueEdges;
@property (nonatomic) NSMutableArray *uniqueCorners;
@property (nonatomic) NSMutableArray *uniqueNeighbours;

@end

@implementation VoronoiCell

#pragma mark - VoronoiCell

- (void)addEdge:(VoronoiEdge *)edge
{
	if(![[self uniqueEdges] containsObject:edge])
	{
		[[self uniqueEdges] addObject:edge];
		
		[self createCorners];
	}
}

- (void)addNeighbour:(VoronoiCell *)neighbour;
{
	if(![[self uniqueNeighbours] containsObject:neighbour])
	{
		[[self uniqueNeighbours] addObject:neighbour];
	}
}

- (void)addCorner:(VoronoiCorner *)corner
{
	if(![[self uniqueCorners] containsObject:corner])
	{
		[[self uniqueCorners] addObject:corner];
	}
}

- (NSArray *)edges
{
	return [NSArray arrayWithArray:[self uniqueEdges]];
}

- (NSArray *)corners
{
	return [NSArray arrayWithArray:[self uniqueCorners]];
}

- (NSArray *)neighbours
{
	return [NSArray arrayWithArray:[self uniqueNeighbours]];
}

- (void)createCorners
{
	if([[self uniqueEdges] count] > 1)
	{
		[[self uniqueEdges] enumerateObjectsUsingBlock:^(VoronoiEdge *edge, NSUInteger idx, BOOL *stop)
		{
			VoronoiEdge *other = [self findIntersectingEdgeForEdge:edge];
			
			if(other)
			{
				VoronoiCorner *corner = [self findCornerWithLeftEdge:edge rightEdge:other];
				
				if(corner)
				{
					[self addCorner:corner];
				}
			}
		
		}];
	}
}

- (VoronoiEdge *)findIntersectingEdgeForEdge:(VoronoiEdge *)edge
{
	__block VoronoiEdge *result = nil;
	
	[[self uniqueEdges] enumerateObjectsUsingBlock:^(VoronoiEdge *other, NSUInteger idx, BOOL *stop)
	{
		if(![edge isEqualTo:other])
		{
			if(NSEqualPoints([edge start], [other start]) || NSEqualPoints([edge start], [other end]) || NSEqualPoints([edge end] , [other start]) || NSEqualPoints([edge end], [other end]))
			{
				result = other;
			}
		}
		
		*stop = (result != nil);
	
	}];
	
	return result;
}

- (VoronoiCorner *)findCornerWithLeftEdge:(VoronoiEdge *)leftEdge rightEdge:(VoronoiEdge *)rightEdge
{
	__block VoronoiCorner *result = nil;
	
	[[self uniqueCorners] enumerateObjectsUsingBlock:^(VoronoiCorner *corner, NSUInteger idx, BOOL *stop)
	{
		if(([[corner leftEdge] isEqualTo:leftEdge] || [[corner leftEdge] isEqualTo:rightEdge]) && ([[corner rightEdge] isEqualTo:leftEdge] || [[corner rightEdge] isEqualTo:rightEdge]))
		{
			result = corner;
		}
		
		*stop = (result != nil);
		
	}];
	
	return result;
}

#pragma mark - NSObject

- (id)initWithPosition:(CGPoint)position
{
	self = [super init];
	
	if(self)
	{
		[self setPosition:position];
		
		[self setUniqueEdges:[NSMutableArray array]];
		
		[self setUniqueCorners:[NSMutableArray array]];
		
		[self setUniqueNeighbours:[NSMutableArray array]];
	}
	
	return self;
}

@end