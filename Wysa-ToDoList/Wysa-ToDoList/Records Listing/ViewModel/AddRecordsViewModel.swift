//
//  AddRecordsViewModel.swift
//  Wysa-ToDoList
//
//  Created by Sarthak Taneja on 21/06/21.
//

import Foundation

struct AddRecordsViewModel {
    
    func validation(title: String, date: String) -> (isValid: Bool, errMessage: String) {
        if title == "" {
            return (false, titleEmptyErrMsg)
        } else if date == "" {
            return (false, dateEmptyErrMsg)
        }
        
        return (true, "")
    }
}
