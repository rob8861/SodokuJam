//
//  GDCBlackBox.swift
//  SodokuJam
//
//  Created by Rob Fazio on 10/16/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import Foundation

func performUIUpdateOnMain(_ updates: @escaping () -> Void)
{
    DispatchQueue.main.async {
        updates()
    }
}

func performBackgroundTask(_ task: @escaping () -> Void)
{
    DispatchQueue.global(qos: .background).async {
        task()
    }
}
