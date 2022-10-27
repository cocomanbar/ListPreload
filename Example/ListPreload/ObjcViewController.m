//
//  ObjcViewController.m
//  ListPreload_Example
//
//  Created by tanxl on 2022/10/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import "ObjcViewController.h"
@import ListPreload;

@interface ObjcViewController ()

@end

@implementation ObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionView *collectionView = [[UICollectionView alloc] init];
    [collectionView startPreloadWithIndex:5];
    [collectionView startPreloadWithIndex:5 triBack:^{}];
    
}



@end
