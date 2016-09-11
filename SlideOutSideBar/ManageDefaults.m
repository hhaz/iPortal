//
//  ManageDefaults.m
//  DUiOS
//
//  Created by Hervé Azoulay on 10/06/12.
//  Copyright (c) 2012 Hervé Azoulay. All rights reserved.
//

#import "ManageDefaults.h"

@implementation ManageDefaults


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)loadDefaults
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    appDelegate.trxServerURL = [defaults stringForKey:@"trxServerURL"];

    appDelegate.minAmount = [NSNumber numberWithDouble:[defaults doubleForKey:@"minAmount"]];
    appDelegate.maxAmount = [NSNumber numberWithDouble:[defaults doubleForKey:@"maxAmount"]];
    
    appDelegate.defaultSaved        = [defaults boolForKey:@"defaultSaved"];
    if (appDelegate.defaultSaved == NO) {
        appDelegate.trxServerURL = @"http://localhost:3000";
        appDelegate.minAmount = 0;
        appDelegate.maxAmount = 0;
    }
    
}

- (void)saveDefaults
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:appDelegate.trxServerURL forKey:@"trxServerURL"];
    [defaults setObject:appDelegate.minAmount forKey:@"minAmount"];
    [defaults setObject:appDelegate.maxAmount forKey:@"maxAmount"];
    [defaults setBool:YES forKey:@"defaultSaved"];
    
    [defaults synchronize];

    
}


@end
