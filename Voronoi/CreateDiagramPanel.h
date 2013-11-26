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

- (void)createDiagramPanelDidConfirmWithGridDiagramType:(CreateDiagramPanel *)panel xMargin:(NSInteger)xMargin yMargin:(NSInteger)yMargin numberOfIterations:(NSInteger)numberOfIterations columns:(NSInteger)columns rows:(NSInteger)rows;
- (void)createDiagramPanelDidConfirmWithRandomDiagramType:(CreateDiagramPanel *)panel xMargin:(NSInteger)xMargin yMargin:(NSInteger)yMargin numberOfIterations:(NSInteger)numberOfIterations numberOfSites:(NSInteger)numberOfSites seed:(NSInteger)seed;
- (void)createDiagramPanelDidConfirmWithSpiralDiagramType:(CreateDiagramPanel *)panel xMargin:(NSInteger)xMargin yMargin:(NSInteger)yMargin numberOfIterations:(NSInteger)numberOfIterations spiralChord:(CGFloat)spiralChord;
- (void)createDiagramPanelDidCancel:(CreateDiagramPanel *)panel;

@end

@interface CreateDiagramPanel : NSPanel

@property (nonatomic, assign) id <CreateDiagramPanelDelegate> diagramDelegate;

@end