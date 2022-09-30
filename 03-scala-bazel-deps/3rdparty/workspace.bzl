# Do not edit. bazel-deps autogenerates this file from dependencies.yaml.
def _jar_artifact_impl(ctx):
    jar_name = "%s.jar" % ctx.name
    ctx.download(
        output = ctx.path("jar/%s" % jar_name),
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        executable = False
    )
    src_name = "%s-sources.jar" % ctx.name
    srcjar_attr = ""
    has_sources = len(ctx.attr.src_urls) != 0
    if has_sources:
        ctx.download(
            output = ctx.path("jar/%s" % src_name),
            url = ctx.attr.src_urls,
            sha256 = ctx.attr.src_sha256,
            executable = False
        )
        srcjar_attr = '\n    srcjar = ":%s",' % src_name

    build_file_contents = """
package(default_visibility = ['//visibility:public'])
java_import(
    name = 'jar',
    tags = ['maven_coordinates={artifact}'],
    jars = ['{jar_name}'],{srcjar_attr}
)
filegroup(
    name = 'file',
    srcs = [
        '{jar_name}',
        '{src_name}'
    ],
    visibility = ['//visibility:public']
)\n""".format(artifact = ctx.attr.artifact, jar_name = jar_name, src_name = src_name, srcjar_attr = srcjar_attr)
    ctx.file(ctx.path("jar/BUILD"), build_file_contents, False)
    return None

jar_artifact = repository_rule(
    attrs = {
        "artifact": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "urls": attr.string_list(mandatory = True),
        "src_sha256": attr.string(mandatory = False, default=""),
        "src_urls": attr.string_list(mandatory = False, default=[]),
    },
    implementation = _jar_artifact_impl
)

def jar_artifact_callback(hash):
    src_urls = []
    src_sha256 = ""
    source=hash.get("source", None)
    if source != None:
        src_urls = [source["url"]]
        src_sha256 = source["sha256"]
    jar_artifact(
        artifact = hash["artifact"],
        name = hash["name"],
        urls = [hash["url"]],
        sha256 = hash["sha256"],
        src_urls = src_urls,
        src_sha256 = src_sha256
    )
    native.bind(name = hash["bind"], actual = hash["actual"])


def list_dependencies():
    return [
    {"artifact": "com.google.protobuf:protobuf-java:3.19.2", "lang": "java", "sha1": "e958ce38f96b612d3819ff1c753d4d70609aea74", "sha256": "3446cbfa13795228bc6549b91a409f27cdf6913d1c8f03e0f99572988623a04b", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/protobuf/protobuf-java/3.19.2/protobuf-java-3.19.2.jar", "source": {"sha1": "d0c5d998de57ebb714673fca418dad2fa05e9c72", "sha256": "5150243063356046d85f2949f471cf533ee4b44d31052f419fa5e70a72e76baf", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/protobuf/protobuf-java/3.19.2/protobuf-java-3.19.2-sources.jar"} , "name": "com_google_protobuf_protobuf_java", "actual": "@com_google_protobuf_protobuf_java//jar", "bind": "jar/com/google/protobuf/protobuf_java"},
    {"artifact": "com.lihaoyi:fansi_2.13:0.3.1", "lang": "java", "sha1": "93250eee85483f912719d81da29f3e76e24ee51b", "sha256": "a722291b4509335890e347f945de846104da0a3d83ec2816267427647189c956", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/lihaoyi/fansi_2.13/0.3.1/fansi_2.13-0.3.1.jar", "source": {"sha1": "db5bd4786eff519b68750b664736c8f20672fe67", "sha256": "8af72faf3d13ac6149ab34e7be58c283dcb63c9741b26d402109ad8e794bf159", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/lihaoyi/fansi_2.13/0.3.1/fansi_2.13-0.3.1-sources.jar"} , "name": "com_lihaoyi_fansi_2_13", "actual": "@com_lihaoyi_fansi_2_13//jar", "bind": "jar/com/lihaoyi/fansi_2_13"},
    {"artifact": "com.lihaoyi:geny_2.13:0.6.5", "lang": "java", "sha1": "8831c3af946628d4136e65d559146450a9b64c3d", "sha256": "ca3857a3f95266e0d87e1a1f26c8592c53c12ac7203f911759415f6c8a43df7d", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/lihaoyi/geny_2.13/0.6.5/geny_2.13-0.6.5.jar", "source": {"sha1": "08b7a91ae97d8c1bbf3bf29b9f0933e3ca74a931", "sha256": "ece40b310bd60d33613d394796063260f07aa6d8f52675d901477a092d85b48e", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/lihaoyi/geny_2.13/0.6.5/geny_2.13-0.6.5-sources.jar"} , "name": "com_lihaoyi_geny_2_13", "actual": "@com_lihaoyi_geny_2_13//jar", "bind": "jar/com/lihaoyi/geny_2_13"},
    {"artifact": "com.lihaoyi:pprint_2.13:0.7.3", "lang": "scala", "sha1": "8043b7415ea5e132115cab2a4b9c1704f2df8034", "sha256": "2bed0f7baf81e0963993ddb5996e366e27a9da469c0bb96c97e3d966e46061d7", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/lihaoyi/pprint_2.13/0.7.3/pprint_2.13-0.7.3.jar", "source": {"sha1": "0fb4991feb623741c1bf2141322b1c75b09813da", "sha256": "30a217bf8e1a45541842217c5e707334087631d3e35b9133c57189e076914aeb", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/lihaoyi/pprint_2.13/0.7.3/pprint_2.13-0.7.3-sources.jar"} , "name": "com_lihaoyi_pprint_2_13", "actual": "@com_lihaoyi_pprint_2_13//jar:file", "bind": "jar/com/lihaoyi/pprint_2_13"},
