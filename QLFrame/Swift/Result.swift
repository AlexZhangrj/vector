//
//  Result.swift
//  Ev
//
//  Created by 王青海 on 16/5/25.
//  Copyright © 2016年 王青海. All rights reserved.
//

import Foundation


public enum Result<SuccessResult, FailureResult> {
    case success(SuccessResult)
    case failure(FailureResult)
    
    public typealias SuccessClosure = (SuccessResult) -> Void
    public typealias FailureClosure = (FailureResult) -> Void
    
    public func doSuccess(next: SuccessClosure) {
        switch self {
        case let .success(value):
            next(value)
            break
        case .failure(_):
            break
        }
    }
    
    public func doFailure(next: FailureClosure) {
        switch self {
        case .success(_):
            break
        case let .failure(value):
            next(value)
            break
        }
    }
    
}