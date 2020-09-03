//
//  AsyncTask.swift
//  ImagesAPI
//
//  Created by Fedya on 02.09.2020.
//  Copyright © 2020 Fedya. All rights reserved.
//

import Foundation
import ReactiveSwift

typealias AsyncTask<Value> = SignalProducer<Value, Error>
typealias AsyncTaskValue<Value> = SignalProducer<Value, Never>