# duplicates in com.lihaoyi:sourcecode_2.13 promoted to 0.3.0
# - com.lihaoyi:fansi_2.13:0.3.1 wanted version 0.2.8
# - com.lihaoyi:pprint_2.13:0.7.3 wanted version 0.2.8
# - org.scalameta:common_2.13:4.6.0 wanted version 0.3.0
# - org.scalameta:fastparse-v2_2.13:2.3.1 wanted version 0.2.3
    {"artifact": "com.lihaoyi:sourcecode_2.13:0.3.0", "lang": "java", "sha1": "9574da0ce993607b071f682af95f6535ebe2a1f1", "sha256": "6e5b2d55e942b450a222bfd3ebc23e99ca03716e42da25af1b2c8cde038100f5", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/lihaoyi/sourcecode_2.13/0.3.0/sourcecode_2.13-0.3.0.jar", "source": {"sha1": "57b5cd414c74a01189c155047540848368de75a6", "sha256": "cc84a3a8bff5412e444131014cc0e23428b6fb65d2a5791d339f4be808f230da", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/lihaoyi/sourcecode_2.13/0.3.0/sourcecode_2.13-0.3.0-sources.jar"} , "name": "com_lihaoyi_sourcecode_2_13", "actual": "@com_lihaoyi_sourcecode_2_13//jar", "bind": "jar/com/lihaoyi/sourcecode_2_13"},
    {"artifact": "com.thesamet.scalapb:lenses_2.13:0.11.11", "lang": "java", "sha1": "09b21c7e02412c4b2c62739ef7c7daf98b9b832b", "sha256": "3da04a4ffd7b537ec90beb0d2fa456198a7c6844cc39a16be5aad3961ee59e5c", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/thesamet/scalapb/lenses_2.13/0.11.11/lenses_2.13-0.11.11.jar", "source": {"sha1": "80ec25c2c97708750b817e1c080ceaedfd11f47d", "sha256": "76f7266150b35caaef282a7c9e83a6e768df42faf071e6830a463e3d47b5c9ea", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/thesamet/scalapb/lenses_2.13/0.11.11/lenses_2.13-0.11.11-sources.jar"} , "name": "com_thesamet_scalapb_lenses_2_13", "actual": "@com_thesamet_scalapb_lenses_2_13//jar", "bind": "jar/com/thesamet/scalapb/lenses_2_13"},
    {"artifact": "com.thesamet.scalapb:scalapb-runtime_2.13:0.11.11", "lang": "java", "sha1": "dd2eac25960564464d312ff6a0e412525000fad4", "sha256": "11415623de89db09d64902a38ada91c037714d10f01e2337bb1b9afc3a4072b6", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/thesamet/scalapb/scalapb-runtime_2.13/0.11.11/scalapb-runtime_2.13-0.11.11.jar", "source": {"sha1": "6c89aa68201628adcea3502921462a4cb38c73b5", "sha256": "7a90c9e2b38c7b4a3578b0c7f5e82e8ec4370722143651a4f840eb7b2559d939", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/thesamet/scalapb/scalapb-runtime_2.13/0.11.11/scalapb-runtime_2.13-0.11.11-sources.jar"} , "name": "com_thesamet_scalapb_scalapb_runtime_2_13", "actual": "@com_thesamet_scalapb_scalapb_runtime_2_13//jar", "bind": "jar/com/thesamet/scalapb/scalapb_runtime_2_13"},
    {"artifact": "io.github.java-diff-utils:java-diff-utils:4.12", "lang": "java", "sha1": "1a712a91324d566eef39817fc5c9980eb10c21db", "sha256": "9990a2039778f6b4cc94790141c2868864eacee0620c6c459451121a901cd5b5", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/github/java-diff-utils/java-diff-utils/4.12/java-diff-utils-4.12.jar", "source": {"sha1": "175dac5f6daecef7444f24e581a42c48707baa1d", "sha256": "fa24217b6eaa115a05d4a8f0003fe913c62716ca2184d2e4f17de4a7d42a8822", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/github/java-diff-utils/java-diff-utils/4.12/java-diff-utils-4.12-sources.jar"} , "name": "io_github_java_diff_utils_java_diff_utils", "actual": "@io_github_java_diff_utils_java_diff_utils//jar", "bind": "jar/io/github/java_diff_utils/java_diff_utils"},
    {"artifact": "net.java.dev.jna:jna:5.9.0", "lang": "java", "sha1": "8f503e6d9b500ceff299052d6be75b38c7257758", "sha256": "eafcc780b445434d3c5ae7fa2fb6665de1a7560d537d2c408a8e80cd14d27161", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/5.9.0/jna-5.9.0.jar", "source": {"sha1": "8f388c1c94e58c83ffb61486fa19b709fd146595", "sha256": "577ee7ca6f762e38c068ab2989b1e9fc687063b39432d9d4417a17c7f2210ba7", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/5.9.0/jna-5.9.0-sources.jar"} , "name": "net_java_dev_jna_jna", "actual": "@net_java_dev_jna_jna//jar", "bind": "jar/net/java/dev/jna/jna"},
    {"artifact": "org.jline:jline:3.21.0", "lang": "java", "sha1": "2bf6f2311356f309fda0412e9389d2499346b5a1", "sha256": "1e7d63a2bd1c26354ca1987e55469ea4327c4a3845c10d7a7790ca9729c49c02", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jline/jline/3.21.0/jline-3.21.0.jar", "source": {"sha1": "633b5478dfc8fed93eb223bcfb1c101bfbba4362", "sha256": "9d1f5958a0cff8f0b1729cd10b3bbe71d2587a0ec9537ece87cca45d21ba3db3", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jline/jline/3.21.0/jline-3.21.0-sources.jar"} , "name": "org_jline_jline", "actual": "@org_jline_jline//jar", "bind": "jar/org/jline/jline"},
    {"artifact": "org.scala-lang.modules:scala-collection-compat_2.13:2.7.0", "lang": "java", "sha1": "ece9759b33008cc019be5a45d6a57b2f970ed885", "sha256": "936510670822c634f34ef793ef937a75e220f28824e591b220867c2f14943ad6", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/modules/scala-collection-compat_2.13/2.7.0/scala-collection-compat_2.13-2.7.0.jar", "source": {"sha1": "86066dca245042b36999f4fafdb4e2b3b5b06f05", "sha256": "e40e976633cc2862ceb5bb95d4baa06fa0ed2ed0b4809ef5b207268f93df21a0", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/modules/scala-collection-compat_2.13/2.7.0/scala-collection-compat_2.13-2.7.0-sources.jar"} , "name": "org_scala_lang_modules_scala_collection_compat_2_13", "actual": "@org_scala_lang_modules_scala_collection_compat_2_13//jar", "bind": "jar/org/scala_lang/modules/scala_collection_compat_2_13"},
    {"artifact": "org.scala-lang:scala-compiler:2.13.9", "lang": "java", "sha1": "5db431f60547728c74ac399baf2989fbb7806250", "sha256": "7f8daaa443a8c23f391f8a5e65532942065162e0bbe7451d290bdd100c419c9c", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scala-compiler/2.13.9/scala-compiler-2.13.9.jar", "source": {"sha1": "c42aebef0949812ff8c79afa2e4ac634162c1325", "sha256": "6834462eb069831f58a8c078920c0ac37d3795106dabdf31a7c7ad826e18970b", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scala-compiler/2.13.9/scala-compiler-2.13.9-sources.jar"} , "name": "org_scala_lang_scala_compiler", "actual": "@org_scala_lang_scala_compiler//jar", "bind": "jar/org/scala_lang/scala_compiler"},
