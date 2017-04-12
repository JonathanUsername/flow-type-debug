# flow-type-debug
EXTREMELY basic and hacky script to help debug flow types. It takes a filepath fragment, a line no. and a column no., and outputs the inferred type and the context of where that type was defined in that file.
Basically does what your IDE should already do.

![Gif of it working](https://cloud.githubusercontent.com/assets/7237525/24968169/50cdf328-1fa4-11e7-9388-df3b89ad5a52.gif)

## Installation
It's just a bash script, so you can alias it or put it on your PATH.

You might also need some dependencies, if you don't already have them, like [jq](https://stedolan.github.io/jq/).

It also assumes you have your flow bin under `node_modules/.bin/flow`

## Usage:
```
flow-type-debug [file regex] [line number] [column number]"
```
## Output:
```
Type:

number

Defined at shared/redux/reducers/player.js:43:15
    playInfo: string,
    dashUrl: string | null,
    cloudcastId: string,
    tracking: AnyTracking[],
    duration: number,
    position: number,
    seekRestriction: string | null
};

type QueueState = {
    items: QueueItemState[],
```


