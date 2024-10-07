# Source code for my blog article 

- [The Power of Lazy Loading (EN)](https://medium.com/@fabien.chung/the-power-of-lazy-loading-175f978088d8?source=friends_link&sk=547af7d926ae3571a0c84d6d807f892c)
- [La puissance du lazy loading (FR)](https://medium.com/@fabien.chung/la-puissance-du-lazy-loading-56537b28b0b3?source=friends_link&sk=8ba527c05f5b10aee235b20031d3abc8)

⚠️ **This is not a full project** ⚠️  
This repository only contains the part of the code relevant to the blog articles. It is provided for illustrative purposes and **will not build** as a standalone project.

## Flutter Environment

Here is the environment configuration used for this project:

```yaml
environment:
  sdk: '>=3.2.6 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  hooks_riverpod: ^2.4.6
  firebase_core: ^2.25.5
  firebase_core_platform_interface: ^5.0.0
  cloud_firestore: ^4.15.6
  riverpod_annotation: 2.3.1
  go_router: ^13.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: 2.4.6
  riverpod_generator: 2.3.6
  riverpod_lint: 2.3.4
  custom_lint: 0.5.6
