# Dynamic Dependencies

All apps which rely on network services of any kind have dependencies on the exact manner that these services operate. These remote resources are what I call _dynamic dependencies_. They can change independent from an app change.

## Versioning

A client app has exactly one concern when dealing with a network resource: am I compatible with this resource? If the app is compatible, it may be correctly used with the API or remote database or service. If it is not, then the user must update the app. It's that simple.

Because we care *only* about compatibility, we use [ComVer](https://github.com/staltz/comver) when declaring our app's required version of a dynamic dependency. Compatibility has two sides to it: 1) Are the features I require available in this API, and 2) Do those features still operate in the way I expect? Those two sides are managed by enforcing a _minimum MINOR version_ and an _exact MAJOR version_ (respectively).

## Dependencies Within an App

An app often has multiple dynamic dependencies. Each should be named and a ComVer number assigned which declares the exact major and minimum minor version required by that release of the app.

Also, because new features may be added on every minor release of an API or other dynamic resource, and it's very easy to start consuming those new features without remembering to bump the version number of the dependency. To ensure an adequate minimum minor version number, we query the dynamic resource at build-time and use the returned version number as the ComVer number that the app requires of that resource. This ensures that all the features required by the app are present in the API, and also ensures that we force an upgrade only when a backwards-incompatible version is found.

## Communicating Expected and Actual Versions

The way to check and communicate compatibility varies with the nature of the dynamic resource.

### Raw HTTP APIs

HTTP APIs may be upgraded at any point in between requests—even allowing for parallel requests to perhaps be serviced by different versions of the API as a rollout is in progress. It is then best for the API to declare its actual version in an HTTP header on every response. We reject approaches that version media types, since media types should be broadly applicable and not change when the schema for a particular resource changes.

For state-preserving requests (e.g. GET, HEAD), we use `X-Accept-Compatible-Version` in requests and `X-Compatible-Version` in responses to communicate accepted versions. Servers SHOULD return a `406 Not Acceptable` when they are not compatible with the accepted version.

For state-changing requests (e.g. POST, PUT, DELETE) we use `X-If-Compatible-Version` in requests and `X-Compatible-Version` in responses to communicate the server version. Servers SHOULD return a `412 Precondition Failed` response when they are not compatible.

### GraphQL

GraphQL is interesting in that it [generally requires no versioning](http://graphql.org/learn/best-practices/#versioning). It can do this because of two features of such an API: 1) everything is nullable, so the client must be prepared for data to simply go missing, and 2) it gives the client the tools to assemble the shape of the data so they never have an incompatible response structure. This makes GraphQL clients immune to both removed data and features missing (whether not yet deployed or deprecated ones removed). While the client apps would not crash under those conditions, they become semantically less valuable. If suddenly all comments on all restaurants are removed, it would be beneficial to recommend an app to update to the user so that the UI and features displayed most accurately reflect current features of the API. Therefore, even these APIs should have a mechanism to detect this and prompt the user to update the app.

We end up wanting to know the same basic questions: 1) Are the features I require available in this API, and 2) Do those features still operate in the way I expect? This leads us to the same approach as HTTP APIs, sending and receiving headers to indicate features added and removed. In this case, though, we'd expect GraphQL servers to increment the MAJOR version very rarely: only in cases where mutations are no longer supported or when important categories of data have been entirely and permanently removed with no mapping to substitutions.

### SDK Managed APIs

When using services like Facebook which provide an SDK that in turn makes all the API calls, refer to the SDK instructions for detecting when the SDK compiled into the app is no longer compatible with the currently offered API versions. Generally, SDK versions should be updated regularly to ensure compatibility between recent app versions and available API versions.

### Firebase & Realm

Firebase & Realm are two examples of remote databases where the networking layers are built into the SDKs, but where the data structure is actually defined by the app using it.  Because these techniques usually have little or no server-side components, there aren't ways to keep to equivalent-but-not-identical data structures in sync. New versions _could_ choose to write both formats, this implies that older versions can _read_ the data but should not _write_ the data.

_TODO: finish defining versioning strategy_
