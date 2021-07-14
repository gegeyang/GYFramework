//
//  GYSwiftAlgorithmInfo.swift
//  GYFramework
//
//  Created by Yang Ge on 2021/7/14.
//  Copyright © 2021 GeYang. All rights reserved.
//

import Foundation

class GYSwiftAlgorithmInfo: NSObject {
    override init() {
        super.init();
        var array : [Int] = [5, 2, 3, 7, 1];
        print(self.sortByChaRu(array: &array));
    }
    
    //冒泡排序
    func sortByMaopao(array : inout [Int]) -> [Int] {
        for i in 0..<array.count - 1 {
            for j in 0..<array.count - 1 - i {
                if array[j] > array[j + 1] {
                    array.swapAt(j, j + 1);
                }
            }
        }
        return array;
    }
    
    //选择排序
    func sortByXuanZe(array : inout [Int]) -> [Int] {
        for i in 0..<array.count - 1 {
            var minIndex : Int = i;
            for j in i..<array.count {
                if array[j] < array[minIndex] {
                    minIndex = j;
                }
            }
            if minIndex != i {
                array.swapAt(i, minIndex);
            }
        }
        return array;
    }
    
    //插入排序
    func sortByChaRu(array : inout [Int]) -> [Int] {
        for i in 1..<array.count {
            let temp : Int = array[i];
            var j : Int = i;
            while j > 0 && temp < array[j - 1] {
                array[j] = array[j - 1];
                j -= 1;
            }
            array[j] = temp;
        }
        return array;
    }
    
}


