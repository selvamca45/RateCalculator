//
//  DropDownViewController.swift
//  DropDownController
//
//  Created by Vishnu on 15/10/19.
//  Copyright © 2019 Vishnu. All rights reserved.
//

import UIKit
enum DropDownType1{
    case DropDownTypeSingleSelection
    case DropDownTypeSingleSelectionWithImage
    case DropDownTypeMultipleSelection
}
protocol HTCDropDownDelegate {
    func dropDownClicked(selectedArr : Array<HTCDropDownModel>)
}


class DropDownViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var dropDownListView: UITableView!
    @IBOutlet var dropDownSearchBar: UISearchBar!
    var dropdownDelegate : HTCDropDownDelegate?
    //Model Array Type
    var modelListArray : Array<HTCDropDownModel> = []
    var filteredModelArray : Array<HTCDropDownModel> = []
    var selectedModelIdArray : Array<HTCDropDownModel> = []
    var selectedIndex  : Int = 0
    var searchActive : Bool = false
    //    var modelType : Bool = false
    //Pop List Type
    var dropDownType : DropDownType1 = DropDownType1.DropDownTypeSingleSelectionWithImage
    
    
    //Change font
    var textFont : UIFont = UIFont.systemFont(ofSize: 16.0)
    
    //Font Color
    var textColor : UIColor = UIColor(red: 76.0/255.0, green: 76.0/255.0, blue: 127.0/255.0, alpha: 1.0)
    
    //Background Color
    var backgroundColor : UIColor = UIColor(red: 204.0/255.0, green: 228.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    
    //Selection image for multiple selection
    var selectionIcon : String = "radio_selected.png"
    var defaultIcon : String = "radio_default.png"
    
    //Search bar appears count
    var allowSearching : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        dropDownSearchBar.showsCancelButton = true
//        dropDownSearchBar.delegate = self
        let nib = UINib(nibName: "HTCDropDownCell", bundle: nil)
        dropDownListView.register(nib, forCellReuseIdentifier: "DropDownCell")
        
    }
    
    @objc func selectPreviousSelection() {
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        dropDownListView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if selectedModelIdArray.count == 0 {
            let alert = UIAlertController(title: "", message: "Please select a area to proceed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        dropdownDelegate?.dropDownClicked(selectedArr: selectedModelIdArray)
        //        dropdownDelegate?.dropDownClickedWhenMultipleSelection(passedArr: modelListArray, selectedArr: selectedModelIdArray)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! HTCDropDownCell
        if cell == nil {
            cell = HTCDropDownCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DropDownCell")
        }
        cell.dropDownLabel?.font = textFont
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        //cell.singleSelectionLabel?.font = textFont
        
        
        //cell.contentView.backgroundColor = backgroundColor
        //cell.selectionView.backgroundColor = backgroundColor
        //cell.dropDownLabel?.textColor = textColor
        //cell.singleSelectionLabel?.textColor = textColor
        
        switch dropDownType {
        case .DropDownTypeSingleSelection:
            cell.selectionView.isHidden = true
           // cell.singleSelectionLabel.isHidden = false
            if(searchActive == true && filteredModelArray.count > 0){
                let modelObj : HTCDropDownModel = filteredModelArray[indexPath.row]
                //cell.singleSelectionLabel?.text = modelObj.modelData
                cell.descriptionLabel.text = modelObj.cityString
                
            } else {
                let modelObj : HTCDropDownModel = modelListArray[indexPath.row]
               // cell.singleSelectionLabel?.text = modelObj.modelData
                cell.descriptionLabel.text = modelObj.cityString
            }
            break
            
        case .DropDownTypeSingleSelectionWithImage:
            cell.selectionView.isHidden = false
            cell.cellOverVeiw.layer.cornerRadius = 5.0
            cell.cellOverVeiw.layer.shadowColor = UIColor.gray.cgColor
            cell.cellOverVeiw.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.cellOverVeiw.layer.shadowRadius = 1.0
            cell.cellOverVeiw.layer.shadowOpacity = 0.5
            //cell.singleSelectionLabel.isHidden = true
            if(searchActive == true && filteredModelArray.count > 0){
                let modelObj : HTCDropDownModel = filteredModelArray[indexPath.row]
                cell.dropDownLabel?.text = modelObj.modelData
                //                    cell.dropDownImageView?.image = UIImage.init(contentsOfFile: modelObj.modelImgPath)
                cell.dropDownImageView?.image = UIImage.init(named: modelObj.modelImgPath)
                cell.descriptionLabel.text = modelObj.cityString
            } else {
                let modelObj : HTCDropDownModel = modelListArray[indexPath.row]
                cell.dropDownLabel?.text = modelObj.modelData
                //                    cell.dropDownImageView?.image = UIImage.init(contentsOfFile: modelObj.modelImgPath)
                cell.dropDownImageView?.image = UIImage.init(named: modelObj.modelImgPath)
                cell.descriptionLabel.text = modelObj.cityString
            }
            break
            
        case .DropDownTypeMultipleSelection:
            cell.selectionView.isHidden = false
            //cell.singleSelectionLabel.isHidden = true
            
            var modelObj : HTCDropDownModel?
            if(searchActive == true && filteredModelArray.count > 0){
                modelObj = filteredModelArray[indexPath.row]
                cell.dropDownLabel?.text = modelObj?.modelData
                cell.descriptionLabel.text = modelObj?.cityString
                
            } else {
                modelObj = modelListArray[indexPath.row]
                cell.dropDownLabel?.text = modelObj?.modelData
                cell.descriptionLabel.text = modelObj?.cityString
            }
            if (selectedModelIdArray.count > 0) {
                if (selectedModelIdArray .contains(modelObj!)) {
                    cell.dropDownImageView?.image = UIImage.init(named: selectionIcon)
                }
                else
                {
                    cell.dropDownImageView?.image = UIImage.init(named: defaultIcon)
                }
            }
            else
            {
                cell.dropDownImageView?.image = UIImage.init(named: defaultIcon)
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
        
        if(selectedIndex < 0) {
            let alert = UIAlertController(title: "", message: "Please select an area to proceed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        var modelObj : HTCDropDownModel?
        
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
                if modelListArray.count > 0
                {
                modelObj = modelListArray[selectedIndex]
                var selectedDataArr : Array<HTCDropDownModel> = []
                selectedDataArr.insert(modelObj!, at: 0)
                dropdownDelegate?.dropDownClicked(selectedArr: selectedDataArr)
                }
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
        searchActive = false;
        //dropDownSearchBar.text = nil
        filteredModelArray.removeAll()
        //dropDownSearchBar.resignFirstResponder()
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
