//
//  ColorPickerViewController.swift
//  SwiftColorPicker
//
//  Created by Prashant on 02/09/15.
//  Copyright (c) 2015 PrashantKumar Mangukiya. All rights reserved.
//

import UIKit


// define delegate protocol function
protocol ColorPickerDelegate {
    
    // return selected color as UIColor and Hex string
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String)
}


class ColorPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    // create color picker delegate
    var colorPickerDelegate : ColorPickerDelegate?
    
    
    // outlet - colors collection view
    @IBOutlet var colorCollectionView : UICollectionView!
    
    
    // store colors in array (colors will be loaded from Colors.plist)
    // didSet - whenever value set it will refresh collection view.
    var colorList = [String]() {
        didSet {
            self.colorCollectionView.reloadData()
        }
    }
    
    
    
    
    
    // MARK: - View functions
    
    // called after view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set collection view delegate and datasource
        self.colorCollectionView.delegate = self
        self.colorCollectionView.dataSource = self
        
        // load colors from plist file
        self.loadColorList()
    }
    
    
    // called if received memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        // add custom code here for memory warning
    }
    
    
    
    
    
    // MARK: - Collection view Datasource & Delegate functions
    
    // return number of section in collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // return number of cell shown within collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorList.count
    }
    
    
    // create collection view cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // deque reusable cell from collection view.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        
        // set cell background color from given color list
        cell.backgroundColor = self.convertHexToUIColor(hexColor: self.colorList[(indexPath as NSIndexPath).row])
        
        // return cell
        return cell
    }
    
    
    // function - called when clicked on a collection view cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // find clicked color value from colorList (it wil be in hex)
        let clickedHexColor = self.colorList[(indexPath as NSIndexPath).row]
        
        // convert hex color to UI Color
        let clickedUIColor = self.convertHexToUIColor(hexColor: clickedHexColor)
        
        // call delegate function i.e. return selected color
        self.colorPickerDelegate?.colorPickerDidColorSelected(selectedUIColor: clickedUIColor, selectedHexColor: clickedHexColor)
        
        // close color picker view
        self.closeColorPicker()
    }
    
    
    
    
    
    // MARK: - Utility functions
    
    // load colors from Colors.plist and save to colorList array.
    fileprivate func loadColorList(){
        
        // create path for Colors.plist resource file.
        let colorFilePath = Bundle.main.path(forResource: "Colors", ofType: "plist")
        
        // save piist file array content to NSArray object
        let colorNSArray = NSArray(contentsOfFile: colorFilePath!)
        
        // Cast NSArray to string array.
        self.colorList = colorNSArray as! [String]
    }
    
    
    // convert Hex string '#FF00FF' or 'FF00FF' to UIColor object
    fileprivate func convertHexToUIColor(hexColor : String) -> UIColor {
        
        // define character set (include whitespace, newline character etc.)
        let characterSet = CharacterSet.whitespacesAndNewlines as CharacterSet
        
        //trim unnecessary character set from string
        var colorString : String = hexColor.trimmingCharacters(in: characterSet)
        
        // convert to uppercase
        colorString = colorString.uppercased()
        
        //if # found at start then remove it.
        if colorString.hasPrefix("#") {
            colorString =  colorString.substring(from: colorString.characters.index(colorString.startIndex, offsetBy: 1))
        }
        
        // hex color must 6 chars. if invalid character count then return black color.
        if colorString.characters.count != 6 {
            return UIColor.black
        }
        
        // split R,G,B component
        var rgbValue: UInt32 = 0
        Scanner(string:colorString).scanHexInt32(&rgbValue)
        let valueRed    = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let valueGreen  = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let valueBlue   = CGFloat(rgbValue & 0x0000FF) / 255.0
        let valueAlpha  = CGFloat(1.0)
        
        // return UIColor
        return UIColor(red: valueRed, green: valueGreen, blue: valueBlue, alpha: valueAlpha)
    }
    
    
    // close color picker view controller
    fileprivate func closeColorPicker(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

