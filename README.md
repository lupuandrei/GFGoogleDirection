# GFGoogleDirection
Vapor. *The Directions API is a service that calculates directions between locations using an HTTP request.*. [Google Documentation](https://developers.google.com/maps/documentation/directions/start)

## Requirements
1. Vapor 3. [Documentation](https://docs.vapor.codes/3.0/)

## Usage
```
import Vapor
import GFGoogleDirection

final class MyController: RouteCollection {
  func boot(router: Router) throws {
  let apiRequest = router.grouped("api", "direction")
  apiRequest.get(use: calculate)
  }


  func calculate(_ req: Request) throws -> Future<GoogleDirectionResponse.Readable> {
    let request = GoogleDirectionRequest(startLatitude: 44.252, startLongitude: 23.655922, endLatitude: 44.344678, endLongitude: 23.914788)
    
    let googleDirectionService = try req.make(GFGoogleDirection.self)
    return googleDirectionService.request(client: try! req.client(), request: request).map({ (googleResponse) in
      return googleResponse
    }).map({ (response) in
      return try response.convertToReadable()
    })
  }
}


```

### JSON RESPONSE:
```
{
"startAddress": "Bucovăț, Romania",
"distance": 29785,
"endLocation": {
"lat": 44.3492842,
"lng": 23.9142424
},
"duration": 2276,
"endAddress": "Ghercești, Romania",
"waypoints": [
{
"place_id": "ChIJn4uzvp4nU0cRzIiRDYRMo_E",
"types": [
"administrative_area_level_2",
"political"
],
"geocoder_status": "OK"
},
{
"place_id": "ChIJ9_3YjkHRUkcR9QYBTrkPolU",
"types": [
"administrative_area_level_2",
"political"
],
"geocoder_status": "OK"
}
],
"polyline": "mpamGasgoCc@fGa@zCi@tDCr@q@Bs@AoAW]MoA_A_AkAkDwEa@UcFqAsO}DkJiCyOkEuCaAyAq@cCoA_KaGkDoCcF{DgBaB{K{LsJeKgCqCcBwB{B}CuDiEqEgFcEsEyBuCkF}IkLsSyD_HcBkCkGsJeDeFsCoE{BwEyIgQ_C}EcA{A?iDI}@yA{KyDiYIyA@y@lAwLxGsp@jCwVNgB@y@CiA{Cya@oFmt@gCe^{@uI{LclAiAiK{AyKa@eAwAgBYy@?{@Tm@VOTEx@KTMPQJ_@Aa@I_@e@[g@?w@Jm@D[CSIQWIk@H_@HQRO`@OxAMb@Mx@_@x@m@bAs@X]L]@_@I[IGUGSBk@X{@t@_@Xi@ROCOKIQCSDc@N]tAcApA{@\\M\\E^?v@@RGPSFUAa@S_@_ASaCW{Ba@uAo@aAaAeA}A{BqFyAyDm@gAy@}AKg@Be@FSt@y@~DmE`@u@h@eBN{BC}CQgB{@uCS_@_@qByEgNkCaIaB}Ek@sA_AqAmNwK}EwDaAm@u@e@qAmA}HsJeFuGgE}EwRiVwHeKs@kAg@sAcJ}ZoCkHkGyKeB}DaAwBgImMkAgBaCmBoAiA}BoC}FaJESE{@QwFAcAJiABw@OsBKiF@wADe@BoDAkAYqEA_AZsJH}@C}ADQBe@Kc@WOS@KAKQ_@uAk@yBs@{Es@gDcA_DeC}HcC_IgBsGaAkEi@qDeAwLQgB@[BKoBwIEq@BOFSEWQI_@e@a@gA@WIWWGOJCHm@EoF{DoEkCqFoCwDeBsAq@@{AMcCSsB]wBy@cDYiBWaDKcCBwINaO?eAGe@cAoBeCmEuDuGw@yBiA}DcAqCiAuC\\_@bEaGLWBc@Ae@c@{Di@mE{@sI}BcVEiBBAFEDIDUCUIOc@mAs@oNQuESwCSe@yA{@iAs@KUKm@Bq@H[fAwBxAsCHy@OoEMqCIq@{@cEUgBCa@FgBT}FaBsJ_D_PqB_JgAqDoLcY}CsHmCeH{EiLg@mA}JaVw@sBU_CSwDMaAaBsEoBaFkD}HiDsIaDyHoDaJ_C_GmC_Ho@wTSyEIu@Ww@g@y@oA}AkBqBsDiE~BuBnAqAjA{AtFuHjAcBfBkDnCwEvByCfDkEp@i@t@KzHgA|@G~ADhBXPC\\YFq@kGkJsBkCq@aAuAuCeBoDk@uAEi@DgBZcF?q@IqDq@wIGiC",
"startLocation": {
"lat": 44.2498258,
"lng": 23.637132
}
}
```

## Setup

### Add as dependency
Add `GFGoogleDirection` as a dependency in your `Package.swift` file:

```
dependencies: [
...,
.package(url: "https://github.com/lupuandrei/GFGoogleDirection.git", from: "0.0.1"),
]
```

### Register GFCommunication as service
`configure.swif`
```
services.register(GFGoogleDirection(apiKey: "GOOGLE-API-KEY"))

````
