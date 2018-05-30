//
//  ASViewController.m
//  RoboWars
//
//  Created by Oleksii Skutarenko on 13.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import "ASBattleViewController.h"
#import "ASBattleFieldView.h"
#import "ASTestPilot.h"
#import "RWPilot.h"
#import "ASRobot.h"
#import "ASPilot.h"

#import "ASSmart.h"

@interface ASBattleViewController () <ASBattleFieldDataSource>

@property (assign, nonatomic) CGSize fieldSize;
@property (strong, nonatomic) NSArray* allRobots;
@property (strong, nonatomic) NSMutableArray* selectedRobots;
@property (strong, nonatomic) NSMutableArray* shots;
@property (strong, nonatomic) NSMutableArray* robotsOrder;
@property (assign, nonatomic) BOOL shouldRestart;
@property (strong, nonatomic) NSMutableSet* buggyRobots;

@end

@implementation ASBattleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buggyRobots = [NSMutableSet set];
    
    self.battleView.layer.borderWidth = 1.f;
    self.battleView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.battleView.layer.cornerRadius = 5.f;
    
    
    self.shots = [NSMutableArray array];
    self.robotsOrder = [NSMutableArray array];
    
    ASSmart* p1         = [[ASSmart alloc] init];
    ASTestPilot* p2     = [[ASTestPilot alloc] init];
    ASTestPilot* p3     = [[ASTestPilot alloc] init];
    ASTestPilot* p4     = [[ASTestPilot alloc] init];
    
    self.allRobots = [NSArray arrayWithObjects:
                      [ASRobot robotWithPilot:p1],
                      [ASRobot robotWithPilot:p2],
                      [ASRobot robotWithPilot:p3],
                      [ASRobot robotWithPilot:p4],
                      nil];
    
    self.allRobots = [self shuffleArray:self.allRobots];
    
    self.selectedRobots = [NSMutableArray arrayWithArray:self.allRobots];//[NSMutableArray array];
    
    self.battleView.dataSource = self;
    
    [self randomizeField];
    
    [self.battleView reloadData];
    [self.tableView reloadData];
}

