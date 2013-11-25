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

- (void)createDiagramPanel:(CreateDiagramPanel *)panel didConfirmDiagramType:(DiagramType)diagramType withXMargin:(NSInteger)xMargin yMargin:(NSInteger)yMargin numberOfSites:(NSInteger)numberOfSites numberOfIterations:(NSInteger)numberOfIterations spiralChord:(CGFloat)spiralChord;
- (void)createDiagramPanelDidCancel:(CreateDiagramPanel *)panel;

@end

@interface CreateDiagramPanel : NSPanel

@property (nonatomic, assign) id <CreateDiagramPanelDelegate> diagramDelegate;

@end