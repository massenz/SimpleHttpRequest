# SimpleHttpRequest

* c++11 http client based on libuv, http-parser and openssl
* a single header file
* http/https supports

## Usage
### .get , .post , .put , .del
```cpp
#include <iostream>
#include "SimpleHttpRequest.hpp"

using namespace std;
using namespace request;

int main() {
  SimpleHttpRequest request;
  request.get("http://www.google.com")
  .on("error", [](Error&& err){
    cerr << err.name << endl << err.message << endl;
  }).on("response", [](Response&& res){
    cout << res.str();
  }).end();

  return 0;
}
```
```cpp
string body = "{\"hello\": \"world\"}";
SimpleHttpRequest request;
request.setHeader("content-type","application/json")
.post("http://example.org:8080/", body)
.on("error", [](Error&& err){
  cerr << err.name << endl << err.message << endl;
}).on("response", [](Response&& res){
  cout << endl << res.statusCode << endl;
  cout << res.str() << endl;
})
.end();
```

## with options, setHeader
```cpp
uv_loop = uv_default_loop();

map<string, string> options = {
  { "hostname", "google.com" },
  { "port"    , "80"         },
//{ "protocol", "https:"     },
  { "path"    , "/"          },
  { "method"  , "GET"        }
};

SimpleHttpRequest request(options, uv_loop);
request.setHeader("content-type","application/json")
.on("error", [](Error&& err){
  cerr << err.name << endl << err.message << endl;
}).on("response", [](Response&& res){
  for (const auto &kv : res.headers)
    cout << kv.first << " : " << kv.second << endl;

  cout << res.str();
}).end();

return uv_run(uv_loop, UV_RUN_DEFAULT);
```

## with options, headers, timeout
```cpp
uv_loop = uv_default_loop();

map<string, string> options;
map<string, string> headers;
options["hostname"] = "example.org";
options["port"] = "80";
//options["protocol"] = "https:";
options["path"] = "/";
options["method"] = "POST";
headers["content-type"] = "application/json";

SimpleHttpRequest request(options, headers, uv_loop);
request.timeout = 1000;
request.on("error", [](Error&& err){
  cerr << err.name << endl << err.message << endl;
});
request.on("response", [](Response&& res){
  cout << endl << res.statusCode << endl;
  cout << res.str() << endl;
});
request.write("{\"hello\":42}");
request.end();

return uv_run(uv_loop, UV_RUN_DEFAULT);
```


## build & test

### Using CMake & Conan package

See [conan.io](http://conan.io) for more details; the TL;dr is `pip install conan`.

The easiest way is to just use the `build.sh` script; however, the build can be also run manually via:

```bash
mkdir build && cd build
conan install .. -s compiler=clang -s compiler.version=4.0 \
    -s compiler.libcxx=libstdc++11 --build=missing

cmake .. && cmake --build .
```

#### Building `node-gyp`

For reasons that are not entirely clear, when building `http-parser`, it requires the `node-gyp` library, and this will fail with [a cryptic error](https://github.com/nodejs/node-gyp/issues/569):


```
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance
```

The solution is to execute:

`sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`

and once the build is complete, reset the value to:

`sudo xcode-select -s /Library/Developer/CommandLineTools`

otherwise, building sources will fail with errors such as:

```
/Library/Developer/CommandLineTools/usr/include/c++/v1/wchar.h:137:77: error: use of undeclared identifier
      'wcschr'
wchar_t* __libcpp_wcschr(const wchar_t* __s, wchar_t __c) {return (wchar_t*)wcschr(__s, __c);}
```

`TODO: install step in CMake & detailed instruction how to use this in a C++ project`

### example.cpp - https

ENABLE_SSL macro (about 2.5MB will be added or $ strip a.out )

```bash
$ g++ example.cpp --std=c++11 \
  -I./http-parser/ -I./libuv/include/ -I./openssl/include/ \
  ./libuv/.libs/libuv.a \
  ./http-parser/http_parser.o \
  ./openssl/libssl.a ./openssl/libcrypto.a \
  -lpthread -ldl \
  -DENABLE_SSL \
  && DEBUG=* ./a.out https://www.google.com
```


# License

MIT
