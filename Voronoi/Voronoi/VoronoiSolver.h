//
//*******
//
//	filename: VoronoiSolver.h
//	author: Zack Brown
//	date: 27/11/2013
//
//*******
//

#import <Foundation/Foundation.h>

@interface VoronoiSolver : NSObject

@property (nonatomic) NSUInteger numberOfIterations;

- (void)reset;
- (void)addSiteEvents:(NSArray *)siteEvents;
- (NSArray *)solve;

@end