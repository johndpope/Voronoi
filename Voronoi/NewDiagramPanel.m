//
//*******
//
//	filename: NewDiagramPanel.m
//	author: Zack Brown
//	date: 06/11/2013
//
//*******
//

#import "NewDiagramPanel.h"

CGFloat const NewDiagramPanelPadding = 10.0;

@interface NewDiagramPanel ()

@property (nonatomic) NSButton *cancelButton;
@property (nonatomic) NSButton *confirmButton;
@property (nonatomic) NSPopUpButton *diagramTypePopUpButton;
@property (nonatomic) NSTextField *xMarginTextField;
@property (nonatomic) NSTextField *yMarginTextField;
@property (nonatomic) NSTextField *numberOfSitesTextField;
@property (nonatomic) NSTextField *numberOfIterationsTextField;

@end

@implementation NewDiagramPanel

#pragma mark - NewDiagramPanel

- (void)cancelButtonEventHandler:(id)sender
{
	[[self sheetParent] endSheet:self returnCode:NSModalResponseCancel];
}

- (void)confirmButtonEventHandler:(id)sender
{
	[[self sheetParent] endSheet:self returnCode:NSModalResponseOK];
}

#pragma mark - NSPanel

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
	
	if(self)
	{
		[self setPreventsApplicationTerminationWhenModal:NO];
		
		[self setCancelButton:[[NSButton alloc] init]];
		
		[self setConfirmButton:[[NSButton alloc] init]];
		
		[self setDiagramTypePopUpButton:[[NSPopUpButton alloc] init]];
		
		[self setXMarginTextField:[[NSTextField alloc] init]];
		
		[self setYMarginTextField:[[NSTextField alloc] init]];
		
		[self setNumberOfSitesTextField:[[NSTextField alloc] init]];
		
		[self setNumberOfIterationsTextField:[[NSTextField alloc] init]];
		
		NSView *contentView = (NSView *)[self contentView];
		
		[[self confirmButton] setBezelStyle:NSRoundedBezelStyle];
		[[self confirmButton] setTitle:@"Confirm"];
		[[self confirmButton] sizeToFit];
		[[self confirmButton] setTarget:self];
		[[self confirmButton] setAction:@selector(confirmButtonEventHandler:)];
		[[self confirmButton] setFrameSize:NSMakeSize((self.confirmButton.frame.size.width + (NewDiagramPanelPadding * 2.0)), self.confirmButton.frame.size.height)];
		[[self confirmButton] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.confirmButton.frame.size.width + NewDiagramPanelPadding)), NewDiagramPanelPadding)];
		
		[[self cancelButton] setBezelStyle:NSRoundedBezelStyle];
		[[self cancelButton] setTitle:@"Cancel"];
		[[self cancelButton] sizeToFit];
		[[self cancelButton] setTarget:self];
		[[self cancelButton] setAction:@selector(cancelButtonEventHandler:)];
		[[self cancelButton] setFrameSize:NSMakeSize((self.cancelButton.frame.size.width + (NewDiagramPanelPadding * 2.0)), self.cancelButton.frame.size.height)];
		[[self cancelButton] setFrameOrigin:NSMakePoint((self.confirmButton.frame.origin.x - self.cancelButton.frame.size.width), NewDiagramPanelPadding)];
		
		[[self diagramTypePopUpButton] addItemWithTitle:@"Grid"];
		[[self diagramTypePopUpButton] addItemWithTitle:@"Random"];
		[[self diagramTypePopUpButton] addItemWithTitle:@"Spiral"];
		[[self diagramTypePopUpButton] selectItemWithTitle:@"Random"];
		
		[[self diagramTypePopUpButton] sizeToFit];
		[[self diagramTypePopUpButton] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.diagramTypePopUpButton.frame.size.height)];
		[[self diagramTypePopUpButton] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.diagramTypePopUpButton.frame.size.width + NewDiagramPanelPadding)), (contentView.frame.size.height - (NewDiagramPanelPadding * 4.0)))];
		
		[[self xMarginTextField] sizeToFit];
		[[self xMarginTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.xMarginTextField.frame.size.height)];
		[[self xMarginTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.xMarginTextField.frame.size.width + NewDiagramPanelPadding)), ((self.diagramTypePopUpButton.frame.origin.y - self.diagramTypePopUpButton.frame.size.height) - NewDiagramPanelPadding))];
		
		[[self yMarginTextField] sizeToFit];
		[[self yMarginTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.yMarginTextField.frame.size.height)];
		[[self yMarginTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.yMarginTextField.frame.size.width + NewDiagramPanelPadding)), ((self.xMarginTextField.frame.origin.y - self.xMarginTextField.frame.size.height) - NewDiagramPanelPadding))];
		
		[[self numberOfSitesTextField] sizeToFit];
		[[self numberOfSitesTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.numberOfSitesTextField.frame.size.height)];
		[[self numberOfSitesTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.numberOfSitesTextField.frame.size.width + NewDiagramPanelPadding)), ((self.yMarginTextField.frame.origin.y - self.yMarginTextField.frame.size.height) - NewDiagramPanelPadding))];
		
		[[self numberOfIterationsTextField] sizeToFit];
		[[self numberOfIterationsTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.numberOfIterationsTextField.frame.size.height)];
		[[self numberOfIterationsTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.numberOfIterationsTextField.frame.size.width + NewDiagramPanelPadding)), ((self.numberOfSitesTextField.frame.origin.y - self.numberOfSitesTextField.frame.size.height) - NewDiagramPanelPadding))];
		
		[[self contentView] addSubview:[self cancelButton]];
		[[self contentView] addSubview:[self confirmButton]];
		[[self contentView] addSubview:[self diagramTypePopUpButton]];
		[[self contentView] addSubview:[self xMarginTextField]];
		[[self contentView] addSubview:[self yMarginTextField]];
		[[self contentView] addSubview:[self numberOfSitesTextField]];
		[[self contentView] addSubview:[self numberOfIterationsTextField]];
	}
	
	return self;
}

@end