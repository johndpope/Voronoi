//
//*******
//
//	filename: CreateDiagramPanelController.m
//	author: Zack Brown
//	date: 06/11/2013
//
//*******
//

#import "CreateDiagramPanelController.h"

CGFloat const CreateDiagramPanelControllerPadding = 10.0;

@interface CreateDiagramPanelController ()

@property (nonatomic) NSButton *cancelButton;
@property (nonatomic) NSButton *confirmButton;
@property (nonatomic) NSPopUpButton *diagramTypePopUpButton;
@property (nonatomic) NSTextField *xMarginTextField;
@property (nonatomic) NSTextField *yMarginTextField;
@property (nonatomic) NSTextField *numberOfSitesTextField;
@property (nonatomic) NSTextField *numberOfIterationsTextField;
@property (nonatomic) NSTextField *spiralChordTextField;
@property (nonatomic) NSTextField *diagramTypeLabel;
@property (nonatomic) NSTextField *xMarginLabel;
@property (nonatomic) NSTextField *yMarginLabel;
@property (nonatomic) NSTextField *numberOfSitesLabel;
@property (nonatomic) NSTextField *numberOfIterationsLabel;
@property (nonatomic) NSTextField *spiralChordLabel;
@property (nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation CreateDiagramPanelController

#pragma mark - CreateDiagramPanelController

- (void)cancelButtonEventHandler:(id)sender
{
	[[[self window] sheetParent] endSheet:[self window] returnCode:NSModalResponseCancel];
}

- (void)confirmButtonEventHandler:(id)sender
{
	[[[self window] sheetParent] endSheet:[self window] returnCode:NSModalResponseOK];
}

#pragma mark - NSPanel

- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	
	if(self)
	{
		[[self window] setPreventsApplicationTerminationWhenModal:NO];
		
		[self setCancelButton:[[NSButton alloc] init]];
		
		[self setConfirmButton:[[NSButton alloc] init]];
		
		[self setDiagramTypePopUpButton:[[NSPopUpButton alloc] init]];
		
		[self setXMarginTextField:[[NSTextField alloc] init]];
		[self setYMarginTextField:[[NSTextField alloc] init]];
		[self setNumberOfSitesTextField:[[NSTextField alloc] init]];
		[self setNumberOfIterationsTextField:[[NSTextField alloc] init]];
		[self setSpiralChordTextField:[[NSTextField alloc] init]];
		
		[self setDiagramTypeLabel:[[NSTextField alloc] init]];
		[self setXMarginLabel:[[NSTextField alloc] init]];
		[self setYMarginLabel:[[NSTextField alloc] init]];
		[self setNumberOfSitesLabel:[[NSTextField alloc] init]];
		[self setNumberOfIterationsLabel:[[NSTextField alloc] init]];
		[self setSpiralChordLabel:[[NSTextField alloc] init]];
		
		[self setNumberFormatter:[[NSNumberFormatter alloc] init]];
		
		[[self numberFormatter] setNumberStyle:NSNumberFormatterDecimalStyle];
		
		NSView *contentView = (NSView *)[[self window] contentView];
		
		[[self confirmButton] setBezelStyle:NSRoundedBezelStyle];
		[[self confirmButton] setTitle:@"Confirm"];
		[[self confirmButton] sizeToFit];
		[[self confirmButton] setTarget:self];
		[[self confirmButton] setAction:@selector(confirmButtonEventHandler:)];
		[[self confirmButton] setFrameSize:NSMakeSize((self.confirmButton.frame.size.width + (CreateDiagramPanelControllerPadding * 2.0)), self.confirmButton.frame.size.height)];
		[[self confirmButton] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.confirmButton.frame.size.width + CreateDiagramPanelControllerPadding)), CreateDiagramPanelControllerPadding)];
		
		[[self cancelButton] setBezelStyle:NSRoundedBezelStyle];
		[[self cancelButton] setTitle:@"Cancel"];
		[[self cancelButton] sizeToFit];
		[[self cancelButton] setTarget:self];
		[[self cancelButton] setAction:@selector(cancelButtonEventHandler:)];
		[[self cancelButton] setFrameSize:NSMakeSize((self.cancelButton.frame.size.width + (CreateDiagramPanelControllerPadding * 2.0)), self.cancelButton.frame.size.height)];
		[[self cancelButton] setFrameOrigin:NSMakePoint((self.confirmButton.frame.origin.x - self.cancelButton.frame.size.width), CreateDiagramPanelControllerPadding)];
		
		[[self diagramTypePopUpButton] addItemWithTitle:@"Grid"];
		[[self diagramTypePopUpButton] addItemWithTitle:@"Random"];
		[[self diagramTypePopUpButton] addItemWithTitle:@"Spiral"];
		[[self diagramTypePopUpButton] selectItemWithTitle:@"Random"];
		
		[[self diagramTypePopUpButton] sizeToFit];
		[[self diagramTypePopUpButton] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.diagramTypePopUpButton.frame.size.height)];
		[[self diagramTypePopUpButton] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.diagramTypePopUpButton.frame.size.width + CreateDiagramPanelControllerPadding)), (contentView.frame.size.height - (CreateDiagramPanelControllerPadding * 4.0)))];
		
		[[self xMarginTextField] setFormatter:[self numberFormatter]];
		[[self xMarginTextField] sizeToFit];
		[[self xMarginTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.xMarginTextField.frame.size.height)];
		[[self xMarginTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.xMarginTextField.frame.size.width + CreateDiagramPanelControllerPadding)), ((self.diagramTypePopUpButton.frame.origin.y - self.diagramTypePopUpButton.frame.size.height) - CreateDiagramPanelControllerPadding))];
		
		[[self yMarginTextField] setFormatter:[self numberFormatter]];
		[[self yMarginTextField] sizeToFit];
		[[self yMarginTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.yMarginTextField.frame.size.height)];
		[[self yMarginTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.yMarginTextField.frame.size.width + CreateDiagramPanelControllerPadding)), ((self.xMarginTextField.frame.origin.y - self.xMarginTextField.frame.size.height) - CreateDiagramPanelControllerPadding))];
		
		[[self numberOfSitesTextField] setFormatter:[self numberFormatter]];
		[[self numberOfSitesTextField] sizeToFit];
		[[self numberOfSitesTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.numberOfSitesTextField.frame.size.height)];
		[[self numberOfSitesTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.numberOfSitesTextField.frame.size.width + CreateDiagramPanelControllerPadding)), ((self.yMarginTextField.frame.origin.y - self.yMarginTextField.frame.size.height) - CreateDiagramPanelControllerPadding))];
		
		[[self numberOfIterationsTextField] setFormatter:[self numberFormatter]];
		[[self numberOfIterationsTextField] sizeToFit];
		[[self numberOfIterationsTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.numberOfIterationsTextField.frame.size.height)];
		[[self numberOfIterationsTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.numberOfIterationsTextField.frame.size.width + CreateDiagramPanelControllerPadding)), ((self.numberOfSitesTextField.frame.origin.y - self.numberOfSitesTextField.frame.size.height) - CreateDiagramPanelControllerPadding))];
		
		[[self spiralChordTextField] setFormatter:[self numberFormatter]];
		[[self spiralChordTextField] sizeToFit];
		[[self spiralChordTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.spiralChordTextField.frame.size.height)];
		[[self spiralChordTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.spiralChordTextField.frame.size.width + CreateDiagramPanelControllerPadding)), ((self.numberOfIterationsTextField.frame.origin.y - self.numberOfIterationsTextField.frame.size.height) - CreateDiagramPanelControllerPadding))];
		
		[[self diagramTypeLabel] setStringValue:@"Diagram Type:"];
		[[self diagramTypeLabel] setBezeled:NO];
		[[self diagramTypeLabel] setDrawsBackground:NO];
		[[self diagramTypeLabel] setEditable:NO];
		[[self diagramTypeLabel] setSelectable:NO];
		[[self diagramTypeLabel] sizeToFit];
		[[self diagramTypeLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelControllerPadding, self.diagramTypePopUpButton.frame.origin.y)];
		
		[[self xMarginLabel] setStringValue:@"Margin X:"];
		[[self xMarginLabel] setBezeled:NO];
		[[self xMarginLabel] setDrawsBackground:NO];
		[[self xMarginLabel] setEditable:NO];
		[[self xMarginLabel] setSelectable:NO];
		[[self xMarginLabel] sizeToFit];
		[[self xMarginLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelControllerPadding, self.xMarginTextField.frame.origin.y)];
		
		[[self yMarginLabel] setStringValue:@"Margin Y:"];
		[[self yMarginLabel] setBezeled:NO];
		[[self yMarginLabel] setDrawsBackground:NO];
		[[self yMarginLabel] setEditable:NO];
		[[self yMarginLabel] setSelectable:NO];
		[[self yMarginLabel] sizeToFit];
		[[self yMarginLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelControllerPadding, self.yMarginTextField.frame.origin.y)];
		
		[[self numberOfSitesLabel] setStringValue:@"Total Sites:"];
		[[self numberOfSitesLabel] setBezeled:NO];
		[[self numberOfSitesLabel] setDrawsBackground:NO];
		[[self numberOfSitesLabel] setEditable:NO];
		[[self numberOfSitesLabel] setSelectable:NO];
		[[self numberOfSitesLabel] sizeToFit];
		[[self numberOfSitesLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelControllerPadding, self.numberOfSitesTextField.frame.origin.y)];
		
		[[self numberOfIterationsLabel] setStringValue:@"Iterations:"];
		[[self numberOfIterationsLabel] setBezeled:NO];
		[[self numberOfIterationsLabel] setDrawsBackground:NO];
		[[self numberOfIterationsLabel] setEditable:NO];
		[[self numberOfIterationsLabel] setSelectable:NO];
		[[self numberOfIterationsLabel] sizeToFit];
		[[self numberOfIterationsLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelControllerPadding, self.numberOfIterationsTextField.frame.origin.y)];
		
		[[self spiralChordLabel] setStringValue:@"Spiral Chord:"];
		[[self spiralChordLabel] setBezeled:NO];
		[[self spiralChordLabel] setDrawsBackground:NO];
		[[self spiralChordLabel] setEditable:NO];
		[[self spiralChordLabel] setSelectable:NO];
		[[self spiralChordLabel] sizeToFit];
		[[self spiralChordLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelControllerPadding, self.spiralChordTextField.frame.origin.y)];
		
		[contentView addSubview:[self cancelButton]];
		[contentView addSubview:[self confirmButton]];
		[contentView addSubview:[self diagramTypePopUpButton]];
		[contentView addSubview:[self xMarginTextField]];
		[contentView addSubview:[self yMarginTextField]];
		[contentView addSubview:[self numberOfSitesTextField]];
		[contentView addSubview:[self numberOfIterationsTextField]];
		[contentView addSubview:[self spiralChordTextField]];
		[contentView addSubview:[self diagramTypeLabel]];
		[contentView addSubview:[self xMarginLabel]];
		[contentView addSubview:[self yMarginLabel]];
		[contentView addSubview:[self numberOfSitesLabel]];
		[contentView addSubview:[self numberOfIterationsLabel]];
		[contentView addSubview:[self spiralChordLabel]];
	}
	
	return self;
}

@end