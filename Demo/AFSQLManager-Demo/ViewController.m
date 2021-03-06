//
//  ViewController.m
//  AFSQLManager-Demo
//
//  Created by Alvaro Franco on 4/17/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "ViewController.h"
#import "AFSQLManager.h"
#import "ResultsViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [_button addTarget:self action:@selector(performQuery) forControlEvents:UIControlEventTouchUpInside];

    [[AFSQLManager sharedManager]openLocalDatabaseWithName:@"test.sqlite" andStatusBlock:^(BOOL success, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

-(void)performQuery {
    
    _array = [NSMutableArray array];
    [[AFSQLManager sharedManager]performQuery:_textField.text withBlock:^(NSArray *row, NSError *error, BOOL finished) {
       
        if (!error) {
            
            if (!finished) {
                [_array addObject:row];
            } else {
                [self performSegueWithIdentifier:@"PerformQuery" sender:self];
            }
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"PerformQuery"]) {
        ResultsViewController *resultsVC = segue.destinationViewController;
        resultsVC.results = _array;
    }
}

@end
