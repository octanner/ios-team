---
title: "Reactor State"
summary: "Boilerplate code for a basic Reactor State"
completion-scope: Class Implementation
---

struct <#State#>: Reactor.State {

    <#properties#>

    mutating func react(to event: Reactor.Event) {
        switch event {
        case let event as <#Event#>:
            <#code#>
        default:
            break
        }
    }

}
