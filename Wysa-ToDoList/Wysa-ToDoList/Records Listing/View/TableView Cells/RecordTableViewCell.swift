//
//  RecordTableViewCell.swift
//  Wysa-ToDoList
//
//  Created by Sarthak Taneja on 21/06/21.
//

import UIKit

protocol CheckBoxTap {
    func checkBoxTapped(isSelected: Bool, item: ListRecord)
}

class RecordTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    // Public Properties
    var delegate: CheckBoxTap?
    var isRecordSelected = false
    var currentRecord: ListRecord?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(record: ListRecord) {
        currentRecord = record
        taskTitleLabel.text = record.name
        dateAndTimeLabel.text = record.dateAndTime
        checkBoxBtn.isSelected = record.isRecordSelected
    }
    
    // MARK: - IBActions
    @IBAction func checkBoxTapped() {
        isRecordSelected = !isRecordSelected
        checkBoxBtn.isSelected = isRecordSelected
        
        delegate?.checkBoxTapped(isSelected: isRecordSelected, item: currentRecord ?? ListRecord())
    }
}
