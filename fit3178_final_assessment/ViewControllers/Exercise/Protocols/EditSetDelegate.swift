//
//  EditSetDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 12/5/2023.
//

import Foundation

// delegate responsible for editing a set
protocol editSetDelegate {
    func updateSetAtRow(indexPath: IndexPath, updatedSet: ExerciseSetStruct)
}
