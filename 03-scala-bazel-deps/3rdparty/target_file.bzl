# Do not edit. bazel-deps autogenerates this file from.
_JAVA_LIBRARY_TEMPLATE = """
java_library(
  name = "{name}",
  exports = [
      {exports}
  ],
  runtime_deps = [
    {runtime_deps}
  ],
  visibility = [
      "{visibility}"
  ]
)\n"""

_SCALA_IMPORT_TEMPLATE = """
scala_import(
    name = "{name}",
    exports = [
        {exports}
    ],
    jars = [
        {jars}
    ],
    runtime_deps = [
        {runtime_deps}
    ],
    visibility = [
        "{visibility}"
    ]
)
"""

_SCALA_LIBRARY_TEMPLATE = """
scala_library(
    name = "{name}",
    exports = [
        {exports}
    ],
    runtime_deps = [
        {runtime_deps}
    ],
    visibility = [
        "{visibility}"
    ]
)
"""


def _build_external_workspace_from_opts_impl(ctx):
    build_header = ctx.attr.build_header
    separator = ctx.attr.separator
    target_configs = ctx.attr.target_configs

    result_dict = {}
    for key, cfg in target_configs.items():
      build_file_to_target_name = key.split(":")
      build_file = build_file_to_target_name[0]
      target_name = build_file_to_target_name[1]
      if build_file not in result_dict:
        result_dict[build_file] = []
      result_dict[build_file].append(cfg)

    for key, file_entries in result_dict.items():
      build_file_contents = build_header + '\n\n'
      for build_target in file_entries:
        entry_map = {}
        for entry in build_target:
          elements = entry.split(separator)
          build_entry_key = elements[0]
          if elements[1] == "L":
            entry_map[build_entry_key] = [e for e in elements[2::] if len(e) > 0]
          elif elements[1] == "B":
            entry_map[build_entry_key] = (elements[2] == "true" or elements[2] == "True")
          else:
            entry_map[build_entry_key] = elements[2]

        exports_str = ""
        for e in entry_map.get("exports", []):
          exports_str += "\"" + e + "\",\n"

        jars_str = ""
        for e in entry_map.get("jars", []):
          jars_str += "\"" + e + "\",\n"

        runtime_deps_str = ""
        for e in entry_map.get("runtimeDeps", []):
          runtime_deps_str += "\"" + e + "\",\n"

        name = entry_map["name"].split(":")[1]
        if entry_map["lang"] == "java":
            build_file_contents += _JAVA_LIBRARY_TEMPLATE.format(name = name, exports=exports_str, runtime_deps=runtime_deps_str, visibility=entry_map["visibility"])
        elif entry_map["lang"].startswith("scala") and entry_map["kind"] == "import":
            build_file_contents += _SCALA_IMPORT_TEMPLATE.format(name = name, exports=exports_str, jars=jars_str, runtime_deps=runtime_deps_str, visibility=entry_map["visibility"])
        elif entry_map["lang"].startswith("scala") and entry_map["kind"] == "library":
            build_file_contents += _SCALA_LIBRARY_TEMPLATE.format(name = name, exports=exports_str, runtime_deps=runtime_deps_str, visibility=entry_map["visibility"])
        else:
            print(entry_map)

      ctx.file(ctx.path(key + "/BUILD"), build_file_contents, False)
    return None

build_external_workspace_from_opts = repository_rule(
    attrs = {
        "target_configs": attr.string_list_dict(mandatory = True),
        "separator": attr.string(mandatory = True),
        "build_header": attr.string(mandatory = True),
    },
    implementation = _build_external_workspace_from_opts_impl
)




def build_header():
 return """load("@io_bazel_rules_scala//scala:scala_import.bzl", "scala_import")"""

def list_target_data_separator():
 return "|||"

