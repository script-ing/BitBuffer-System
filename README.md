# BitBuffer System

A high-performance bit-level serialization and data persistence module for Lua environments.

## Features
- Compact binary encoding via BitBuffer
- CSV import/export utilities
- Persistent data service layer
- Streaming read/write with overflow protection

## Modules

| File | Description |
|------|-------------|
| `bitbuffer.lua` | Core bit-packing and unpacking engine |
| `csv.lua` | Lightweight CSV parser and serializer |
| `dataservice.lua` | High-level data management service |
| `persistence.lua` | Save/load persistence layer |

## Usage

```lua
local BitBuffer = require("bitbuffer")
local buf = BitBuffer.new()
buf:writeInt(42, 8)
print(buf:readInt(8)) -- 42
```

## License
MIT
