load("//lib:repo_utils.bzl", "download_toolchain_binary")
load('@aspect_bazel_lib//lib/private:repo_utils.bzl', 'repo_utils')

# version=https://dl.k8s.io/release/stable.txt
# https://dl.k8s.io/release/${version}/bin/darwin/arm64/kubectl https://dl.k8s.io/release/${version}/bin/darwin/arm64/kubectl.sha256
# https://dl.k8s.io/release/${version}/bin/darwin/amd64/kubectl https://dl.k8s.io/release/${version}/bin/darwin/amd64/kubectl.sha256
# https://dl.k8s.io/release/${version}/bin/linux/arm64/kubectl https://dl.k8s.io/release/${version}/bin/linux/arm64/kubectl.sha256
# https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl.sha256

_binaries = {
  "1.31.0": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.31.0/bin/darwin/amd64/kubectl",
      "fb6e07a69acc4e16885eda55b524c13b84bfbcf78cfac8d6c378d2bad321e105"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl",
      "7c27adc64a84d1c0cc3dcf7bf4b6e916cc00f3f576a2dbac51b318d926032437"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.31.0/bin/darwin/arm64/kubectl",
      "b7472df17a885574ed7273947a8a274c156357db21b981208e8e109b9ed4022d"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.31.0/bin/linux/arm64/kubectl",
      "f42832db7d77897514639c6df38214a6d8ae1262ee34943364ec1ffaee6c009c"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.31.0/bin/windows/amd64/kubectl.exe",
      "a618de26c86421a394de7041f9d0a87752dd4e555894d2278421cf12097fa531"
    )
  },
  "1.30.0": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.30.0/bin/darwin/amd64/kubectl",
      "bcfa57d020b8d07d0ea77235ce8012c2c28fefdfd7cb9738f33674a7b16cef08"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl",
      "7c3807c0f5c1b30110a2ff1e55da1d112a6d0096201f1beb81b269f582b5d1c5"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.30.0/bin/darwin/arm64/kubectl",
      "45cfa208151320153742062824398f22bb6bfb5a142bf6238476d55dacbd1bdd"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.30.0/bin/linux/arm64/kubectl",
      "669af0cf520757298ea60a8b6eb6b719ba443a9c7d35f36d3fb2fd7513e8c7d2"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.30.0/bin/windows/amd64/kubectl.exe",
      "e0e72bf37bf563fdea4a6070b07e2fbaa818aa02ed38c5d10d9ce146106cab70"
    )
  },
  "1.30.1": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.30.1/bin/darwin/amd64/kubectl",
      "eaefb69cf908b7473d2dce0ba894c956b7e1ad5a4987a96d68a279f5597bb22d"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.30.1/bin/linux/amd64/kubectl",
      "5b86f0b06e1a5ba6f8f00e2b01e8ed39407729c4990aeda961f83a586f975e8a"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.30.1/bin/darwin/arm64/kubectl",
      "55dec3c52702bd68488a5c1ab840b79ea9e73e4b9f597bcf75b201c55d0bd280"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.30.1/bin/linux/arm64/kubectl",
      "d90446719b815e3abfe7b2c46ddf8b3fda17599f03ab370d6e47b1580c0e869e"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.30.1/bin/windows/amd64/kubectl.exe",
      "f7391a2de0491caadedb5178ac2485cbf104189b2e0f3d6c577bd6ea1892898f"
    )
  },
  "1.30.2": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.30.2/bin/darwin/amd64/kubectl",
      "0371b7bcc060f533170ac6fb99bc9aa13fdf3fa005276e3eb14eed162ed8a3a9"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.30.2/bin/linux/amd64/kubectl",
      "c6e9c45ce3f82c90663e3c30db3b27c167e8b19d83ed4048b61c1013f6a7c66e"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.30.2/bin/darwin/arm64/kubectl",
      "ffcba19e77b9521f5779ab32cfcd4bfcc9d20cd42c2f075c7c5aef83f32754ae"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.30.2/bin/linux/arm64/kubectl",
      "56becf07105fbacd2b70f87f3f696cfbed226cb48d6d89ed7f65ba4acae3f2f8"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.30.2/bin/windows/amd64/kubectl.exe",
      "59a5b1028f6e3aea046b103f9a787cf4d70067d554053f713d691b14df3d9bb4"
    )
  },
  "1.30.3": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.30.3/bin/darwin/amd64/kubectl",
      "b3ccb0ba6f7972074b0a1e13340307abfd5a5eef540c521a88b368891ec5cd6b"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.30.3/bin/linux/amd64/kubectl",
      "abd83816bd236b266c3643e6c852b446f068fe260f3296af1a25b550854ec7e5"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.30.3/bin/darwin/arm64/kubectl",
      "71f3febd165423991e0aabef5750cb8de6fc43e93ea130767d12eb183cc63a5b"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.30.3/bin/linux/arm64/kubectl",
      "c6f9568f930b16101089f1036677bb15a3185e9ed9b8dbce2f518fb5a52b6787"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.30.3/bin/windows/amd64/kubectl.exe",
      "4d066fc70ebfaad0da43c93daebdb62208993c04ea9a2b5e9ba459b18d6a1c81"
    )
  },
  "1.30.4": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.30.4/bin/darwin/amd64/kubectl",
      "ce1b79f0720509b7e78e73f4cd8d41d8ea46256a10a16f38ddeee6ff139a2625"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.30.4/bin/linux/amd64/kubectl",
      "2ffd023712bbc1a9390dbd8c0c15201c165a69d394787ef03eda3eccb4b9ac06"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.30.4/bin/darwin/arm64/kubectl",
      "978674da62282da697d889c33e0cc36f4b7ecb3a4d1ff73fc93e6e83877d5945"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.30.4/bin/linux/arm64/kubectl",
      "1d8b4e6443c7df8e92a065d88d146142a202fea5ec694135b83d9668529ea3b1"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.30.4/bin/windows/amd64/kubectl.exe",
      "c9ddaf742a8d4bd8a1b26ff6981976154109b829d544b259464639451e8ddae6"
    )
  },
  "1.29.0": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.29.0/bin/darwin/amd64/kubectl",
      "d69c2b0929070e42518b304758fbe05cf76c4fb60d36e93bb667d7b76e582124"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl",
      "0e03ab096163f61ab610b33f37f55709d3af8e16e4dcc1eb682882ef80f96fd5"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.29.0/bin/darwin/arm64/kubectl",
      "403beb5d64d8a8517f808a320619a28adc89003b1b710f02421933a9ee4eb968"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.29.0/bin/linux/arm64/kubectl",
      "8f7a4bd6bae900a4ddab12bd1399aa652c0d59ea508f39b910e111d248893ff7"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.29.0/bin/windows/amd64/kubectl.exe",
      "0ba8da57990757e3bc02df838d36adaf0586e557f518d0149f00e63ac2057066"
    )
  },
  "1.29.1": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.29.1/bin/darwin/amd64/kubectl",
      "c4da86e5c0fc9415db14a48d9ef1515b0b472346cbc9b7f015175b6109505d2c"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.29.1/bin/linux/amd64/kubectl",
      "69ab3a931e826bf7ac14d38ba7ca637d66a6fcb1ca0e3333a2cafdf15482af9f"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.29.1/bin/darwin/arm64/kubectl",
      "c31b99d7bf0faa486a6554c5f96e36af4821a488e90176a12ba18298bc4c8fb0"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.29.1/bin/linux/arm64/kubectl",
      "96d6dc7b2bdcd344ce58d17631c452225de5bbf59b83fd3c89c33c6298fb5d8b"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.29.1/bin/windows/amd64/kubectl.exe",
      "d48a0b160f361bac2d7cb3e19c755e70f2ae8d7d15c89f52d33b66dd9ba5b89c"
    )
  },
  "1.29.2": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.29.2/bin/darwin/amd64/kubectl",
      "bb04d9450d9c9fa120956c5cc7c8dfaa700297038ff9c941741e730b02bbd1f3"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.29.2/bin/linux/amd64/kubectl",
      "7816d067740f47f949be826ac76943167b7b3a38c4f0c18b902fffa8779a5afa"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.29.2/bin/darwin/arm64/kubectl",
      "ce030f86625df96560402573d86d4e6f4b8b956ca3e3b9df57cb8ccf2b9a540c"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.29.2/bin/linux/arm64/kubectl",
      "3507ecb4224cf05ae2151a98d4932253624e7762159936d5347b19fe037655ca"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.29.2/bin/windows/amd64/kubectl.exe",
      "5107162e20ef6e6f06c2db37e56da5db552858d83fa43b51787bf48c6e6d1caf"
    )
  },
  "1.29.3": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.29.3/bin/darwin/amd64/kubectl",
      "1a1f9040bce74fb28c475dc157a86565fcabf883a697ca576993ab8372935836"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.29.3/bin/linux/amd64/kubectl",
      "89c0435cec75278f84b62b848b8c0d3e15897d6947b6c59a49ddccd93d7312bf"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.29.3/bin/darwin/arm64/kubectl",
      "b54bf7a3f4d52117b79e4d4f0d7273a93cb60bad54a87f3ab35c6800243cbb8e"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.29.3/bin/linux/arm64/kubectl",
      "191a96b27e3c6ae28b330da4c9bfefc9592762670727df4fcf124c9f1d5a466a"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.29.3/bin/windows/amd64/kubectl.exe",
      "0192ce501a39ba1bb6cc7f1971a6004bc4b57d2c27400befaacaa4560dfff46e"
    )
  },
  "1.29.4": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.29.4/bin/darwin/amd64/kubectl",
      "7af9b8a233c49ad5eecb59004719e0bc07972492b674ebbce2919e53326b55b2"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.29.4/bin/linux/amd64/kubectl",
      "10e343861c3cb0010161e703307ba907add2aeeeaffc6444779ad915f9889c88"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.29.4/bin/darwin/arm64/kubectl",
      "b3a881e6208aa41275a97481676a8c8a3c16282f3cd7b441b17f258a054012f1"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.29.4/bin/linux/arm64/kubectl",
      "61537408eedcad064d7334384aed508a8aa1ea786311b87b505456a2e0535d36"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.29.4/bin/windows/amd64/kubectl.exe",
      "23ea3fce3a784b28e9445c1f813bdcdbd1270f92711f44f6e5772fa2ec2ce238"
    )
  },
  "1.29.5": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.29.5/bin/darwin/amd64/kubectl",
      "395082ef84594ea4cb170d599056406ed2cf39555b53e92e0caee013c1ed5cdf"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.29.5/bin/linux/amd64/kubectl",
      "603c8681fc0d8609c851f9cc58bcf55eeb97e2934896e858d0232aa8d1138366"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.29.5/bin/darwin/arm64/kubectl",
      "23b09c126c0a0b71b58cc725a32cf84f1753242b3892dfd762511f2da6cce165"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.29.5/bin/linux/arm64/kubectl",
      "9ee9168def12ac6a6c0c6430e0f73175e756ed262db6040f8aa2121ad2c1f62e"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.29.5/bin/windows/amd64/kubectl.exe",
      "8de419ccecdde90172345e7d12a63de42c217d28768d84c2398d932b44d73489"
    )
  },
  "1.29.6": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.29.6/bin/darwin/amd64/kubectl",
      "d6a844991d3853d9928a7593f583157403ea322ff712d7659b16e621fca00d79"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.29.6/bin/linux/amd64/kubectl",
      "339553c919874ebe3b719e9e1fcd68b55bc8875f9b5a005cf4c028738d54d309"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.29.6/bin/darwin/arm64/kubectl",
      "0b7a3cd78503faf45c6506d594b586f58b9904ad48452466834397641d58d6f5"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.29.6/bin/linux/arm64/kubectl",
      "21816488cf3af4cf2b956ee58f7afc5b4964c29488f63756f5ddcf09b0df5be9"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.29.6/bin/windows/amd64/kubectl.exe",
      "4c9cb51b40598f97bf2506da76d9482fa55e57adadaa49279e21e0cf6168ec18"
    )
  },
  "1.29.7": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.29.7/bin/darwin/amd64/kubectl",
      "e747b90725ebdac7b8a88621fc48ee56fabf5319da3080fa5855712e81fc88f8"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.29.7/bin/linux/amd64/kubectl",
      "e3df008ef60ea50286ea93c3c40a020e178a338cea64a185b4e21792d88c75d6"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.29.7/bin/darwin/arm64/kubectl",
      "f987c6a8cb769ec5062024ef27e2255bf8bc290d47f41b0fb974bb58094e11a7"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.29.7/bin/linux/arm64/kubectl",
      "7b6649aaa298be728c5fb7ccb65f98738a4e8bda0741afbd5a9ed9e488c0e725"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.29.7/bin/windows/amd64/kubectl.exe",
      "c4f76c46b792395e81c72a56ed55893bf5a31e3d1b4d67556c06f37aa7122d10"
    )
  },
  "1.29.8": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.29.8/bin/darwin/amd64/kubectl",
      "b1d780b97c36a2470c603a804476e85ad8fc4e13bb7761fd19180d79f8b06081"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.29.8/bin/linux/amd64/kubectl",
      "038454e0d79748aab41668f44ca6e4ac8affd1895a94f592b9739a0ae2a5f06a"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.29.8/bin/darwin/arm64/kubectl",
      "c48ad5e96b1dab12e504535fb2341476b3fe543d314cf90f98b11326ee0ed71d"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.29.8/bin/linux/arm64/kubectl",
      "adf0007e702e05f59fb8de159463765c4440f872515bd04c24939d9c8fb5e4c7"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.29.8/bin/windows/amd64/kubectl.exe",
      "7608329ae2f92aee0b615f46a09ba550093548bcd09662e17e3d7097421a86c7"
    )
  },
  "1.28.0": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.0/bin/darwin/amd64/kubectl",
      "6db117a55a14a47c0dcf9144c31780c6de0c3c84ccb9a297de0d9e6fc481534d"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl",
      "4717660fd1466ec72d59000bb1d9f5cdc91fac31d491043ca62b34398e0799ce"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.0/bin/darwin/arm64/kubectl",
      "5d74042f5972b342a02636cf5969d4d73234f2d3afe84fe5ddaaa4baff79cdd8"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.0/bin/linux/arm64/kubectl",
      "f5484bd9cac66b183c653abed30226b561f537d15346c605cc81d98095f1717c"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe",
      "ee15a9ea4796e1acad1188b200155afdfde01083850570a8218e2f03fbbff019"
    )
  },
  "1.28.1": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.1/bin/darwin/amd64/kubectl",
      "d6b8f2bac5f828478eade0acf15fb7dde02d7613fc9e644dc019a7520d822a1a"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.1/bin/linux/amd64/kubectl",
      "e7a7d6f9d06fab38b4128785aa80f65c54f6675a0d2abef655259ddd852274e1"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.1/bin/darwin/arm64/kubectl",
      "8fe9f753383574863959335d8b830908e67a40c3f51960af63892d969bfc1b10"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.1/bin/linux/arm64/kubectl",
      "46954a604b784a8b0dc16754cfc3fa26aabca9fd4ffd109cd028bfba99d492f6"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.1/bin/windows/amd64/kubectl.exe",
      "810a6f576367bfb7420ebf318fd3fe95fd445c785e39042b9edeaae55d834d44"
    )
  },
  "1.28.2": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.2/bin/darwin/amd64/kubectl",
      "fb90ffc2b1751537ec1131276dd3a2f165464191025c3392a0ee2ed1575a19f0"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.2/bin/linux/amd64/kubectl",
      "c922440b043e5de1afa3c1382f8c663a25f055978cbc6e8423493ec157579ec5"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.2/bin/darwin/arm64/kubectl",
      "a00300f8463f659f4eeb04ff2ad92fec5f552e3de041bf4eae23587cc7408fbc"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.2/bin/linux/arm64/kubectl",
      "ea6d89b677a8d9df331a82139bb90d9968131530b94eab26cee561531eff4c53"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.2/bin/windows/amd64/kubectl.exe",
      "b52b17a1fcfa6cc1cb3e480a0d6066c7d7175159ecd4a62ac8e44d8ce2c7a931"
    )
  },
  "1.28.3": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.3/bin/darwin/amd64/kubectl",
      "3130398698b131ceae24879745aa536f9ec38790b397d806e4f6db03d65e4abb"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.3/bin/linux/amd64/kubectl",
      "0c680c90892c43e5ce708e918821f92445d1d244f9b3d7513023bcae9a6246d1"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.3/bin/darwin/arm64/kubectl",
      "b1b83c298177b849f9a8564b0dfcde8ecabc646b7f409d18001b8d4de407e0bf"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.3/bin/linux/arm64/kubectl",
      "06511f03e34d8ee350bd55717845e27ebec3116526db7c60092eeb33a475a337"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.3/bin/windows/amd64/kubectl.exe",
      "0f25d33ba68f526afeceb11e263a97473e8c42f856b05f0b9c4863bead6dac4c"
    )
  },
  "1.28.4": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.4/bin/darwin/amd64/kubectl",
      "70ac52dab10e4e276ce49a5cde05d495149ecaa0dc3126ba50611542ef0e6d56"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl",
      "893c92053adea6edbbd4e959c871f5c21edce416988f968bec565d115383f7b8"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.4/bin/darwin/arm64/kubectl",
      "7e49c25887fe7cbf2a4b01a41604bdf1edc18a9faede45c810713af2b3a28361"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.4/bin/linux/arm64/kubectl",
      "edf1e17b41891ec15d59dd3cc62bcd2cdce4b0fd9c2ee058b0967b17534457d7"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.4/bin/windows/amd64/kubectl.exe",
      "6fd6e38de7ec6362fc6582ee439014ed1be661e04eb851c6cdc6759856929ef2"
    )
  },
  "1.28.5": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.5/bin/darwin/amd64/kubectl",
      "b6ca01e3f21bc5e7fe711c917d3f59b06c0849d688ccc4590a82f1098e078849"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.5/bin/linux/amd64/kubectl",
      "2a44c0841b794d85b7819b505da2ff3acd5950bd1bcd956863714acc80653574"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.5/bin/darwin/arm64/kubectl",
      "9c9ec9e69c7fe989fde601b5a71035782271fb788bb92b24eed20bc4fbc8b310"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.5/bin/linux/arm64/kubectl",
      "f87fe017ae3ccfd93df03bf17edd4089672528107f230563b8c9966909661ef2"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.5/bin/windows/amd64/kubectl.exe",
      "3e632093a6e02bde8962c308148edab5b1fb4d8a71b41810866d4cedbc04317c"
    )
  },
  "1.28.6": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.6/bin/darwin/amd64/kubectl",
      "2853d5a40a618a8d25f3cb30e72d03a8394a92e32842d60428271755e46bf2fe"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.6/bin/linux/amd64/kubectl",
      "c8351fe0611119fd36634dd3f53eb94ec1a2d43ef9e78b92b4846df5cc7aa7e3"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.6/bin/darwin/arm64/kubectl",
      "35a3ae87eee5af0a561f90d5139bda21da2f41884ec37bfe31547d271b0b2339"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.6/bin/linux/arm64/kubectl",
      "0de705659a80c3fef01df43cc0926610fe31482f728b0f992818abd9bdcd2cb9"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.6/bin/windows/amd64/kubectl.exe",
      "a9de70249210a7638e35644275ba9f9a2737df2f4d21bf32ceb56fc89c55e888"
    )
  },
  "1.28.7": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.7/bin/darwin/amd64/kubectl",
      "69bdb3f618e40de912400c2e56d085325f872abc604e87a4f9f2da6bb25c8aa4"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.7/bin/linux/amd64/kubectl",
      "aff42d3167685e4d8e86fda0ad9c6ce6ec6c047bc24d608041d54717a18192ba"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.7/bin/darwin/arm64/kubectl",
      "250104cd000aa31a45075c82b1267938833e1ca8f9322a9512f96caa489b68ec"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.7/bin/linux/arm64/kubectl",
      "13d547495bdea49b223fe06bffb6d2bef96436634847f759107655aa80fc990e"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.7/bin/windows/amd64/kubectl.exe",
      "b6620c4ff153bbdf4ff26890b657e5b76a4d8fdfe4e46531dc495173acea26cf"
    )
  },
  "1.28.8": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.8/bin/darwin/amd64/kubectl",
      "959acd160b2c858c08426c64f533e768581182428bf9afd6965e1d0f37909b16"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.8/bin/linux/amd64/kubectl",
      "e02aad5c0bac52c970700b814645b62c4f18b634144398ac344875dbaf1072f8"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.8/bin/darwin/arm64/kubectl",
      "280b9ad125bb648ef81839349e2b921db6d674cc153b3c6116d65383260aeae5"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.8/bin/linux/arm64/kubectl",
      "93d60dd36093b4c719f1f1bafcf59437c17cb2209341c7c94771e7dd9acdab33"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.8/bin/windows/amd64/kubectl.exe",
      "fd310b2faa2f4fd0a06d607cc79c115ea3251eeeb83c5442ca225211ecee61f9"
    )
  },
  "1.28.9": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.9/bin/darwin/amd64/kubectl",
      "99df1db1c735e7f6aceb1f53a0c8c313f51be34cda9d964b0764e96dd7275d09"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.9/bin/linux/amd64/kubectl",
      "b4693d0b22f509250694b10c7727c42b427d570af04f2065fe23a55d6c0051f1"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.9/bin/darwin/arm64/kubectl",
      "48cb2db4cc76a9a3a0f5d7f4dd9bd839196b39d9726247384b91e32e6a83be94"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.9/bin/linux/arm64/kubectl",
      "e0341d3973213f8099e7fcbbf6d1d506967bc2b7a4faac3fb3b4340f226e9b2f"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.9/bin/windows/amd64/kubectl.exe",
      "e82439aca2a1d7a1138912eb5d25d191ff5f1fc6d3753723f8b36168e6b95db8"
    )
  },
  "1.28.10": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.10/bin/darwin/amd64/kubectl",
      "426e1cdfe990b6f0e26d3b5243e079650cc65d6b4b5374824197c5d471f99cff"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.10/bin/linux/amd64/kubectl",
      "389c17a9700a4b01ebb055e39b8bc0886330497440dde004b5ed90f2a3a028db"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.10/bin/darwin/arm64/kubectl",
      "da88c27eeab82512f9a23c6d80a9c6cc933d3514d3cd4fb215c8b57868a78195"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.10/bin/linux/arm64/kubectl",
      "e659d23d442c2706debe5b96742326c0a1e1d7b5c695a9fe7dfe8ea7402caee8"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.10/bin/windows/amd64/kubectl.exe",
      "eddfbb875a7458a474b3b9ed089369baa8a782b9921be01ecb8abd4e9f1097d9"
    )
  },
  "1.28.11": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.11/bin/darwin/amd64/kubectl",
      "0eb7314ee18185d9e4782f70e79b1554e5d787d8e4a590532ab90b64b94384ac"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.11/bin/linux/amd64/kubectl",
      "1dba63e1a5c9520fc516c6e817924d927b9b83b8e08254c8fe2a2edb65da7a9c"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.11/bin/darwin/arm64/kubectl",
      "85f752c0ac9e7a560da57e904ef0dee310fe53fc6ad39c2e301b1dda4a21cf96"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.11/bin/linux/arm64/kubectl",
      "7984a98d52365d190b6f56caa962339a7228b6f432e58ba5f1b1e60dbedac275"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.11/bin/windows/amd64/kubectl.exe",
      "83c7867c133e895cf5c97314145cf4daa1dbe5ffa4b344bbbc8687100fbf500f"
    )
  },
  "1.28.12": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.12/bin/darwin/amd64/kubectl",
      "c148882b1fe3de2fb5534f79dbd4e5e6ae08ffafd406c97e25b0042c957dc876"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.12/bin/linux/amd64/kubectl",
      "e8aee7c9206c00062ced394418a17994b58f279a93a1be1143b08afe1758a3a2"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.12/bin/darwin/arm64/kubectl",
      "353c28cb6cc687ce74bdfc15c462c4e2400275fd4ff4040c79a28e982190bf28"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.12/bin/linux/arm64/kubectl",
      "f7e01dfffebb1d5811c37d558f28eefd80cbfadc0b9783b0b0ebf37c40c5c891"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.12/bin/windows/amd64/kubectl.exe",
      "2cb52dd2fc67d76fd99ab154364f67c09c3f7159c6d52e941a9349801cf48ba0"
    )
  },
  "1.28.13": {
    "darwin_amd64": (
      "https://dl.k8s.io/release/v1.28.13/bin/darwin/amd64/kubectl",
      "da83c1db4a2270584e4562f0ff658bd2cb8d56997a5441b62920030a4d48cb27"
    ),
    "linux_amd64": (
      "https://dl.k8s.io/release/v1.28.13/bin/linux/amd64/kubectl",
      "d7d363dd5a4c95444329bc5239b8718ebe84a043052958b2f15ee2feef9a28c6"
    ),
    "darwin_arm64": (
      "https://dl.k8s.io/release/v1.28.13/bin/darwin/arm64/kubectl",
      "b908e29c56c87e3d09dc0258b3ead8a32c23eea5e8619a6a7134419c00d1141e"
    ),
    "linux_arm64": (
      "https://dl.k8s.io/release/v1.28.13/bin/linux/arm64/kubectl",
      "a22d234724b82101e1f17e95ab60e0e13c91a0fe17ad0890b3d92681cd551bfa"
    ),
    "windows_amd64": (
      "https://dl.k8s.io/release/v1.28.13/bin/windows/amd64/kubectl.exe",
      "99afa16f9d4ccd47daa473dbe255d3b4f1f142e3e877db1b4ee33023717bdd8c"
    )
  },
}

