---
title: "IGListKit Section Pattern"
summary: "Boilerplate for an IGListKit Section and Section Controller"
completion-scope: Top Level
---

import UIKit
import IGListKit

class <#Class#>Section: NSObject, ListDiffable {

    <#Properties#>


    public func diffIdentifier() -> NSObjectProtocol {
        <#Code#>
    }

    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? <#Class#>Section else { return false }
        return <#Code#>
    }

}


class <#Class#>SectionController: ListSectionController {

    var section: <#Class#>Section!
    <#Properties#>

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}


extension <#Class#>SectionController: ListSectionType {

    func numberOfItems() -> Int {
        return <#number#>
    }

    func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        <#Code#>
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        let nibName = "<#NIB name#>"
        let cell = collectionContext!.dequeueReusableCell(withNibName: nibName, bundle: nil, for: self, at: index)

        if let cell = cell as? <#CellType#> {
            <#Cell configuration#>
        }

        return cell
    }

    func didUpdate(to object: Any) {
        section = object as? <#Class#>Section
    }

    func didSelectItem(at index: Int) {
        <#Code#>
    }

}
