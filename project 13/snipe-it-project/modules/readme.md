cidrsubnet function
random shuffle
iam instance profile


```sh
 Error: Invalid index
│ 
│   on subnet.tf line 14, in resource "aws_subnet" "snipe-it-public-subnet":
│   14:   availability_zone = length(data.aws_availability_zones.az[count.index])
│     ├────────────────
│     │ count.index is 0
│     │ data.aws_availability_zones.az is object with 10 attributes
│ 
│ The given key does not identify an element in this collection value. An object only supports looking up attributes by name, not by numeric index.
╵
╷
```

Got this error in reference with this code

```sh
data "aws_availability_zones" "az" {
  state = "available"
}
```