DEFAULT_KUBECTL_VERSION = "1.31.0"
DEFAULT_KUBECTL_REPOSITORY = "kubectl"

KUBECTL_PLATFORMS = {
    "darwin_amd64": struct(
        release_platform = "macos-amd64",
        compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:x86_64",
        ],
    ),
    "darwin_arm64": struct(
        release_platform = "macos-arm64",
        compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:aarch64",
        ],
    ),
    "linux_amd64": struct(
        release_platform = "linux-amd64",
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
    "linux_arm64": struct(
        release_platform = "linux-arm64",
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:aarch64",
        ],
    ),
}

KubectlInfo = provider(
    doc = "Provide info for executing kubectl",
    fields = {
        "bin": "Executable kubectl binary",
    },
)

def _kubectl_toolchain_impl(ctx):
    binary = ctx.file.bin

    # Make the $(KUBECTL_BIN) variable available in places like genrules.
    # See https://docs.bazel.build/versions/main/be/make-variables.html#custom_variables
    template_variables = platform_common.TemplateVariableInfo({
        "KUBECTL_BIN": binary.path,
    })
    default_info = DefaultInfo(
        files = depset([binary]),
        runfiles = ctx.runfiles(files = [binary]),
    )
    kubectl_info = KubectlInfo(
        bin = binary,
    )

    # Export all the providers inside our ToolchainInfo
    # so the resolved_toolchain rule can grab and re-export them.
    toolchain_info = platform_common.ToolchainInfo(
        kubectlinfo = kubectl_info,
        template_variables = template_variables,
        default = default_info,
    )

    return [default_info, toolchain_info, template_variables]

