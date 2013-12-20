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

#import "VoronoiSiteEvent.h"

@interface VoronoiParabola ()

@property (nonatomic, retain, readwrite) VoronoiParabola *parentParabola;
@property (nonatomic, retain, readwrite) VoronoiParabola *leftParabola;
@property (nonatomic, retain, readwrite) VoronoiParabola *rightParabola;
@property (nonatomic, retain, readwrite) VoronoiSiteEvent *siteEvent;

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
		parabola = [parabola rightParabola];
	}
	
	return parabola;
}

- (VoronoiParabola *)rightChildParabola
{
	VoronoiParabola *parabola = [self rightParabola];
	
	while(![parabola isLeafNode])
	{
		parabola = [parabola leftParabola];
	}
	
	return parabola;
}

- (VoronoiParabola *)childParabolaIntersectingSiteEvent:(VoronoiSiteEvent *)siteEvent
{
	VoronoiParabola *parabola = self;
	
	while(![parabola isLeafNode])
	{
		if(parabola.siteEvent.position.x > siteEvent.position.x)
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

#pragma mark - NSObject

- (id)initWithSiteEvent:(VoronoiSiteEvent *)siteEvent
{
	self = [super init];
	
	if(self)
	{
		[self setSiteEvent:siteEvent];
	}
	
	return self;
}

- (BOOL)isLeafNode
{
	return (![self leftParabola] && ![self rightParabola]);
}

@end