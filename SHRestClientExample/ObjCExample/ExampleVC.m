//
//  ExampleVC.m
//  SHRestClientExample
//
//  Created by Subhajit Halder on 19/06/18.
//  Copyright © 2018 SubhajitHalder. All rights reserved.
//

#import "ExampleVC.h"
#import "SHRestClientExample-Bridging-Header.h"
#import "SHRestClientExample-Swift.h"
//#import "SHClientHelpers-Swift.h"
//@class SHRestClient;

@interface ExampleVC ()

@end

@implementation ExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [ProgressHUD disable];
}


- (void)getExample {
    NSString *url = @"";

    SHRestClient *restC = [[SHRestClient alloc] init:url];
    SHSessionDataTask * task = [[restC getWithParameters:@{@"a":@"b"}] fetchDataWithSuccess:^(NSData * _Nullable data, NSURLResponse * _Nullable response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
