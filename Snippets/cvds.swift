---
title: "UICollectionViewDataSource"
summary: "Placeholders for required UICollectionViewDataSource protocol methods"
completion-scope: Class Implementation
---

extension <#Class#>: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return <#count#>
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return <#count#>
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: <#CellIdentifier#>, for: indexPath) as <#CellType#>
        <#code#>
        return cell
    }

}