kubectl_toolchain = rule(
    implementation = _kubectl_toolchain_impl,
    attrs = {
        "bin": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)

def _kubectl_toolchains_repo_impl(rctx):
    # Expose a concrete toolchain which is the result of Bazel resolving the toolchain
    # for the execution or target platform.
    # Workaround for https://github.com/bazelbuild/bazel/issues/14009
    starlark_content = """# @generated by @rules_k8s_cd//kubectl_toolchain.bzl

# Forward all the providers
def _resolved_toolchain_impl(ctx):
    toolchain_info = ctx.toolchains["@rules_k8s_cd//lib:kubectl_toolchain_type"]
    return [
        toolchain_info,
        toolchain_info.default,
        toolchain_info.kubectlinfo,
        toolchain_info.template_variables,
    ]

# Copied from java_toolchain_alias
# https://cs.opensource.google/bazel/bazel/+/master:tools/jdk/java_toolchain_alias.bzl
resolved_toolchain = rule(
    implementation = _resolved_toolchain_impl,
    toolchains = ["@rules_k8s_cd//lib:kubectl_toolchain_type"],
    incompatible_use_toolchain_transition = True,
)
"""
    rctx.file("defs.bzl", starlark_content)

    build_content = """# @generated by @rules_k8s_cd//lib/private:kubectl_toolchain.bzl
#
# These can be registered in the workspace file or passed to --extra_toolchains flag.
# By default all these toolchains are registered by the kubectl_register_toolchains macro
# so you don't normally need to interact with these targets.

load(":defs.bzl", "resolved_toolchain")

resolved_toolchain(name = "resolved_toolchain", visibility = ["//visibility:public"])

"""

    for [platform, meta] in KUBECTL_PLATFORMS.items():
        build_content += """
toolchain(
    name = "{platform}_toolchain",
    exec_compatible_with = {compatible_with},
    toolchain = "@{user_repository_name}_{platform}//:kubectl_toolchain",
    toolchain_type = "@rules_k8s_cd//lib:kubectl_toolchain_type",
)
""".format(
            platform = platform,
            user_repository_name = rctx.attr.user_repository_name,
            compatible_with = meta.compatible_with,
        )

    # Base BUILD file for this repository
    rctx.file("BUILD.bazel", build_content)

kubectl_toolchains_repo = repository_rule(
    _kubectl_toolchains_repo_impl,
    doc = """Creates a repository with toolchain definitions for all known platforms
     which can be registered or selected.""",
    attrs = {
        "user_repository_name": attr.string(doc = "Base name for toolchains repository"),
    },
)

def _kubectl_platform_repo_impl(rctx):
    is_windows = rctx.attr.platform.startswith("windows_")
    meta = KUBECTL_PLATFORMS[rctx.attr.platform]
    release_platform = meta.release_platform if hasattr(meta, "release_platform") else rctx.attr.platform
    download_toolchain_binary(
        rctx = rctx,
        toolchain_name = "kubectl",
        platform = rctx.attr.platform,
        binary = _binaries[rctx.attr.version][rctx.attr.platform],
    )

kubectl_platform_repo = repository_rule(
    implementation = _kubectl_platform_repo_impl,
    doc = "Fetch external tools needed for kubectl toolchain",
    attrs = {
        "platform": attr.string(mandatory = True, values = KUBECTL_PLATFORMS.keys()),
        "version": attr.string(mandatory = False, default = DEFAULT_KUBECTL_VERSION, values = _binaries.keys()),
    },
)


def _kubectl_host_alias_repo(rctx):
    ext = ".exe" if repo_utils.is_windows(rctx) else ""

    # Base BUILD file for this repository
    rctx.file("BUILD.bazel", """# @generated by @rules_k8s_cd//lib/private:kubectl_toolchain.bzl
package(default_visibility = ["//visibility:public"])

exports_files(["kubectl{ext}"])
""".format(
        ext = ext,
    ))

    rctx.symlink("../{name}_{platform}/kubectl{ext}".format(
        name = rctx.attr.name,
        platform = repo_utils.platform(rctx),
        ext = ext,
    ), "kubectl{ext}".format(ext = ext))

kubectl_host_alias_repo = repository_rule(
    _kubectl_host_alias_repo,
    doc = """Creates a repository with a shorter name meant for the host platform, which contains
    a BUILD.bazel file that exports symlinks to the host platform's binaries
    """,
)