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

- (NSArray *)solveSiteEvents:(NSArray *)siteEvents numberOfIterations:(NSInteger)numberOfIterations bounds:(NSRect)bounds;

@end