- (NSArray*) shuffleArray:(NSArray*) array {
    
    NSMutableArray* temp = [NSMutableArray arrayWithArray:array];
    
    int count = [temp count] * 10;
    
    for (int i = 0; i < count; i++) {
        
        int index1 = i % [temp count];
        int index2 = arc4random() % [temp count];
        
        if (index1 != index2) {
            [temp exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        }
        
    }
    return temp;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) randomizeField {
    
    [self.robotsOrder removeAllObjects];
    [self.shots removeAllObjects];
    [self.buggyRobots removeAllObjects];
    
    self.fieldSize = CGSizeMake(7 + [self.selectedRobots count], 7 + [self.selectedRobots count]);
    
    NSMutableArray* selectedRects = [NSMutableArray array];
    
    // find a place for a robot
    for (ASRobot* robot in self.selectedRobots) {
        
        robot.pilot.fieldSize = self.fieldSize;
        
        BOOL placeIsAvailable = NO;
        while (!placeIsAvailable) {
            
            CGSize tempSize = arc4random() % 2 ? CGSizeMake(2,3) : CGSizeMake(3,2);
            
            CGRect tempRect = CGRectMake(arc4random() % (int)(self.fieldSize.width - tempSize.width + 1),
                                         arc4random() % (int)(self.fieldSize.height - tempSize.height + 1),
                                         tempSize.width, tempSize.height);
            
            placeIsAvailable = YES;
            
            for (NSValue* value in selectedRects) {
                CGRect selectedRect = [value CGRectValue];
                
                if (CGRectIntersectsRect(selectedRect, tempRect)) {
                    placeIsAvailable = NO;
                    break;
                }
            }
            
            if (placeIsAvailable) {
                robot.frame = tempRect;
                CGRect unavailableArea = CGRectInset(tempRect, -1, -1);
                [selectedRects addObject:[NSValue valueWithCGRect:unavailableArea]];
            }
            
        }
        
        // create body parts
        NSMutableArray* health = [NSMutableArray array];
        for (int i = CGRectGetMinX(robot.frame); i < CGRectGetMaxX(robot.frame); i++) {
            for (int j = CGRectGetMinY(robot.frame); j < CGRectGetMaxY(robot.frame); j++) {
                [health addObject:[NSValue valueWithCGPoint:CGPointMake(i, j)]];
            }
        }
        robot.bodyParts = health;
        [robot.pilot restart];
    }
    
    self.shouldRestart = [self.selectedRobots count] == 0;
    [self.battleView reloadData];
}

- (void) nextMove {
    
    if (self.shouldRestart) {
        return;
    }
    
    
    if (![self.selectedRobots count]) {
        NSLog(@"No robots to fight");
        return;
    }
    
    if (![self.robotsOrder count]) {
        
        NSLog(@"NEXT TURN");
        
        NSMutableArray* tempRobots = [NSMutableArray array];
        for (ASRobot* robot in self.selectedRobots) {
            if ([robot.bodyParts count]) {
                [tempRobots addObject:robot];
            }
        }
        
        while ([tempRobots count] > 0) {
            
            NSInteger index = 0;
            if ([tempRobots count] > 1) {
                index = arc4random() %[tempRobots count];
            }
            
            [self.robotsOrder addObject:[tempRobots objectAtIndex:index]];
            [tempRobots removeObjectAtIndex:index];
        }
    }
    
    ASRobot* shootingRobot = [self.robotsOrder firstObject];
    
    /*
    if ([shootingRobot.pilot isKindOfClass:[ASTestPilot class]]) {
        [self.robotsOrder removeObjectAtIndex:0];
        [self nextMove];
        return;
    }
     */
    
    ASPilot* pilotCopy = [[ASPilot alloc] init];
    pilotCopy.name = [shootingRobot.pilot robotName];
    
    CGPoint coordinate = CGPointMake(-100, -100);
    
    @try {
        coordinate = [shootingRobot.pilot fire];
    }
    @catch (NSException *exception) {
        NSLog(@"EXCEPTION BECAUSE OF %@ WHEN HE WAS TRYING TO FIRE", [shootingRobot.pilot robotName]);
        NSLog(@"%@", exception);
        [self.buggyRobots addObject:shootingRobot];
        [self.robotsOrder removeObjectAtIndex:0];
        return;
    }
    @finally {}
    
    [self.shots addObject:[NSValue valueWithCGPoint:coordinate]];
    
    NSLog(@"%@ fires at %@", shootingRobot.name, NSStringFromCGPoint(coordinate));
    
    [self.battleView animateShotTo:coordinate fromRect:shootingRobot.frame];
    
    RWShotResult result = RWShotResultMiss;
    
    ASRobot* killedRobot = nil;
    for (ASRobot* robot in self.selectedRobots) {
        
        for (int i = 0; i < [robot.bodyParts count]; i++) {
            
            NSValue* cell = [robot.bodyParts objectAtIndex:i];
            
            if (CGPointEqualToPoint(coordinate, [cell CGPointValue])) {
                [robot.bodyParts removeObjectAtIndex:i];
                
                if ([robot.bodyParts count]) {
                    result = RWShotResultHit;
                } else {
                    result = RWShotResultDestroy;
                    
                    @try {
                        [robot.pilot shotFrom:pilotCopy withCoordinate:coordinate andResult:result];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"EXCEPTION BECAUSE OF %@ WHEN HE GOT COORDINATES OF SHOT", [robot.pilot robotName]);
                        NSLog(@"%@", exception);
                        [self.buggyRobots addObject:robot];
                    }
                    @finally {}
                    
                    killedRobot = robot;
                }
                break;
            }
        }
        
        if (result != RWShotResultMiss) {
            break;
        }
    }
    
    for (ASRobot* robot in self.selectedRobots) {
        if ([robot.bodyParts count]) {
            
            @try {
                [robot.pilot shotFrom:pilotCopy withCoordinate:coordinate andResult:result];
            }
            @catch (NSException *exception) {
                NSLog(@"EXCEPTION BECAUSE OF %@ WHEN HE GOT COORDINATES OF SHOT", [robot.pilot robotName]);
                NSLog(@"%@", exception);
                [self.buggyRobots addObject:robot];
            }
            @finally {}
        }
    }
    
    [self.robotsOrder removeObjectAtIndex:0];
    
    if (killedRobot) {
        [self.robotsOrder removeObject:killedRobot];
        
        NSInteger aliveRobots = 0;
        ASRobot* winner = nil;
        for (ASRobot* robot in self.selectedRobots) {
            
            if ([robot.bodyParts count]) {
                aliveRobots++;
                winner = robot;
            }
            
        }
        
        if (aliveRobots == 1) {
            NSLog(@"Game is over! %@ is the winner!!!", winner.name);
            
            NSString* finalMessage = nil;
            
            if ([winner.pilot respondsToSelector:@selector(victoryPhrase)]) {
                finalMessage = [winner.pilot victoryPhrase];
            }
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ is the winner!", winner.name]
                                        message:finalMessage
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
            self.shouldRestart = YES;
            
        } else {
            
            NSString* finalMessage = nil;
            
            if ([killedRobot.pilot respondsToSelector:@selector(defeatPhrase)]) {
                finalMessage = [killedRobot.pilot defeatPhrase];
            }
            /*
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ is destroyed", killedRobot.name]
                                        message:finalMessage
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
             */
        }
    }
}

