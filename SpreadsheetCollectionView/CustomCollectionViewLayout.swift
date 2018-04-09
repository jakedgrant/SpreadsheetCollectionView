//
//  CustomCollectionViewLayout.swift
//  TwoDimensionalCollectionView
//
//  Created by Jake Grant on 4/7/18.
//  Copyright © 2018 Jake Grant. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    // Used for calculating each cell's CGRect on screen
    // CGRect will define the origin and size of the cell
    let cellHeight = 44.0
    let cellWidth = 100.0
    
    /*
    Dictionary to hold the UICollectionViewLayoutAttributes for
    each cell. The layout attributes will define the cell's size
    and position (x, y, and z index). This is one of the heavier
    parts of the layout. It is suggested to hold onto this data
    after it has been calculated in either a dictionary or data
    store of some kind for smooth performance.
    */
    var cellAttributesDictionary = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
    
    // Defines the size of the area the user can move around in
    // within the collection view.
    var contentSize = CGSize.zero
    
    // Used to determine if data source update has occured
    // Data source is responsible for updating this value.
    var dataSourceDidUpdate = true
    
    override var collectionViewContentSize: CGSize { return self.contentSize }
    
    override func prepare() {
        
        if !dataSourceDidUpdate {
            // determine current content offset
            let xOffset = collectionView!.contentOffset.x
            let yOffset = collectionView!.contentOffset.y
            
            if let sections = collectionView?.numberOfSections, sections > 0 {
                for section in 0..<sections {
                    
                    if let items = collectionView?.numberOfItems(inSection: section), items > 0 {
                        // update all items in first row
                        if section == 0 {
                            for item in 0..<items {
                                
                                // Build index path to get attributes from dictionary
                                let indexPath = NSIndexPath(item: item, section: section)
                                
                                // Update y-position to follow user
                                if let attrs = cellAttributesDictionary[indexPath] {
                                    var frame = attrs.frame
                                    
                                    // update x-position for corner cell
                                    if item == 0 {
                                        frame.origin.x = xOffset
                                    }
                                    
                                    frame.origin.y = yOffset
                                    attrs.frame = frame
                                }
                            }
                        // for other positions only update the x position for the first item
                        } else {
                            let indexPath = NSIndexPath(item: 0, section: section)
                            
                            if let attrs = cellAttributesDictionary[indexPath] {
                                var frame = attrs.frame
                                frame.origin.x = xOffset
                                attrs.frame = frame
                            }
                        }
                    }
                }
            }
            return
        }
        
        dataSourceDidUpdate = false
        
        // loop through sections
        if let sections = collectionView?.numberOfSections, sections > 0 {
            for section in 0..<sections {
                
                // loop through items
                if let items = collectionView?.numberOfItems(inSection: section), items > 0 {
                    for item in 0..<items {
                        
                        // build layout attributes
                        let cellIndex = NSIndexPath(item: item, section: section)
                        var calculatedCellWidth: Double
                        var x: Double
                        if section % 2 == 0 && section != 0 && item != 0 {
                            calculatedCellWidth = cellWidth * 2
                            x = Double(item) * calculatedCellWidth - cellWidth
                        } else {
                            calculatedCellWidth = cellWidth
                            x = Double(item) * calculatedCellWidth
                        }
                        let y = Double(section) * cellHeight
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
                        cellAttributes.frame = CGRect(x: x, y: y, width: calculatedCellWidth, height: cellHeight)
                        
                        // Determine z-index based on cell type
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        cellAttributesDictionary[cellIndex] = cellAttributes
                    }
                }
            }
        }
        
        // Update content size
        let contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * cellWidth
        let contentHeight = Double(collectionView!.numberOfSections) * cellHeight
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cellAttributesDictionary.values {
            if rect.intersects(attribute.frame) {
                layoutAttributes.append(attribute)
            }
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributesDictionary[indexPath as NSIndexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
