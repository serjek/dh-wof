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
Custom values are coming from cookie "config" that is stringified JSON of `Array<{name:String, chance:Int}>` where chance value is recommended between 0 and 100. Note, it is not exact percentage of win but used to compute relative win probability for every participant (see `WOFModel.rollItem` for implementation):

```js
document.cookie = 'config=[{"name": "Mr. White", "chance": 1},{"name": "Mr. Orange", "chance": 50},{"name": "Mr. Blonde", "chance": 50},{"name": "Mr. Pink", "chance": 50},{"name": "Mr. Brown", "chance": 1},{"name": "Mr. Blue", "chance": 20}]'
```


