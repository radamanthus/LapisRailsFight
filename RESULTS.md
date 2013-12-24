On my local, I modified my OpenResty Nginx config to also proxy to Unicorn. I did rough performance testing using ApacheBench.

OSX Local tests:

Lapis: 256.29 req/s
Rails/Unicorn: 104.72 req/s

Engine Yard test:
Rails/Unicorn/Nginx 1.2.9: 108.19 req/s
Rails/Unicorn/Nginx 1.4.4: 102.68 req/s
Lapis: (Dog ate my homework. I lost my notes on this, but performance is roughly equal to Rails/Unicorn. Maybe the test isn't stressing the stack enough and the network was the bottleneck on the particular test I ran?)


```
$ ab -n 1000 -c 100 http://127.0.0.1:8080/games/1
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        ngx_openresty/1.4.3.9
Server Hostname:        127.0.0.1
Server Port:            8080

Document Path:          /games/1
Document Length:        342 bytes

Concurrency Level:      100
Time taken for tests:   3.902 seconds
Complete requests:      1000
Failed requests:        1
   (Connect: 0, Receive: 0, Length: 1, Exceptions: 0)
Write errors:           0
Non-2xx responses:      1
Total transferred:      495260 bytes
HTML transferred:       343240 bytes
Requests per second:    256.29 [#/sec] (mean)
Time per request:       390.188 [ms] (mean)
Time per request:       3.902 [ms] (mean, across all concurrent requests)
Transfer rate:          123.95 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.8      0      13
Processing:    79  372  94.9    385     644
Waiting:       78  372  95.3    385     644
Total:         79  373  94.9    386     645

Percentage of the requests served within a certain time (ms)
  50%    386
  66%    417
  75%    433
  80%    464
  90%    486
  95%    495
  98%    531
  99%    540
 100%    645 (longest request)
 ```
 
 ```
 Nginx + Unicorn + Rails:

$ ab -n 1000 -c 100 http://127.0.0.1:9000/games/1
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        ngx_openresty/1.4.3.9
Server Hostname:        127.0.0.1
Server Port:            9000

Document Path:          /games/1
Document Length:        253 bytes

Concurrency Level:      100
Time taken for tests:   9.549 seconds
Complete requests:      1000
Failed requests:        0
Write errors:           0
Total transferred:      751000 bytes
HTML transferred:       253000 bytes
Requests per second:    104.72 [#/sec] (mean)
Time per request:       954.899 [ms] (mean)
Time per request:       9.549 [ms] (mean, across all concurrent requests)
Transfer rate:          76.80 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.4      0       6
Processing:    17  906 161.6    950     995
Waiting:       17  906 161.6    950     995
Total:         22  907 160.3    950     995

Percentage of the requests served within a certain time (ms)
  50%    950
  66%    957
  75%    959
  80%    960
  90%    970
  95%    975
  98%    988
  99%    991
 100%    995 (longest request)
```

```
$ ab -n 1000 -c 100 http://ec2-54-204-17-31.compute-1.amazonaws.com/games/1
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking ec2-54-204-17-31.compute-1.amazonaws.com (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        nginx/1.2.9
Server Hostname:        ec2-54-204-17-31.compute-1.amazonaws.com
Server Port:            80

Document Path:          /games/1
Document Length:        259 bytes

Concurrency Level:      100
Time taken for tests:   9.243 seconds
Complete requests:      1000
Failed requests:        0
Write errors:           0
Total transferred:      748494 bytes
HTML transferred:       259518 bytes
Requests per second:    108.19 [#/sec] (mean)
Time per request:       924.333 [ms] (mean)
Time per request:       9.243 [ms] (mean, across all concurrent requests)
Transfer rate:          79.08 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      245  390 536.0    259    3596
Processing:   253  443 643.4    272    6981
Waiting:      253  428 598.2    271    6979
Total:        502  833 885.8    533    7728

Percentage of the requests served within a certain time (ms)
  50%    533
  66%    541
  75%    551
  80%    564
  90%   1656
  95%   2731
  98%   4184
  99%   4914
 100%   7728 (longest request)
 ```
 

```
$ ab -n 1000 -c 100 http://ec2-54-204-17-31.compute-1.amazonaws.com/games/1
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking ec2-54-204-17-31.compute-1.amazonaws.com (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        nginx/1.4.4
Server Hostname:        ec2-54-204-17-31.compute-1.amazonaws.com
Server Port:            80

Document Path:          /games/1
Document Length:        259 bytes

Concurrency Level:      100
Time taken for tests:   9.739 seconds
Complete requests:      1000
Failed requests:        0
Write errors:           0
Total transferred:      748494 bytes
HTML transferred:       259518 bytes
Requests per second:    102.68 [#/sec] (mean)
Time per request:       973.933 [ms] (mean)
Time per request:       9.739 [ms] (mean, across all concurrent requests)
Transfer rate:          75.05 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      246  420 579.5    262    3857
Processing:   256  479 606.6    275    6902
Waiting:      255  474 600.2    274    6902
Total:        508  899 908.8    540    9385

Percentage of the requests served within a certain time (ms)
  50%    540
  66%    552
  75%    576
  80%    777
  90%   1678
  95%   2848
  98%   3892
  99%   4719
 100%   9385 (longest request)
```
