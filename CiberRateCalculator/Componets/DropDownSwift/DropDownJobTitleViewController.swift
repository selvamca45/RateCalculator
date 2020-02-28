//
//  DropDownJobTitleViewController.swift
//  CiberRateCalculator
//
//  Created by aneesf on 22/10/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//

import UIKit

class DropDownJobTitleViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var dropDownListView: UITableView!
    @IBOutlet var dropDownSearchBar: UISearchBar!
    
    var dropdownDelegate : HTCDropDownDelegate?
    //Model Array Type
    var modelListArray : Array<HTCDropDownModel> = []
    var filteredModelArray : Array<HTCDropDownModel> = []
    var selectedModelIdArray : Array<HTCDropDownModel> = []
    var selectedIndex  : Int = -1
    var searchActive : Bool = false
    //Pop List Type
    var dropDownType : DropDownType1 = DropDownType1.DropDownTypeSingleSelectionWithImage
    
    
    //Change font
    var textFont : UIFont = UIFont.systemFont(ofSize: 16.0)
    
    //Font Color
    var textColor : UIColor = UIColor.blue
    
    //Background Color
    var backgroundColor : UIColor = UIColor.white
    
    //Selection image for multiple selection
    var selectionIcon : String = "radio_selected.png"
    var defaultIcon : String = "radio_default.png"
    
    //Search bar appears count
    var allowSearching : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nib = UINib(nibName: "HTCDropDownCell", bundle: nil)
