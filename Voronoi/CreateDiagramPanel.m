//
//*******
//
//	filename: CreateDiagramPanel.m
//	author: Zack Brown
//	date: 06/11/2013
//
//*******
//

#import "CreateDiagramPanel.h"

#import "NumberFormatter.h"
#import "MTRandom.h"

CGFloat const CreateDiagramPanelPadding = 10.0;
CGFloat const DiagramMinimumRequiredRegion = 100.0;

@interface CreateDiagramPanel ()

@property (nonatomic) NSButton *cancelButton;
@property (nonatomic) NSButton *confirmButton;
@property (nonatomic) NSPopUpButton *diagramTypePopUpButton;
@property (nonatomic) NSTextField *xMarginTextField;
@property (nonatomic) NSTextField *yMarginTextField;
@property (nonatomic) NSTextField *numberOfSitesTextField;
@property (nonatomic) NSTextField *numberOfIterationsTextField;
@property (nonatomic) NSTextField *gridColumnsTextField;
@property (nonatomic) NSTextField *gridRowsTextField;
@property (nonatomic) NSTextField *spiralChordTextField;
@property (nonatomic) NSTextField *seedTextField;
@property (nonatomic) NSTextField *diagramTypeLabel;
@property (nonatomic) NSTextField *xMarginLabel;
@property (nonatomic) NSTextField *yMarginLabel;
@property (nonatomic) NSTextField *numberOfSitesLabel;
@property (nonatomic) NSTextField *numberOfIterationsLabel;
@property (nonatomic) NSTextField *gridColumnsLabel;
@property (nonatomic) NSTextField *gridRowsLabel;
@property (nonatomic) NSTextField *spiralChordLabel;
@property (nonatomic) NSTextField *seedLabel;
@property (nonatomic) NSNumberFormatter *numberFormatter;
@property (nonatomic) MTRandom *randomNumberGenerator;

@end

@implementation CreateDiagramPanel

#pragma mark - CreateDiagramPanel

- (void)cancelButtonEventHandler:(id)sender
{
	if([self diagramDelegate] && [[self diagramDelegate] respondsToSelector:@selector(createDiagramPanelDidCancel:)])
	{
		[[self diagramDelegate] createDiagramPanelDidCancel:self];
	}
}