- (IBAction) actionNewGame:(id)sender {
    
    [self randomizeField];
    
    [self.battleView reloadData];
    
}

- (IBAction) actionMove:(id)sender {
    [self nextMove];
}

#pragma mark - ASBattleFieldDataSource

- (CGSize) sizeForBattleField:(ASBattleFieldView*) battleField {
    return self.fieldSize;
}

- (NSInteger) numberOfRobotsOnBattleField:(ASBattleFieldView*) battleField {
    return [self.selectedRobots count];
}

- (CGRect) battleField:(ASBattleFieldView*) battleField rectForRobotAtIndex:(NSInteger) index {
    return [[[self.selectedRobots objectAtIndex:index] pilot] robotRect];
}

- (NSString*) battleField:(ASBattleFieldView *)battleField nameForRobotAtIndex:(NSInteger)index {
    return [[self.selectedRobots objectAtIndex:index] name];
}

- (NSInteger) numberOfShotsOnBattleField:(ASBattleFieldView*) battleField {
    return [self.shots count];
}

- (CGPoint) battleField:(ASBattleFieldView*) battleField shotCoordinateAtIndex:(NSInteger) index {
    return [[self.shots objectAtIndex:index] CGPointValue];
}

- (UIColor*) battleField:(ASBattleFieldView*) battleField colorForRobotAtIndex:(NSInteger) index {
    
    UIColor* color = [UIColor blackColor];
    
    if (index < [self.selectedRobots count]) {
        
        ASRobot* robot = [self.selectedRobots objectAtIndex:index];
        
        if ([self.buggyRobots containsObject:robot]) {
            color = [UIColor purpleColor];
        }
        
    }
    
    
    return color;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allRobots count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Robot";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    ASRobot* robot = [self.allRobots objectAtIndex:indexPath.row];
    
    cell.textLabel.text = robot.name;
    cell.detailTextLabel.text = NSStringFromClass([robot.pilot class]);
    
    cell.accessoryType = [self.selectedRobots containsObject:robot] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ASRobot* robot = [self.allRobots objectAtIndex:indexPath.row];
    
    if ([self.selectedRobots containsObject:robot]) {
        [self.selectedRobots removeObject:robot];
    } else {
        [self.selectedRobots addObject:robot];
    }
    
    [tableView reloadData];
    
    [self randomizeField];
}

@end
