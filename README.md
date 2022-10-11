Name
====

lua-resty-jsonnet - Lua Jsonnet binding based on LuaJIT FFI

Table of Contents
=================

* [Name](#name)
* [Status](#status)
* [Synopsis](#synopsis)
* [Description](#description)
* [Methods](#methods)
    * [new](#new)
    * [evaluate_snippet](#evaluate_snippet)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Bugs and Patches](#bugs-and-patches)
* [Author](#author)
* [Copyright and License](#copyright-and-license)
* [See Also](#see-also)

Status
======

This library is still under early development.

Synopsis
========

```lua
# nginx.conf

http {
    # you do not need the following line if you are using the
    # OpenResty bundle:
    lua_package_path "/path/to/lua-resty-core/lib/?.lua;/path/to/lua-resty-jsonnet/lib/?.lua;;";

    init_worker_by_lua_block {
        local jsonnet = require "resty.jsonnet"
        jsonnet.init()
    }

    server {
        ...

        location /t {
            content_by_lua_block {
                local jsonnet = require "resty.jsonnet"

                local jsonnet_snippet = '{ x: 1 , y: self.x + 1 } { x: 10 }'
                local res, err = jsonnet:evaluate_snippet("snippet", jsonnet_snippet)
                ngx.say(res)
            }
        }
    }
}
```

Description
===========

This library implements Lua Jsonnet binding based on LuaJIT FFI.

[Back to TOC](#table-of-contents)

Methods
=======

To load this library,

1. you need to specify this library's path in ngx_lua's [lua_package_path](https://github.com/openresty/lua-nginx-module#lua_package_path) directive. For example, `lua_package_path "/path/to/lua-resty-jsonnet/lib/?.lua;;";`.
2. you use `require` to load the library into a local Lua variable:

```lua
    local jsonnet = require "resty.jsonnet"
```

[Back to TOC](#table-of-contents)

init
---
`syntax: jsonnet = jsonnet.init()`

Init a new jsonnet instance which maintains a `JsonnetVm` object internally.

[Back to TOC](#table-of-contents)

evaluate_snippet
----
`syntax: res, err = jsonnet.evaluate_snippet(filename, snippet)`

Evaluate Jsonnet snippets to output json data.

[Back to TOC](#table-of-contents)

For more API information, see [libjsonnet C Header](https://github.com/CertainLach/jrsonnet/blob/master/bindings/c/libjsonnet.h).

Prerequisites
=============

* [LuaJIT](http://luajit.org) 2.0+
* [ngx_lua](https://github.com/openresty/lua-nginx-module) 0.8.10+
* [libjsonnet](https://jsonnet.org) 0.16.0+

[Back to TOC](#table-of-contents)

Installation
============

It is recommended to use [jrsonnet](https://github.com/CertainLach/jrsonnet) to build the `libjsonnet.so` library, which has better performance than the original cpp implementation.

Execute `cargo build --release --lib` in `jrsonnet` repo, copy `libjsonnet.so` to any library search path. (See `man dlopen` for fallback library search paths)

Also, You need to configure the lua_package_path directive to add the path of your lua-resty-jsonnet source tree to ngx_lua's Lua module search path, as in

```conf
    # nginx.conf
    http {
        lua_package_path "/path/to/lua-resty-jsonnet/lib/?.lua;;";
        ...
    }
```

and then load the library in Lua:

```lua
    local jsonnet = require "resty.jsonnet"
```

[Back to TOC](#table-of-contents)

Bugs and Patches
================

Please report bugs or submit patches by creating a ticket on the [GitHub Issue Tracker](https://github.com/openresty/lua-resty-jsonnet/issues).

[Back to TOC](#table-of-contents)

Author
======

2EXP

[Back to TOC](#table-of-contents)

Copyright and License
=====================

This module is licensed under the Apache v2.0 license.

[Back to TOC](#table-of-contents)

See Also
========

* OpenResty: https://openresty.org
* Jsonnet: https://jsonnet.org
* jrsonnet: https://github.com/CertainLach/jrsonnet

[Back to TOC](#table-of-contents)