- (void)confirmButtonEventHandler:(id)sender
{
	NSMenuItem *menuItem = [[self diagramTypePopUpButton] selectedItem];
		
	DiagramType diagramType = [[self diagramTypePopUpButton] indexOfItem:menuItem];
	NSInteger xMargin = [[self xMarginTextField] integerValue];
	NSInteger yMargin = [[self yMarginTextField] integerValue];
	NSInteger numberOfSites = [[self numberOfSitesTextField] integerValue];
	NSInteger numberOfIterations = [[self numberOfIterationsTextField] integerValue];
	NSInteger columns = [[self gridColumnsTextField] integerValue];
	NSInteger rows = [[self gridRowsTextField] integerValue];
	NSInteger seed = [[self seedTextField] integerValue];
	CGFloat spiralChord = [[self spiralChordTextField] floatValue];
	
	NSView *contentView = self.sheetParent.contentView;
	
	CGFloat xMarginLimit = (contentView.frame.size.width - DiagramMinimumRequiredRegion);
	CGFloat yMarginLimit = (contentView.frame.size.height - DiagramMinimumRequiredRegion);
	
	if(xMargin > xMarginLimit)
	{
		NSAlert *alert = [[NSAlert alloc] init];
		
		[alert setMessageText:@"Invalid Diagram Settings"];
		[alert setInformativeText:[NSString stringWithFormat:@"X margin must not exceed %f", xMarginLimit]];
		[alert setAlertStyle:NSWarningAlertStyle];
		
		[alert beginSheetModalForWindow:self completionHandler:nil];
		
		return;
	}
	
	if(yMargin > yMarginLimit)
	{
		NSAlert *alert = [[NSAlert alloc] init];
		
		[alert setMessageText:@"Invalid Diagram Settings"];
		[alert setInformativeText:[NSString stringWithFormat:@"Y margin must not exceed %f", yMarginLimit]];
		[alert setAlertStyle:NSWarningAlertStyle];
		
		[alert beginSheetModalForWindow:self completionHandler:nil];
		
		return;
	}
	
	if(diagramType == DiagramTypeRandom && numberOfSites == 0)
	{
		NSAlert *alert = [[NSAlert alloc] init];
		
		[alert setMessageText:@"Invalid Diagram Settings"];
		[alert setInformativeText:@"Number of sites must be greater than zero."];
		[alert setAlertStyle:NSWarningAlertStyle];
		
		[alert beginSheetModalForWindow:self completionHandler:nil];
		
		return;
	}
	
	if(numberOfIterations == 0)
	{
		NSAlert *alert = [[NSAlert alloc] init];
		
		[alert setMessageText:@"Invalid Diagram Settings"];
		[alert setInformativeText:@"Number of iterations must be greater than zero."];
		[alert setAlertStyle:NSWarningAlertStyle];
		
		[alert beginSheetModalForWindow:self completionHandler:nil];
		
		return;
	}
	
	if(diagramType == DiagramTypeGrid && columns == 0)
	{
		NSAlert *alert = [[NSAlert alloc] init];
		
		[alert setMessageText:@"Invalid Diagram Settings"];
		[alert setInformativeText:@"Number of columns must be greater than zero."];
		[alert setAlertStyle:NSWarningAlertStyle];
		
		[alert beginSheetModalForWindow:self completionHandler:nil];
		
		return;
	}
	
	if(diagramType == DiagramTypeGrid && rows == 0)
	{
		NSAlert *alert = [[NSAlert alloc] init];
		
		[alert setMessageText:@"Invalid Diagram Settings"];
		[alert setInformativeText:@"Number of rows must be greater than zero."];
		[alert setAlertStyle:NSWarningAlertStyle];
		
		[alert beginSheetModalForWindow:self completionHandler:nil];
		
		return;
	}
	
	switch(diagramType)
	{
		default:
		case DiagramTypeGrid:
		{
			if([self diagramDelegate] && [[self diagramDelegate] respondsToSelector:@selector(createDiagramPanelDidConfirmWithGridDiagramType:xMargin:yMargin:numberOfIterations:columns:rows:)])
			{
				[[self diagramDelegate] createDiagramPanelDidConfirmWithGridDiagramType:self xMargin:xMargin yMargin:yMargin numberOfIterations:numberOfIterations columns:columns rows:rows];
			}
			
			//bail
			break;
		}
		case DiagramTypeRandom:
		{
			if([self diagramDelegate] && [[self diagramDelegate] respondsToSelector:@selector(createDiagramPanelDidConfirmWithRandomDiagramType:xMargin:yMargin:numberOfIterations:numberOfSites:seed:)])
			{
				[[self diagramDelegate] createDiagramPanelDidConfirmWithRandomDiagramType:self xMargin:xMargin yMargin:yMargin numberOfIterations:numberOfIterations numberOfSites:numberOfSites seed:seed];
			}
			
			//bail
			break;
		}
		case DiagramTypeSpiral:
		{
			if([self diagramDelegate] && [[self diagramDelegate] respondsToSelector:@selector(createDiagramPanelDidConfirmWithSpiralDiagramType:xMargin:yMargin:numberOfIterations:spiralChord:)])
			{
				[[self diagramDelegate] createDiagramPanelDidConfirmWithSpiralDiagramType:self xMargin:xMargin yMargin:yMargin numberOfIterations:numberOfIterations spiralChord:spiralChord];
			}
			
			//bail
			break;
		}
	}
}

- (void)diagramTypePopUpButtonEventHandler:(id)sender
{
	NSMenuItem *menuItem = [[self diagramTypePopUpButton] selectedItem];
	
	DiagramType diagramType = [[self diagramTypePopUpButton] indexOfItem:menuItem];
	
	switch(diagramType)
	{
		default:
		case DiagramTypeGrid:
		{
			[self makeTextField:[self numberOfSitesTextField] active:NO];
			[self makeTextField:[self gridColumnsTextField] active:YES];
			[self makeTextField:[self gridRowsTextField] active:YES];
			[self makeTextField:[self spiralChordTextField] active:NO];
			[self makeTextField:[self seedTextField] active:NO];
			
			//bail
			break;
		}
		case DiagramTypeRandom:
		{
			[self makeTextField:[self numberOfSitesTextField] active:YES];
			[self makeTextField:[self gridColumnsTextField] active:NO];
			[self makeTextField:[self gridRowsTextField] active:NO];
			[self makeTextField:[self spiralChordTextField] active:NO];
			[self makeTextField:[self seedTextField] active:YES];
			
			//bail
			break;
		}
		case DiagramTypeSpiral:
		{
			[self makeTextField:[self numberOfSitesTextField] active:NO];
			[self makeTextField:[self gridColumnsTextField] active:NO];
			[self makeTextField:[self gridRowsTextField] active:NO];
			[self makeTextField:[self spiralChordTextField] active:YES];
			[self makeTextField:[self seedTextField] active:NO];
			
			//bail
			break;
		}
	}
}

