//
//  ViewController.m
//  AppThumCollectionView
//
//  Created by MichaelMou on 15/4/9.
//  Copyright (c) 2015年 MichaelMou. All rights reserved.
//

#import "ViewController.h"
#import "ThreeDimensionalCollectionViewLayoutDemo-Swift.h"
//#import <ReactiveCocoa.h>

static NSString *identiferOfCollectionViewCell = @"identiferOfCollectionViewCell";

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic)NSArray *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    [RACObserve(self.view, bounds) subscribeNext:^(id x){
        ThreeDimensionalCollectionViewLayout *layout = [ThreeDimensionalCollectionViewLayout new];
        NSMutableArray *images = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            NSString *nameOfImage = [NSString stringWithFormat:@"%ld.jpg",(long)i];
            UIImage *image = [UIImage imageNamed:nameOfImage];
            [images addObject:image];
        }
        layout.images = images;
        self.images = images;
        self.collectionView.collectionViewLayout = layout;
        [self.collectionView registerNib:[UINib nibWithNibName:@"AppThumCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:identiferOfCollectionViewCell];
        [self.collectionView reloadData];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AppThumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identiferOfCollectionViewCell forIndexPath:indexPath];
    cell.image = self.images[indexPath.row];
    cell.tag = indexPath.row;
    
    
    return cell;
}


@end
