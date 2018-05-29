//
//  StatusBarMenu.m
//  macObjC
//
//  Created by Bondar Yaroslav on 02/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "StatusBarMenu.h"
#import "Functions.h"

@interface StatusBarMenu () <NSMenuDelegate, NSDatePickerCellDelegate> {
    dispatch_block_t work;
    BOOL sleepSetuped;
    NSTimeInterval sleepTime;
}

@property (weak) IBOutlet NSMenuItem *setupSleepMenuItem;
@property (weak) IBOutlet NSMenuItem *cancelSleepMenuItem;

@property (weak) IBOutlet NSView *textView;
@property (weak) IBOutlet NSMenuItem *textViewMenuItem;

@property (weak) IBOutlet NSDatePickerCell *datePicker;

@end

@implementation StatusBarMenu

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.autoenablesItems = NO;
        
        
        
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
//    self.datePicker.delegate = self;
    self.delegate = self;
//    self.datePicker.delegate = self;
    
    NSTimeInterval timeZeroSeconds = floor([NSDate.date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    NSDate *dateZeroSeconds = [NSDate dateWithTimeIntervalSinceReferenceDate:timeZeroSeconds];
    
    self.datePicker.dateValue = dateZeroSeconds;
    
    sleepSetuped = NO;
    sleepTime = 60*60;
}

- (IBAction)actionDatePicker:(NSDatePicker *)sender {
    
    NSTimeInterval time = sender.dateValue.timeIntervalSinceNow;
    
    if (time < 0) {
        time += 60*60*24; /// next day
    }
    
    sleepTime = time;
    [self menuSetupSleep:nil];
}

# pragma mark - Menu

- (IBAction)menuSetupSleep:(NSMenuItem *)sender {
    sleepSetuped = YES;
    [self cancelSleep];
    NSLog(@"%f", sleepTime);
    [self delayFor:sleepTime callback:^{
        [self sendToSleep];
    }];
}

- (IBAction)menuCancelSleep:(NSMenuItem *)sender {
    sleepSetuped = NO;
    [self cancelSleep];
    
}

- (IBAction)menuQuit:(NSMenuItem *)sender {
    [NSApp terminate:nil];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    SEL action = [menuItem action];
    
    if (sleepSetuped) {
        if (action == @selector(menuSetupSleep:)) {
            return NO;
        }
    } else {
        if (action == @selector(menuCancelSleep:)) {
            return NO;
        }
    }
    
    return YES;
}
- (IBAction)menuAboutItem:(NSMenuItem *)sender {
    [NSApp orderFrontStandardAboutPanel:self];
    /// check custom: (void)orderFrontStandardAboutPanelWithOptions:(NSDictionary<NSString *, id> *)optionsDictionary;
}

# pragma mark - TImer

- (void)sendToSleep {
    sleepSetuped = NO;
    OSStatus error = noErr;
    //sending sleep event to system
    error = SendAppleEventToSystemProcess(kAESleep);
    if (error == noErr) {
        printf("Computer is going to sleep!\n");
    } else {
        printf("Computer wouldn't sleep");
    }
}

- (void)delayFor:(double)seconds callback: (void(^)(void))callback{
    work = dispatch_block_create(0, ^{
        if(callback){
            callback();
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), work);
}

- (void)cancelSleep {
    if (work) {
        dispatch_block_cancel(work);
    }
}
# pragma mark - NSMenuDelegate

-(void)menuWillOpen:(NSMenu *)menu {
//    self.datePicker.showsFirstResponder = YES;
//    [self.datePicker setFocusRingType:NSFocusRingTypeExterior];
    
//    [NSApp activateIgnoringOtherApps:YES];
}

@end