- (void)makeTextField:(NSTextField *)textField active:(BOOL)active
{
	[textField setEnabled:active];
	[textField setEditable:active];
	[textField setSelectable:active];
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
		[self setGridColumnsTextField:[[NSTextField alloc] init]];
		[self setGridRowsTextField:[[NSTextField alloc] init]];
		[self setSpiralChordTextField:[[NSTextField alloc] init]];
		[self setSeedTextField:[[NSTextField alloc] init]];
		
		[self setDiagramTypeLabel:[[NSTextField alloc] init]];
		[self setXMarginLabel:[[NSTextField alloc] init]];
		[self setYMarginLabel:[[NSTextField alloc] init]];
		[self setNumberOfSitesLabel:[[NSTextField alloc] init]];
		[self setNumberOfIterationsLabel:[[NSTextField alloc] init]];
		[self setGridColumnsLabel:[[NSTextField alloc] init]];
		[self setGridRowsLabel:[[NSTextField alloc] init]];
		[self setSpiralChordLabel:[[NSTextField alloc] init]];
		[self setSeedLabel:[[NSTextField alloc] init]];
		
		[self setNumberFormatter:[[NumberFormatter alloc] init]];
		
		[self setRandomNumberGenerator:[[MTRandom alloc] init]];
		
		[[self numberFormatter] setNumberStyle:NSNumberFormatterDecimalStyle];
		
		NSView *contentView = (NSView *)[self contentView];
		
		[[self confirmButton] setBezelStyle:NSRoundedBezelStyle];
		[[self confirmButton] setTitle:@"Confirm"];
		[[self confirmButton] sizeToFit];
		[[self confirmButton] setTarget:self];
		[[self confirmButton] setAction:@selector(confirmButtonEventHandler:)];
		[[self confirmButton] setFrameSize:NSMakeSize((self.confirmButton.frame.size.width + (CreateDiagramPanelPadding * 2.0)), self.confirmButton.frame.size.height)];
		[[self confirmButton] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.confirmButton.frame.size.width + CreateDiagramPanelPadding)), CreateDiagramPanelPadding)];
		
		[[self cancelButton] setBezelStyle:NSRoundedBezelStyle];
		[[self cancelButton] setTitle:@"Cancel"];
		[[self cancelButton] sizeToFit];
		[[self cancelButton] setTarget:self];
		[[self cancelButton] setAction:@selector(cancelButtonEventHandler:)];
		[[self cancelButton] setFrameSize:NSMakeSize((self.cancelButton.frame.size.width + (CreateDiagramPanelPadding * 2.0)), self.cancelButton.frame.size.height)];
		[[self cancelButton] setFrameOrigin:NSMakePoint((self.confirmButton.frame.origin.x - self.cancelButton.frame.size.width), CreateDiagramPanelPadding)];
		
		[[self diagramTypePopUpButton] addItemWithTitle:@"Grid"];
		[[self diagramTypePopUpButton] addItemWithTitle:@"Random"];
		[[self diagramTypePopUpButton] addItemWithTitle:@"Spiral"];
		
		[[self diagramTypePopUpButton] selectItemWithTitle:@"Random"];
		[[self diagramTypePopUpButton] sizeToFit];
		[[self diagramTypePopUpButton] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.diagramTypePopUpButton.frame.size.height)];
		[[self diagramTypePopUpButton] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.diagramTypePopUpButton.frame.size.width + CreateDiagramPanelPadding)), (contentView.frame.size.height - (CreateDiagramPanelPadding * 4.0)))];
		[[self diagramTypePopUpButton] setTarget:self];
		[[self diagramTypePopUpButton] setAction:@selector(diagramTypePopUpButtonEventHandler:)];
		
		[[self xMarginTextField] setFloatValue:100.0];
		[[self xMarginTextField] setFormatter:[self numberFormatter]];
		[[self xMarginTextField] sizeToFit];
		[[self xMarginTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.xMarginTextField.frame.size.height)];
		[[self xMarginTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.xMarginTextField.frame.size.width + CreateDiagramPanelPadding)), ((self.diagramTypePopUpButton.frame.origin.y - self.diagramTypePopUpButton.frame.size.height) - CreateDiagramPanelPadding))];
		
		[[self yMarginTextField] setFloatValue:100.0];
		[[self yMarginTextField] setFormatter:[self numberFormatter]];
		[[self yMarginTextField] sizeToFit];
		[[self yMarginTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.yMarginTextField.frame.size.height)];
		[[self yMarginTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.yMarginTextField.frame.size.width + CreateDiagramPanelPadding)), ((self.xMarginTextField.frame.origin.y - self.xMarginTextField.frame.size.height) - CreateDiagramPanelPadding))];
		
		[[self numberOfSitesTextField] setIntegerValue:[[self randomNumberGenerator] randomUInt32From:1 to:100]];
		[[self numberOfSitesTextField] setFormatter:[self numberFormatter]];
		[[self numberOfSitesTextField] sizeToFit];
		[[self numberOfSitesTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.numberOfSitesTextField.frame.size.height)];
		[[self numberOfSitesTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.numberOfSitesTextField.frame.size.width + CreateDiagramPanelPadding)), ((self.yMarginTextField.frame.origin.y - self.yMarginTextField.frame.size.height) - CreateDiagramPanelPadding))];
		
		[[self numberOfIterationsTextField] setIntegerValue:1];
		[[self numberOfIterationsTextField] setFormatter:[self numberFormatter]];
		[[self numberOfIterationsTextField] sizeToFit];
		[[self numberOfIterationsTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.numberOfIterationsTextField.frame.size.height)];
		[[self numberOfIterationsTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.numberOfIterationsTextField.frame.size.width + CreateDiagramPanelPadding)), ((self.numberOfSitesTextField.frame.origin.y - self.numberOfSitesTextField.frame.size.height) - CreateDiagramPanelPadding))];
		
		[[self gridColumnsTextField] setIntegerValue:10];
		[[self gridColumnsTextField] setFormatter:[self numberFormatter]];
		[[self gridColumnsTextField] sizeToFit];
		[[self gridColumnsTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.gridColumnsTextField.frame.size.height)];
		[[self gridColumnsTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.gridColumnsTextField.frame.size.width + CreateDiagramPanelPadding)), ((self.numberOfIterationsTextField.frame.origin.y - self.numberOfIterationsTextField.frame.size.height) - CreateDiagramPanelPadding))];
		
		[[self gridRowsTextField] setIntegerValue:10];
		[[self gridRowsTextField] setFormatter:[self numberFormatter]];
		[[self gridRowsTextField] sizeToFit];
		[[self gridRowsTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.gridRowsTextField.frame.size.height)];
		[[self gridRowsTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.gridRowsTextField.frame.size.width + CreateDiagramPanelPadding)), ((self.gridColumnsTextField.frame.origin.y - self.gridColumnsTextField.frame.size.height) - CreateDiagramPanelPadding))];
		
		[[self spiralChordTextField] setIntegerValue:35];
		[[self spiralChordTextField] setFormatter:[self numberFormatter]];
		[[self spiralChordTextField] sizeToFit];
		[[self spiralChordTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.spiralChordTextField.frame.size.height)];
		[[self spiralChordTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.spiralChordTextField.frame.size.width + CreateDiagramPanelPadding)), ((self.gridRowsTextField.frame.origin.y - self.gridRowsTextField.frame.size.height) - CreateDiagramPanelPadding))];
		
		[[self seedTextField] setIntegerValue:[[self randomNumberGenerator] randomUInt32]];
		[[self seedTextField] setFormatter:[self numberFormatter]];
		[[self seedTextField] sizeToFit];
		[[self seedTextField] setFrameSize:NSMakeSize((contentView.frame.size.width / 2.0), self.seedTextField.frame.size.height)];
		[[self seedTextField] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.seedTextField.frame.size.width + CreateDiagramPanelPadding)), ((self.spiralChordTextField.frame.origin.y - self.spiralChordTextField.frame.size.height) - CreateDiagramPanelPadding))];
		
		[[self diagramTypeLabel] setStringValue:@"Diagram Type:"];
		[[self diagramTypeLabel] setBezeled:NO];
		[[self diagramTypeLabel] setDrawsBackground:NO];
		[[self diagramTypeLabel] setEditable:NO];
		[[self diagramTypeLabel] setSelectable:NO];
		[[self diagramTypeLabel] sizeToFit];
		[[self diagramTypeLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelPadding, self.diagramTypePopUpButton.frame.origin.y)];
		
		[[self xMarginLabel] setStringValue:@"Margin X:"];
		[[self xMarginLabel] setBezeled:NO];
		[[self xMarginLabel] setDrawsBackground:NO];
		[[self xMarginLabel] setEditable:NO];
		[[self xMarginLabel] setSelectable:NO];
		[[self xMarginLabel] sizeToFit];
		[[self xMarginLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelPadding, self.xMarginTextField.frame.origin.y)];
		
		[[self yMarginLabel] setStringValue:@"Margin Y:"];
		[[self yMarginLabel] setBezeled:NO];
		[[self yMarginLabel] setDrawsBackground:NO];
		[[self yMarginLabel] setEditable:NO];
		[[self yMarginLabel] setSelectable:NO];
		[[self yMarginLabel] sizeToFit];
		[[self yMarginLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelPadding, self.yMarginTextField.frame.origin.y)];
		
		[[self numberOfSitesLabel] setStringValue:@"Total Sites:"];
		[[self numberOfSitesLabel] setBezeled:NO];
		[[self numberOfSitesLabel] setDrawsBackground:NO];
		[[self numberOfSitesLabel] setEditable:NO];
		[[self numberOfSitesLabel] setSelectable:NO];
		[[self numberOfSitesLabel] sizeToFit];
		[[self numberOfSitesLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelPadding, self.numberOfSitesTextField.frame.origin.y)];
		
		[[self numberOfIterationsLabel] setStringValue:@"Iterations:"];
		[[self numberOfIterationsLabel] setBezeled:NO];
		[[self numberOfIterationsLabel] setDrawsBackground:NO];
		[[self numberOfIterationsLabel] setEditable:NO];
		[[self numberOfIterationsLabel] setSelectable:NO];
		[[self numberOfIterationsLabel] sizeToFit];
		[[self numberOfIterationsLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelPadding, self.numberOfIterationsTextField.frame.origin.y)];
		
		[[self gridColumnsLabel] setStringValue:@"Columns:"];
		[[self gridColumnsLabel] setBezeled:NO];
		[[self gridColumnsLabel] setDrawsBackground:NO];
		[[self gridColumnsLabel] setEditable:NO];
		[[self gridColumnsLabel] setSelectable:NO];
		[[self gridColumnsLabel] sizeToFit];
		[[self gridColumnsLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelPadding, self.gridColumnsTextField.frame.origin.y)];
		
		[[self gridRowsLabel] setStringValue:@"Rows:"];
		[[self gridRowsLabel] setBezeled:NO];
		[[self gridRowsLabel] setDrawsBackground:NO];
		[[self gridRowsLabel] setEditable:NO];
		[[self gridRowsLabel] setSelectable:NO];
		[[self gridRowsLabel] sizeToFit];
		[[self gridRowsLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelPadding, self.gridRowsTextField.frame.origin.y)];
		
		[[self spiralChordLabel] setStringValue:@"Spiral Chord:"];
		[[self spiralChordLabel] setBezeled:NO];
		[[self spiralChordLabel] setDrawsBackground:NO];
		[[self spiralChordLabel] setEditable:NO];
		[[self spiralChordLabel] setSelectable:NO];
		[[self spiralChordLabel] sizeToFit];
		[[self spiralChordLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelPadding, self.spiralChordTextField.frame.origin.y)];
		
		[[self seedLabel] setStringValue:@"Seed:"];
		[[self seedLabel] setBezeled:NO];
		[[self seedLabel] setDrawsBackground:NO];
		[[self seedLabel] setEditable:NO];
		[[self seedLabel] setSelectable:NO];
		[[self seedLabel] sizeToFit];
		[[self seedLabel] setFrameOrigin:NSMakePoint(CreateDiagramPanelPadding, self.seedTextField.frame.origin.y)];
		
		[self makeTextField:[self gridColumnsTextField] active:NO];
		[self makeTextField:[self gridRowsTextField] active:NO];
		[self makeTextField:[self spiralChordTextField] active:NO];
		
		[contentView addSubview:[self cancelButton]];
		[contentView addSubview:[self confirmButton]];
		[contentView addSubview:[self diagramTypePopUpButton]];
		[contentView addSubview:[self xMarginTextField]];
		[contentView addSubview:[self yMarginTextField]];
		[contentView addSubview:[self numberOfSitesTextField]];
		[contentView addSubview:[self numberOfIterationsTextField]];
		[contentView addSubview:[self gridColumnsTextField]];
		[contentView addSubview:[self gridRowsTextField]];
		[contentView addSubview:[self spiralChordTextField]];
		[contentView addSubview:[self seedTextField]];
		[contentView addSubview:[self diagramTypeLabel]];
		[contentView addSubview:[self xMarginLabel]];
		[contentView addSubview:[self yMarginLabel]];
		[contentView addSubview:[self numberOfSitesLabel]];
		[contentView addSubview:[self numberOfIterationsLabel]];
		[contentView addSubview:[self gridColumnsLabel]];
		[contentView addSubview:[self gridRowsLabel]];
		[contentView addSubview:[self spiralChordLabel]];
		[contentView addSubview:[self seedLabel]];
	}
	
	return self;
}

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

@end