//        dropDownListView.register(nib, forCellReuseIdentifier: "DropDownCell")
        let nib = UINib(nibName: "DropDownJobTitleCellTableViewCell", bundle: nil)
        dropDownListView.register(nib, forCellReuseIdentifier: "DropDownJobTitleCellTableViewCell")
        // Do any additional setup after loading the view.
        
    }
    
    @objc func selectPreviousSelection() {
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        dropDownListView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dropDownListView.delegate = self
        dropDownListView.dataSource = self
        dropDownListView.reloadData()
        if selectedIndex >= 0 {
            self.perform(#selector(self.selectPreviousSelection), with: nil, afterDelay: 0.2)
        }
    }
    
    
    // MARK: - Button Action
    
    func  doneButtonClicked(){
        if(selectedModelIdArray.count == 0) {
            let alert = UIAlertController(title: "", message: "Please select a job title to proceed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        dropdownDelegate?.dropDownClicked(selectedArr: selectedModelIdArray)
        //        dropdownDelegate?.dropDownClickedWhenMultipleSelection(passedArr: modelListArray, selectedArr: selectedModelIdArray)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive) {
            return filteredModelArray.count
        }
        return (modelListArray.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
//        var cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! HTCDropDownCell
//        if cell == nil {
//            cell = HTCDropDownCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DropDownCell")
//        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "DropDownJobTitleCellTableViewCell", for: indexPath) as! DropDownJobTitleCellTableViewCell
        if cell == nil {
            cell = DropDownJobTitleCellTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DropDownJobTitleCellTableViewCell")
        }
        cell.singleSelectionLabel?.font = textFont
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //cell.singleSelectionLabel?.font = textFont
        
        
        cell.contentView.backgroundColor = backgroundColor
        //cell.singleSelectionLabel?.textColor = textColor
        
        switch dropDownType {
        case .DropDownTypeSingleSelection:
            // cell.singleSelectionLabel.isHidden = false
            if(searchActive == true && filteredModelArray.count > 0){
                let modelObj : HTCDropDownModel = filteredModelArray[indexPath.row]
                //cell.singleSelectionLabel?.text = modelObj.modelData
                //cell.descriptionLabel.text = modelObj.cityString
                
            } else {
                let modelObj : HTCDropDownModel = modelListArray[indexPath.row]
                // cell.singleSelectionLabel?.text = modelObj.modelData
                //cell.descriptionLabel.text = modelObj.cityString
            }
            break
            
        case .DropDownTypeSingleSelectionWithImage:

            //cell.singleSelectionLabel.isHidden = true
            if(searchActive == true && filteredModelArray.count > 0){
                let modelObj : HTCDropDownModel = filteredModelArray[indexPath.row]
                cell.singleSelectionLabel?.text = modelObj.modelData
                //                    cell.dropDownImageView?.image = UIImage.init(contentsOfFile: modelObj.modelImgPath)
//                cell.dropDownImageView?.image = UIImage.init(named: modelObj.modelImgPath)
//                cell.descriptionLabel.text = modelObj.cityString
            } else {
                let modelObj : HTCDropDownModel = modelListArray[indexPath.row]
                cell.singleSelectionLabel?.text = modelObj.modelData
                //                    cell.dropDownImageView?.image = UIImage.init(contentsOfFile: modelObj.modelImgPath)
//                cell.dropDownImageView?.image = UIImage.init(named: modelObj.modelImgPath)
//                cell.descriptionLabel.text = modelObj.cityString
            }
            break
            
        case .DropDownTypeMultipleSelection:
            //cell.selectionView.isHidden = false
            //cell.singleSelectionLabel.isHidden = true
            
            var modelObj : HTCDropDownModel?
            if(searchActive == true && filteredModelArray.count > 0){
                modelObj = filteredModelArray[indexPath.row]
//                cell.dropDownLabel?.text = modelObj?.modelData
//                cell.descriptionLabel.text = modelObj?.cityString
                
            } else {
                modelObj = modelListArray[indexPath.row]
                //cell.dropDownLabel?.text = modelObj?.modelData
                //cell.descriptionLabel.text = modelObj?.cityString
            }
            if (selectedModelIdArray.count > 0) {
                if (selectedModelIdArray .contains(modelObj!)) {
                   // cell.dropDownImageView?.image = UIImage.init(named: selectionIcon)
                }
                else
                {
                   // cell.dropDownImageView?.image = UIImage.init(named: defaultIcon)
                }
            }
            else
            {
                //cell.dropDownImageView?.image = UIImage.init(named: defaultIcon)
            }
            
            break
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.doneButtonPressed()
    }
    
    
    @IBAction func doneButtonPressed()  {
        var modelObj : HTCDropDownModel?
        if(selectedIndex < 0) {
            let alert = UIAlertController(title: "", message: "Please select a job title to proceed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        switch dropDownType {
        case .DropDownTypeSingleSelectionWithImage:
            if(searchActive == true && filteredModelArray.count > 0) {
                modelObj = filteredModelArray[selectedIndex]
                var selectedDataArr : Array<HTCDropDownModel> = []
                selectedDataArr.insert(modelObj!, at: 0)
                dropdownDelegate?.dropDownClicked(selectedArr: selectedDataArr)
                //                    dropdownDelegate?.dropDownClicked1(selectedArr: filteredModelArray, selectedIndex: indexPath.row, selectedTitle: (modelObj?.modelData)!)
            }
            else{
                modelObj = modelListArray[selectedIndex]
                var selectedDataArr : Array<HTCDropDownModel> = []
                selectedDataArr.insert(modelObj!, at: 0)
                dropdownDelegate?.dropDownClicked(selectedArr: selectedDataArr)
                //                    dropdownDelegate?.dropDownClicked1(selectedArr: modelListArray, selectedIndex: indexPath.row, selectedTitle: (modelObj?.modelData)!)
            }
            break
            
        case .DropDownTypeSingleSelection:
            if(searchActive == true && filteredModelArray.count > 0) {
                modelObj = filteredModelArray[selectedIndex]
                var selectedDataArr : Array<HTCDropDownModel> = []
                selectedDataArr.insert(modelObj!, at: 0)
                dropdownDelegate?.dropDownClicked(selectedArr: selectedDataArr)
                //                    dropdownDelegate?.dropDownClicked1(selectedArr: filteredModelArray, selectedIndex: indexPath.row, selectedTitle: (modelObj?.modelData)!)
            }
            else{
                modelObj = modelListArray[selectedIndex]
                var selectedDataArr : Array<HTCDropDownModel> = []
                selectedDataArr.insert(modelObj!, at: 0)
                dropdownDelegate?.dropDownClicked(selectedArr: selectedDataArr)
                //                    dropdownDelegate?.dropDownClicked1(selectedArr: modelListArray, selectedIndex: indexPath.row, selectedTitle: (modelObj?.modelData)!)
            }
            break
            
        case .DropDownTypeMultipleSelection:
            if(searchActive == true && filteredModelArray.count > 0) {
                modelObj = filteredModelArray[selectedIndex]
            }
            else{
                modelObj = modelListArray[selectedIndex]
            }
            if (selectedModelIdArray.contains(modelObj!)){
                
                if let index = selectedModelIdArray.index(of:modelObj!) {
                    selectedModelIdArray.remove(at: index)
                }
            }
            else{
                selectedModelIdArray.insert(modelObj!, at: selectedModelIdArray.count)
                
            }
            dropDownListView.reloadData()
            break
            
        }
        
        //dropDownSearchBar.text = nil
        //        dismiss(animated: true, completion: {})
    }
    
    // MARK: - Search Text
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchActive = false;
        dropDownSearchBar.text = nil
        filteredModelArray.removeAll()
        dropDownSearchBar.resignFirstResponder()
        dropDownListView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            searchActive = false;
            filteredModelArray.removeAll()
            // dropDownSearchBar.resignFirstResponder()
        }
        else{
            
            filteredModelArray = modelListArray.filter({(text) -> Bool in
                let tmp : NSString = text.modelData as NSString
                let range = tmp.range(of: searchText, options:NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            if(filteredModelArray.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
        }
        
        dropDownListView.reloadData()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
