## simple http server
[prometheus/jmx_exporter: A process for exposing JMX Beans via HTTP for Prometheus consumption](https://github.com/prometheus/jmx_exporter)

```sh
❯ curl http://localhost:8000/ -d "object Foo { println(1) }"
Source(
  stats = List(
    Defn.Object(
      mods = List(),
      name = Term.Name(value = "Foo"),
      templ = Template(
        early = List(),
        inits = List(),
        self = Self(name = , decltpe = None),
        stats = List(
          Term.Apply(fun = Term.Name(value = "println"), args = List(Lit.Int(value = 1)))
        ),
        derives = List()
      )
    )
  )
)%
```

```sh
❯ curl http://localhost:9999/ | head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 75251  100 75251    0     0 # HELP jmx_exporter_build_info A metric with a constant '1' value labeled with the version of the JMX exporter.
 # TYPE jmx_exporter_build_info gauge
1jmx_exporter_build_info{version="0.17.2",name="jmx_prometheus_javaagent",} 1.0
4# HELP jvm_memory_pool_allocated_bytes_total Total bytes allocated in a given JVM memory pool. Only updated after GC, not continuously.
9# TYPE jvm_memory_pool_allocated_bytes_total counter
3jvm_memory_pool_allocated_bytes_total{pool="CodeHeap 'profiled nmethods'",} 3899648.0
0jvm_memory_pool_allocated_bytes_total{pool="G1 Old Gen",} 8281088.0
 jvm_memory_pool_allocated_bytes_total{pool="G1 Eden Space",} 5.8720256E7
 jvm_memory_pool_allocated_bytes_total{pool="CodeHeap 'non-profiled nmethods'",} 704128.0
 jvm_memory_pool_allocated_bytes_total{pool="G1 Survivor Space",} 4194304.0
   0  0:00:05  0:00:05 --:--:-- 19668
```
