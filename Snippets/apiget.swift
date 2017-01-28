---
title: "API Access GET"
summary: "Boilerplate code for a basic function to GET a resource"
completion-scope: Function or Method
---

func get<#Type#>(<#arguments#>, completion: @escaping (Result<<#Type#>>) -> Void) {
    let endpoint = "<#endpoint#>"
    let parameters: JSONObject = [:]
    request.get(from: endpoint, with: parameters) { result in
        let result = result.map(<#Type#>.init)
        completion(result)
    }
}
