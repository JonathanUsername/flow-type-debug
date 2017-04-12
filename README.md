# flow-type-debug
Simple script to help debug flow types

![Gif of it working](https://cloud.githubusercontent.com/assets/7237525/24968169/50cdf328-1fa4-11e7-9388-df3b89ad5a52.gif)

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


