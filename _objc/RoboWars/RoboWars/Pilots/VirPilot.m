//
//  VirPilot.m
//  VPilot
//
//  Created by Kokorin Konstantin on 31.10.13.
//
//

#import "VirPilot.h"

@interface VirPilot ()

@property (strong, nonatomic) NSMutableDictionary *shots;

@end

@implementation VirPilot

- (void)restart {
    self.shots = [[NSMutableDictionary alloc] init]; //Выделение и инициализация объекта
}

- (CGPoint)fire {
    
    //Доступные координаты
    BOOL availableCoordinates = NO;
    
    CGPoint coordinate = CGPointMake(0,0); //Обнуляемся
    
    while (!availableCoordinates) {
        //Стреляем на угад по длине и ширине поля и используем приведение типов, так как арк - целое число
        coordinate = CGPointMake(arc4random() % (NSInteger)self.fieldSize.width, arc4random() % (NSInteger)self.fieldSize.height);
        
        //Смотрим, чтобы не попасть в себя и не попасть в то место куда уже стреляли
        availableCoordinates = !CGRectContainsPoint(self.robotRect, coordinate) && ![self.shots objectForKey:NSStringFromCGPoint(coordinate)];
    }
    return coordinate;
}


- (void)shotFrom:(id<RWPilot>)robot withCoordinate:(CGPoint)coordinate andResult:(RWShotResult)result {
    
    if (!self.shots) {
        [self restart];
    }
    [self.shots setObject:@"" forKey:NSStringFromCGPoint(coordinate)];
}

- (NSString*)robotName {
    return @"Virer's Robot!";
}

- (NSString*)victoryPhrase {
    return @"I'am win!!";
}

- (NSString*)defeatPhrase {
    return @"Proudly!";
}

@end
