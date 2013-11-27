//
//*******
//
//	filename: VoronoiParabola.m
//	author: Zack Brown
//	date: 27/11/2013
//
//*******
//

#import "VoronoiParabola.h"

@interface VoronoiParabola ()

@property (nonatomic, readwrite) VoronoiSiteEvent *siteEvent;
@property (nonatomic, readwrite) VoronoiParabola *parentParabola;

@end

@implementation VoronoiParabola

#pragma mark - VoronoiParabola

- (void)setLeftParabola:(VoronoiParabola *)leftParabola
{
	[leftParabola setParentParabola:self];
	
	_leftParabola = leftParabola;
}

- (void)setRightParabola:(VoronoiParabola *)rightParabola
{
	[rightParabola setParentParabola:self];
	
	_rightParabola = rightParabola;
}

- (VoronoiParabola *)leftParentParabola
{
	VoronoiParabola *parabola = [self parentParabola];
	
	VoronoiParabola *lastParabola = self;
	
	while([[parabola leftParabola] isEqualTo:lastParabola])
	{
		if(![parabola parentParabola])
		{
			return nil;
		}
		
		lastParabola = parabola;
		
		parabola = [parabola parentParabola];
	}
	
	return parabola;
}

- (VoronoiParabola *)rightParentParabola
{
	VoronoiParabola *parabola = [self parentParabola];
	
	VoronoiParabola *lastParabola = self;
	
	while([[parabola rightParabola] isEqualTo:lastParabola])
	{
		if(![parabola parentParabola])
		{
			return nil;
		}
		
		lastParabola = parabola;
		
		parabola = [parabola parentParabola];
	}
	
	return parabola;
}

- (VoronoiParabola *)leftChildParabola
{
	VoronoiParabola *parabola = [self leftParabola];
	
	while(![parabola isLeafNode])
	{
		if(![parabola rightParabola])
		{
			return nil;
		}
		
		parabola = [parabola rightParabola];
	}
	
	return parabola;
}

- (VoronoiParabola *)rightChildParabola
{
	VoronoiParabola *parabola = [self rightParabola];
	
	while(![parabola isLeafNode])
	{
		if(![parabola leftParabola])
		{
			return nil;
		}
		
		parabola = [parabola leftParabola];
	}
	
	return parabola;
}

#pragma mark - NSObject

- (id)initWithSiteEvent:(VoronoiSiteEvent *)siteEvent
{
	self = [super init];
	
	if(self)
	{
		[self setSiteEvent:siteEvent];
		
		[self setIsLeafNode:([self siteEvent] ? YES : NO)];
	}
	
	return self;
}

@end