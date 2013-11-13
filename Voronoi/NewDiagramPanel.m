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
@property (nonatomic) NSTabView *tabView;

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
		
		[self setTabView:[[NSTabView alloc] init]];
		
		NSView *contentView = (NSView *)[self contentView];
		
		[[self cancelButton] setBezelStyle:NSRoundedBezelStyle];
		[[self cancelButton] setTitle:@"Cancel"];
		[[self cancelButton] sizeToFit];
		[[self cancelButton] setTarget:self];
		[[self cancelButton] setAction:@selector(cancelButtonEventHandler:)];
		[[self cancelButton] setFrameSize:NSMakeSize((self.cancelButton.frame.size.width + NewDiagramPanelPadding), self.cancelButton.frame.size.height)];
		[[self cancelButton] setFrameOrigin:NSMakePoint(NewDiagramPanelPadding, NewDiagramPanelPadding)];
		
		[[self confirmButton] setBezelStyle:NSRoundedBezelStyle];
		[[self confirmButton] setTitle:@"Confirm"];
		[[self confirmButton] sizeToFit];
		[[self confirmButton] setTarget:self];
		[[self confirmButton] setAction:@selector(confirmButtonEventHandler:)];
		[[self confirmButton] setFrameSize:NSMakeSize((self.confirmButton.frame.size.width + NewDiagramPanelPadding), self.confirmButton.frame.size.height)];
		[[self confirmButton] setFrameOrigin:NSMakePoint((contentView.frame.size.width - (self.confirmButton.frame.size.width + NewDiagramPanelPadding)), NewDiagramPanelPadding)];
		
		[[self tabView] setFrame:NSMakeRect(NewDiagramPanelPadding, (self.cancelButton.frame.origin.y + self.cancelButton.frame.size.height), (contentView.frame.size.width - (NewDiagramPanelPadding * 2.0)), (contentView.frame.size.height - (self.cancelButton.frame.origin.y + self.cancelButton.frame.size.height + NewDiagramPanelPadding)))];
		
		NSTabViewItem *tabViewItem = nil;
		
		tabViewItem = [[NSTabViewItem alloc] init];
		[tabViewItem setLabel:@"Grid"];
		[[self tabView] addTabViewItem:tabViewItem];
		
		tabViewItem = [[NSTabViewItem alloc] init];
		[tabViewItem setLabel:@"Spiral"];
		[[self tabView] addTabViewItem:tabViewItem];
		
		tabViewItem = [[NSTabViewItem alloc] init];
		[tabViewItem setLabel:@"Random"];
		[[self tabView] addTabViewItem:tabViewItem];
		
		[[self contentView] addSubview:[self cancelButton]];
		[[self contentView] addSubview:[self confirmButton]];
		[[self contentView] addSubview:[self tabView]];
	}
	
	return self;
}

@end