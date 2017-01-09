---
title: "UITableViewDataSource"
summary: "Placeholders for required UITableViewDataSource delegate methods"
platform: iOS
completion-scope: Class Implementation
---

extension <#Class#> : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        <#code#>
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }

}
