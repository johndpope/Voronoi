//
//*******
//
//	filename: CreateDiagramPanel.h
//	author: Zack Brown
//	date: 06/11/2013
//
//*******
//

#import <Cocoa/Cocoa.h>

@class CreateDiagramPanel;

typedef NS_ENUM(NSInteger, DiagramType)
{
	DiagramTypeGrid = 0,
	DiagramTypeRandom,
	DiagramTypeSpiral,
};

@protocol CreateDiagramPanelDelegate <NSObject>

- (void)createDiagramPanelDidConfirmWithGridDiagramType:(CreateDiagramPanel *)panel xMargin:(NSUInteger)xMargin yMargin:(NSUInteger)yMargin numberOfIterations:(NSUInteger)numberOfIterations columns:(NSUInteger)columns rows:(NSUInteger)rows;
- (void)createDiagramPanelDidConfirmWithRandomDiagramType:(CreateDiagramPanel *)panel xMargin:(NSUInteger)xMargin yMargin:(NSUInteger)yMargin numberOfIterations:(NSUInteger)numberOfIterations numberOfSites:(NSUInteger)numberOfSites seed:(NSUInteger)seed;
- (void)createDiagramPanelDidConfirmWithSpiralDiagramType:(CreateDiagramPanel *)panel xMargin:(NSUInteger)xMargin yMargin:(NSUInteger)yMargin numberOfIterations:(NSUInteger)numberOfIterations spiralChord:(CGFloat)spiralChord;
- (void)createDiagramPanelDidCancel:(CreateDiagramPanel *)panel;

@end

@interface CreateDiagramPanel : NSPanel

@property (nonatomic, assign) id <CreateDiagramPanelDelegate> diagramDelegate;

@end