# duplicates in org.scala-lang:scala-library promoted to 2.13.9
# - com.lihaoyi:fansi_2.13:0.3.1 wanted version 2.13.4
# - com.lihaoyi:pprint_2.13:0.7.3 wanted version 2.13.4
# - com.lihaoyi:sourcecode_2.13:0.3.0 wanted version 2.13.8
# - com.thesamet.scalapb:lenses_2.13:0.11.11 wanted version 2.13.8
# - com.thesamet.scalapb:scalapb-runtime_2.13:0.11.11 wanted version 2.13.8
# - org.scala-lang.modules:scala-collection-compat_2.13:2.7.0 wanted version 2.13.8
# - org.scala-lang:scala-compiler:2.13.9 wanted version 2.13.9
# - org.scala-lang:scala-reflect:2.13.9 wanted version 2.13.9
# - org.scalameta:common_2.13:4.6.0 wanted version 2.13.9
# - org.scalameta:parsers_2.13:4.6.0 wanted version 2.13.9
# - org.scalameta:scalameta_2.13:4.6.0 wanted version 2.13.9
# - org.scalameta:trees_2.13:4.6.0 wanted version 2.13.9
    {"artifact": "org.scala-lang:scala-library:2.13.9", "lang": "java", "sha1": "48bad4bee84f503be847be81ae96d32f6e78d658", "sha256": "317e0cd80aa8b0ce9e98d154053d9a0f5acc63854b68ca5522d3e017c68dc8e5", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scala-library/2.13.9/scala-library-2.13.9.jar", "source": {"sha1": "7983c2e5106b872a692d9be2af4b6fc85c05afc8", "sha256": "09f1e2a3bee18a285c02779c48719a36f7e4005a2ccc4002982ff0620f92ee59", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scala-library/2.13.9/scala-library-2.13.9-sources.jar"} , "name": "org_scala_lang_scala_library", "actual": "@org_scala_lang_scala_library//jar", "bind": "jar/org/scala_lang/scala_library"},
    {"artifact": "org.scala-lang:scala-reflect:2.13.9", "lang": "java", "sha1": "10c5370efc4637a0a6e05df82c460dcdab09e446", "sha256": "23bad48a23465b4c91e1feb6773ca6361ac2e0053020b3e311c25a2af1d476c6", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scala-reflect/2.13.9/scala-reflect-2.13.9.jar", "source": {"sha1": "1868e2387816629a48d33ff7c5d12734758a946a", "sha256": "3b466df0fac42475954caba7b025f0ec3733f318e72400efb8cc82c31c7d1a8e", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scala-reflect/2.13.9/scala-reflect-2.13.9-sources.jar"} , "name": "org_scala_lang_scala_reflect", "actual": "@org_scala_lang_scala_reflect//jar", "bind": "jar/org/scala_lang/scala_reflect"},
    {"artifact": "org.scala-lang:scalap:2.13.9", "lang": "java", "sha1": "facb71fef28d64bef501697e9bf474590a4e1b71", "sha256": "7f8b41db8c5678d7785ce7f263574be4b90f1466999ceb68591e746bacd69469", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scalap/2.13.9/scalap-2.13.9.jar", "source": {"sha1": "92b794457cb541453bc5e9ec0bd3f236cc4df805", "sha256": "48ff38ee577ef3b3fa1280e6411b889712b93ff934f07afa6f1192a75f228b1c", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scalap/2.13.9/scalap-2.13.9-sources.jar"} , "name": "org_scala_lang_scalap", "actual": "@org_scala_lang_scalap//jar", "bind": "jar/org/scala_lang/scalap"},
    {"artifact": "org.scalameta:common_2.13:4.6.0", "lang": "java", "sha1": "d80867202e07d677c4e4f29a20ef38b49bc350c6", "sha256": "c5570578d9983c909b77c24c3a2e0e27bc1fce3bc4f4a7c70cd5a938b717bca9", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/common_2.13/4.6.0/common_2.13-4.6.0.jar", "source": {"sha1": "51bfb9f353baf828db14a2ecc675e858b910b13a", "sha256": "535a7725ed04ac0e8b3148d982737f9fa76770fdf204c1cace68487481aa6943", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/common_2.13/4.6.0/common_2.13-4.6.0-sources.jar"} , "name": "org_scalameta_common_2_13", "actual": "@org_scalameta_common_2_13//jar", "bind": "jar/org/scalameta/common_2_13"},
    {"artifact": "org.scalameta:fastparse-v2_2.13:2.3.1", "lang": "java", "sha1": "03c6767bd5ad69dbdf3748b739826167555d0119", "sha256": "8fca8597ad6d7c13c48009ee13bbe80c176b08ab12e68af54a50f7f69d8447c5", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/fastparse-v2_2.13/2.3.1/fastparse-v2_2.13-2.3.1.jar", "source": {"sha1": "f55c0007ecf52f47e5faf67f680252ac22dc1395", "sha256": "8b15f0ab21de220ced6ef14d1854f1446123371ef9d4020e1d4be941c3e488b2", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/fastparse-v2_2.13/2.3.1/fastparse-v2_2.13-2.3.1-sources.jar"} , "name": "org_scalameta_fastparse_v2_2_13", "actual": "@org_scalameta_fastparse_v2_2_13//jar", "bind": "jar/org/scalameta/fastparse_v2_2_13"},
    {"artifact": "org.scalameta:parsers_2.13:4.6.0", "lang": "java", "sha1": "d6d6c78279e6c8ba063018a7770825ede73ce887", "sha256": "336ffb9b4f6bba5126fb1d1ecbef107cf545ed85586d33a21993e6dbf76a80eb", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/parsers_2.13/4.6.0/parsers_2.13-4.6.0.jar", "source": {"sha1": "061c65748e229a5a61487866cd100ac84c47ffa6", "sha256": "4bb1cfa38d08e1fdd60aeebddb96f0f2ad6ad4fdc6f126cec431ae4bd1322f9c", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/parsers_2.13/4.6.0/parsers_2.13-4.6.0-sources.jar"} , "name": "org_scalameta_parsers_2_13", "actual": "@org_scalameta_parsers_2_13//jar", "bind": "jar/org/scalameta/parsers_2_13"},
    {"artifact": "org.scalameta:scalameta_2.13:4.6.0", "lang": "scala", "sha1": "465f8b307d8a2000890cdcd225c8b5704c19b907", "sha256": "afcd7db7e56112fbdc8bc4880ff3e244f0091b3086bcaf8adf82291a9e56727b", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/scalameta_2.13/4.6.0/scalameta_2.13-4.6.0.jar", "source": {"sha1": "e9cf202fbfc273ae14f06d41bba0779d525af953", "sha256": "d188b106197e0bdbb22ce3ba66b09ae142fee379d4e3a8875b7569db95df4728", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/scalameta_2.13/4.6.0/scalameta_2.13-4.6.0-sources.jar"} , "name": "org_scalameta_scalameta_2_13", "actual": "@org_scalameta_scalameta_2_13//jar:file", "bind": "jar/org/scalameta/scalameta_2_13"},
    {"artifact": "org.scalameta:trees_2.13:4.6.0", "lang": "java", "sha1": "8c973b2f576eca5fa05364316b2253fbb7254e17", "sha256": "573e1e3b922e55987fdd26c049ea1c95c066db1bf08c06772f037347ef917bfd", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/trees_2.13/4.6.0/trees_2.13-4.6.0.jar", "source": {"sha1": "a7d598e34e382753ea262bf21c90e037541b53ae", "sha256": "549e8b39a0c6dbdd89e707a3fe0d9132f560b894587cb3daa5e632736d8ba93c", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scalameta/trees_2.13/4.6.0/trees_2.13-4.6.0-sources.jar"} , "name": "org_scalameta_trees_2_13", "actual": "@org_scalameta_trees_2_13//jar", "bind": "jar/org/scalameta/trees_2_13"},
    ]

def maven_dependencies(callback = jar_artifact_callback):
    for hash in list_dependencies():
        callback(hash)
