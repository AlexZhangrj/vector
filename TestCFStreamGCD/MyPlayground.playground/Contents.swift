//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var code = NSStreamEvent.OpenCompleted.rawValue
print(code)
code = NSStreamEvent.HasSpaceAvailable.rawValue
print(code)
code = NSStreamEvent.ErrorOccurred.rawValue
print(code)
code = NSStreamEvent.EndEncountered.rawValue
print(code)
code = NSStreamEvent.HasBytesAvailable.rawValue
print(code)
code = NSStreamEvent.None.rawValue
print(code)
//        }
//        if code & NSStreamEvent.HasSpaceAvailable.rawValue == NSStreamEvent.HasSpaceAvailable.rawValue {
//            _handleEventHasSpaceAvailableStream(aStream)
//        }
//        if code & NSStreamEvent.ErrorOccurred.rawValue == NSStreamEvent.ErrorOccurred.rawValue {
//            _handleEventErrorOccurredStream(aStream)
//        }
//        if code & NSStreamEvent.EndEncountered.rawValue == NSStreamEvent.EndEncountered.rawValue {
//            _handleEventEndEncounteredStream(aStream)
//        }
//        if code & NSStreamEvent.HasBytesAvailable.rawValue == NSStreamEvent.HasBytesAvailable.rawValue {
//            _handleEventHasBytesAvailableStream(aStream)
//        }