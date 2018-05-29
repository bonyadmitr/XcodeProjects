//
//  UIViewController+Extensions.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 01/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "UIViewController+Extensions.h"

@implementation UIViewController (Extensions)

-(void)showError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
