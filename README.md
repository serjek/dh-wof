# dh-wof

## To build
```bash
yarn
yarn lix download
haxe build.hxml
```

## To run locally
```bash
yarn parcel bin/index.html
```

## Set values
Custom values are coming from query string that is encoded `Array<{name:String, chance:Int}>` where chance value is recommended between 0 and 100. Note, it is not exact percentage of win but used to compute relative win probability for every participant (see `WOFModel.rollItem` for implementation):

```
?a[0].chance=1&a[0].name=Mr.%20White&a[1].chance=50&a[1].name=Mr.%20Orange&a[2].chance=50&a[2].name=Mr.%20Blonde&a[3].chance=50&a[3].name=Mr.%20Pink&a[4].chance=1&a[4].name=Mr.%20Brown&a[5].chance=50&a[5].name=Mr.%20Blue
```