def list_target_data():
    return {
"3rdparty/jvm/com/google/protobuf:protobuf_java": ["lang||||||java","name||||||//3rdparty/jvm/com/google/protobuf:protobuf_java","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/google/protobuf/protobuf_java","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/lihaoyi:fansi_2_13": ["lang||||||java","name||||||//3rdparty/jvm/com/lihaoyi:fansi_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/com/lihaoyi:sourcecode_2_13|||//3rdparty/jvm/org/scala_lang:scala_library|||//external:jar/com/lihaoyi/fansi_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/lihaoyi:geny_2_13": ["lang||||||java","name||||||//3rdparty/jvm/com/lihaoyi:geny_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/lihaoyi/geny_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/lihaoyi:sourcecode_2_13": ["lang||||||java","name||||||//3rdparty/jvm/com/lihaoyi:sourcecode_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//external:jar/com/lihaoyi/sourcecode_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/thesamet/scalapb:lenses_2_13": ["lang||||||java","name||||||//3rdparty/jvm/com/thesamet/scalapb:lenses_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/org/scala_lang/modules:scala_collection_compat_2_13|||//external:jar/com/thesamet/scalapb/lenses_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/thesamet/scalapb:scalapb_runtime_2_13": ["lang||||||java","name||||||//3rdparty/jvm/com/thesamet/scalapb:scalapb_runtime_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/com/google/protobuf:protobuf_java|||//3rdparty/jvm/org/scala_lang/modules:scala_collection_compat_2_13|||//3rdparty/jvm/com/thesamet/scalapb:lenses_2_13|||//3rdparty/jvm/org/scala_lang:scala_library|||//external:jar/com/thesamet/scalapb/scalapb_runtime_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/github/java_diff_utils:java_diff_utils": ["lang||||||java","name||||||//3rdparty/jvm/io/github/java_diff_utils:java_diff_utils","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/io/github/java_diff_utils/java_diff_utils","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/net/java/dev/jna:jna": ["lang||||||java","name||||||//3rdparty/jvm/net/java/dev/jna:jna","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/net/java/dev/jna/jna","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/jline:jline": ["lang||||||java","name||||||//3rdparty/jvm/org/jline:jline","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/jline/jline","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scala_lang:scala_compiler": ["lang||||||java","name||||||//3rdparty/jvm/org/scala_lang:scala_compiler","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_reflect|||//3rdparty/jvm/net/java/dev/jna:jna|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/org/jline:jline|||//3rdparty/jvm/io/github/java_diff_utils:java_diff_utils|||//external:jar/org/scala_lang/scala_compiler","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scala_lang:scala_library": ["lang||||||java","name||||||//3rdparty/jvm/org/scala_lang:scala_library","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/scala_lang/scala_library","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scala_lang:scala_reflect": ["lang||||||java","name||||||//3rdparty/jvm/org/scala_lang:scala_reflect","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//external:jar/org/scala_lang/scala_reflect","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scala_lang:scalap": ["lang||||||java","name||||||//3rdparty/jvm/org/scala_lang:scalap","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_compiler|||//external:jar/org/scala_lang/scalap","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scala_lang/modules:scala_collection_compat_2_13": ["lang||||||java","name||||||//3rdparty/jvm/org/scala_lang/modules:scala_collection_compat_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//external:jar/org/scala_lang/modules/scala_collection_compat_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scalameta:common_2_13": ["lang||||||java","name||||||//3rdparty/jvm/org/scalameta:common_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/com/lihaoyi:sourcecode_2_13|||//3rdparty/jvm/com/thesamet/scalapb:scalapb_runtime_2_13|||//external:jar/org/scalameta/common_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scalameta:fastparse_v2_2_13": ["lang||||||java","name||||||//3rdparty/jvm/org/scalameta:fastparse_v2_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/com/lihaoyi:sourcecode_2_13|||//3rdparty/jvm/com/lihaoyi:geny_2_13|||//external:jar/org/scalameta/fastparse_v2_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scalameta:parsers_2_13": ["lang||||||java","name||||||//3rdparty/jvm/org/scalameta:parsers_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/org/scalameta:trees_2_13|||//external:jar/org/scalameta/parsers_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scalameta:trees_2_13": ["lang||||||java","name||||||//3rdparty/jvm/org/scalameta:trees_2_13","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/org/scalameta:common_2_13|||//3rdparty/jvm/org/scalameta:fastparse_v2_2_13|||//external:jar/org/scalameta/trees_2_13","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/lihaoyi:pprint": ["lang||||||scala:2.13.8","name||||||//3rdparty/jvm/com/lihaoyi:pprint","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/com/lihaoyi/pprint_2_13","sources|||L|||","exports|||L|||//3rdparty/jvm/com/lihaoyi:fansi_2_13|||//3rdparty/jvm/com/lihaoyi:sourcecode_2_13|||//3rdparty/jvm/org/scala_lang:scala_library","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scalameta:scalameta": ["lang||||||scala:2.13.8","name||||||//3rdparty/jvm/org/scalameta:scalameta","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/org/scalameta/scalameta_2_13","sources|||L|||","exports|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/org/scalameta:parsers_2_13|||//3rdparty/jvm/org/scala_lang:scalap","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"]
 }


def build_external_workspace(name):
  return build_external_workspace_from_opts(name = name, target_configs = list_target_data(), separator = list_target_data_separator(), build_header = build_header())

